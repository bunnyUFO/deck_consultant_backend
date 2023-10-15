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
    field :card_counts, :map
    has_many :quests, class: Quest

    validates_presence_of :username, :gold, :reputation, :card_counts
    validates_numericality_of :gold, :reputation, greater_than_or_equal_to: 0
    validate :card_counts_valid?

    # Using destroy hook because dependent destroy is not supported by dynamoid has_many association
    before_destroy :destroy_quests

    def as_hash
      user_data.merge(quest_data)
    end

    def user_data
      { user_id: user_id, username: username, gold: gold, reputation: reputation, cards: cards }
    end

    def quest_data
      {
        quests: {
          pending: quests.where(complete: false).map(&:as_hash),
          complete: quests.where(complete: true).map(&:as_hash)
        }
      }
    end

    def set_cards(cards)
      return unless cards.is_a? Hash
      self.card_counts = cards.reduce({}) do |counts, (card, count)|
        counts[card.to_sym] = count if count.is_a?(Numeric) && count > 0
        counts
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

    def cards
      card_counts.transform_values(&:to_i)
    end

    private
    def complete_quest(quest_id)
      quests&.find(quest_id)&.each { |q| q&.update_attribute(:complete, true) }
    end

    def add_pending_quest(quest_info)
      quests.create(
        scenario_id: quest_info['scenario_id'],
        complete: false,
        random_seed: quest_info['random_seed'],
        duration: quest_info['duration'],
        deck: quest_info['deck']&.transform_keys(&:to_sym))
    end

    def card_counts_valid?
      return errors.add(:deck, "deck must be a Hash object") unless card_counts.is_a? Hash
      return errors.add(:deck, "all keys must be strings") unless card_counts&.keys.all? { |k| k.is_a?(String) || k.is_a?(Symbol)}
      errors.add(:deck, "all values must be integers") unless card_counts&.values.all? { |v| v.is_a?(Numeric) }
    end

    def destroy_quests
      quests.destroy_all
    end
  end
end
