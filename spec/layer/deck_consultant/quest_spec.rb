require 'user'
require 'quest'

describe DeckConsultant::Quest do
  describe '.fields' do
    it 'has declared all the required fields' do
      keys = [:complete, :random_seed, :scenario_id, :duration, :created_at, :id, :updated_at, :user_ids]
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
    let(:create_params) { { id: 'testid', scenario_id: 1, complete: false, random_seed: 1, duration:  60}}

    it 'return hash' do
      expect(described_class.create(create_params).as_hash).to eq(create_params.merge(remaining: 60))
    end
  end
end
