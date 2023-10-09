require 'user'
require 'card_count'

describe DeckConsultant::CardCount do
  describe '.fields' do
    it 'has declared all the required fields' do
      keys = [:card_id, :card_name, :count, :created_at, :id, :updated_at, :user_ids]
      expect(described_class.attributes.keys).to match_array(keys)
    end
  end

  describe '.associations' do
    let(:expected_associations) {
      [
        [:user, {:type=>:belongs_to}]
      ]
    }

    it 'has expected associations' do
      expect(described_class.associations).to match_array(expected_associations)
    end
  end
end
