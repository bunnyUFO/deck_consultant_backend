require 'dynamoid'

module DeckConsultant
  class Quest
    include Dynamoid::Document
    table name: :quests, read_capacity: 5, write_capacity: 5

    belongs_to :user
    field :scenario_id, :integer
    field :complete, :boolean
    field :random_seed, :integer
    field :duration, :integer
    field :deck, :map

    validates_presence_of :scenario_id, :random_seed, :complete, :duration
    validate :valid_deck?
    def as_hash
      {
        id: id,
        scenario_id: scenario_id,
        complete: complete,
        random_seed: random_seed,
        duration: duration,
        remaining: [0, duration - (Time.now - created_at).to_i].max,
        deck: deck.transform_values(&:to_i)
      }
    end

    private
    def valid_deck?
      return errors.add(:deck, "deck must be a Hash object") unless deck.is_a? Hash
      return errors.add(:deck, "all keys must be strings") unless deck.keys.all? { |k| k.is_a?(String) || k.is_a?(Symbol)}
      return errors.add(:deck, "all values must be integers") unless deck.values.all? { |v| v.is_a?(Numeric) }
    end
  end
end
