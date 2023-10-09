require 'dynamoid'

module DeckConsultant
  class CardCount
    include Dynamoid::Document

    belongs_to :user
    field :card_id
    field :card_name
    field :count, :integer


  end
end
