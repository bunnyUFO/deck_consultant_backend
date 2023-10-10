require 'dynamoid'

module DeckConsultant
  class CardCount
    include Dynamoid::Document
    table name: :card_counts, read_capacity: 5, write_capacity: 5

    belongs_to :user
    field :card_name
    field :count, :integer

    validates_presence_of :card_name, :count

    def as_hash
      {}.tap{|h| h[card_name.to_sym] = count }
    end
  end
end
