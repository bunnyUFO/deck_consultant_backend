require 'dynamoid'
require 'card_count'

module DeckConsultant
  class User
    include Dynamoid::Document
    table name: :users, key: :user_id, read_capacity: 5, write_capacity: 5

    field :username
    field :gold, :integer
    field :reputation, :integer
    has_many :card_counts, class: CardCount

    validates_presence_of :username, :gold, :reputation
    validates_numericality_of :gold, :reputation, greater_than_or_equal_to: 0

    def user_data
      { user_id: user_id, username: username, gold: gold, reputation: reputation }
    end
    def card_data
      card_counts.reduce({}) do |card_counts, card|
        card_counts[card.card_name] =   card.count
        card_counts
      end
    end

    def set_data(gold: nil, reputation: nil, cards: nil)
      self.gold = gold if gold
      self.reputation =reputation if reputation
    end
    def set_cards(cards)
      cards&.each do |card_name, count|
        if count.is_a?(Integer) && card_name.is_a?(String)
          update_card_count(card_name, count) || add_card(card_name, count)
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
  end
end
