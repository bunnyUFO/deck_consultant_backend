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

    validates_presence_of :scenario_id, :random_seed, :complete, :duration

    def as_hash
      { id: id,
        scenario_id: scenario_id,
        complete: complete,
        random_seed: random_seed,
        duration: duration,
        remaining: [0, duration - (Time.now - created_at).to_i].max }
    end
  end
end
