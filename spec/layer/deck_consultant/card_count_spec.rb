require 'user'
require 'card_count'

describe DeckConsultant::CardCount do
  describe '.fields' do
    it 'has declared all the required fields' do
      keys = [:card_name, :count, :created_at, :id, :updated_at, :user_ids]
      expect(described_class.attributes.keys).to match_array(keys)
    end
  end

  describe '.associations' do
    let(:expected_associations) {
      [
        [:user, { :type => :belongs_to }]
      ]
    }

    it 'has expected associations' do
      expect(described_class.associations).to match_array(expected_associations)
    end
  end

  describe '#as_hash' do
    it 'return hash' do
      expect(described_class.new(card_name: 'slash', count: 5).as_hash).to eq({ slash: 5 })
    end
  end
end
