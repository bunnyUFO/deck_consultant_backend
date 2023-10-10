require 'dynamoid'

module DeckConsultant
  class CardCount
    include Dynamoid::Document
    table name: :card_counts, read_capacity: 5, write_capacity: 5

    belongs_to :user
    field :card_id
    field :card_name
    field :count, :integer
  end
end
