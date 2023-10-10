require 'dynamoid'
require 'card_count'
require 'quest'

module DeckConsultant
  class User
    include Dynamoid::Document
    table name: :users, key: :user_id, read_capacity: 5, write_capacity: 5

    field :username
    field :gold, :integer
    field :reputation, :integer
    has_many :card_counts, class: CardCount
    has_many :quests, class: Quest

    validates_presence_of :username, :gold, :reputation
    validates_numericality_of :gold, :reputation, greater_than_or_equal_to: 0

    def as_hash
      user_data.merge(quest_data).merge({ cards: card_data })
    end

    def user_data
      { user_id: user_id, username: username, gold: gold, reputation: reputation }
    end

    def card_data
      card_counts.reduce({}) { |card_counts, card| card_counts.merge(card.as_hash) }
    end

    def quest_data
      {
        quests: {
          pending: quests.where(complete: false).map(&:as_hash),
          complete: quests.where(complete: true).map(&:as_hash)
        }
      }
    end

    def set_data(gold: nil, reputation: nil, cards: nil)
      self.gold = gold if gold
      self.reputation = reputation if reputation
    end

    def set_cards(cards)
      cards&.each do |card_name, count|
        if count.is_a?(Integer) && card_name.is_a?(String)
          update_card_count(card_name, count) || add_card(card_name, count)
        end
      end
    end

    def set_quests(quests)
      quests&.each do |quest|
        if quest['complete']
          complete_quest(quest['id'])
        else
          add_pending_quest(quest)
        end
      end
    end

    private

    def update_card_count(card_name, count)
      card = card_counts.where(card_name: card_name).first
      return false unless card

      if count > 0
        card.count = count
        card.save!
      else
        card.destroy!
      end

      true
    end

    def add_card(card_name, count)
      card_counts.create(card_name: card_name, count: count) if count > 0
    end

    def complete_quest(quest_id)
      quests&.find(quest_id)&.each { |q| q&.update_attribute(:complete, true) }
    end

    def add_pending_quest(quest_info)
      quests.create(
        scenario_id: quest_info['scenario_id'],
        complete: false,
        random_seed: quest_info['random_seed'],
        duration: quest_info['duration'])
    end
  end
end
