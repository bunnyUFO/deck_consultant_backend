require 'user'

describe DeckConsultant::User do

  describe 'table name' do
    it 'defines the table name' do
      expect(DeckConsultant::User.table_name).to eq('deck_consultant_users')
    end
  end

  describe '#fields' do
    it 'has declared all the required fields' do
      keys = [:user_id, :username, :gold, :reputation, :created_at, :updated_at, ]
      expect(DeckConsultant::User.attributes.keys).to match_array(keys)
    end
  end
end
