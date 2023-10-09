require 'dynamoid'
module DeckConsultant
  class User
    include Dynamoid::Document
    table name: :deck_consultant_users, key: :user_id, read_capacity: 5, write_capacity: 5

    field :username
    field :gold, :integer
    field :reputation, :integer

    validates_numericality_of :gold, greater_than_or_equal_to: 0
    validates_numericality_of :reputation, greater_than_or_equal_to: 0
  end
end
