require 'user'
require 'quest'

describe DeckConsultant::Quest do
  describe '.fields' do
    it 'has declared all the required fields' do
      keys = [:complete, :random_seed, :scenario_id, :duration, :deck, :created_at, :id, :updated_at, :user_ids]
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

  describe 'validations' do
    describe 'deck' do
      let(:deck) { { slash: 5, block: 5 } }
      let(:create_params) { { id: 'testid', scenario_id: 1, complete: false,
                              random_seed: 1, duration: 60,
                              deck: deck
      } }

      subject { described_class.create!(create_params) }

      context 'deck key is not string or symbol' do
        let(:deck) { { 1 => 5, "block" => 5 } }

        it 'raises error with correct error message' do
          expect{subject}.to raise_error(
                               Dynamoid::Errors::DocumentNotValid,
                               'Validation failed: Deck all keys must be strings')
        end
      end

      context 'deck value is not integer' do
        let(:deck) { { "slash" => '5', "block" => 5 } }

        it 'raises error with correct error message' do
          expect{subject}.to raise_error(
                               Dynamoid::Errors::DocumentNotValid,
                               'Validation failed: Deck all values must be integers')
        end
      end

      context 'when values do not add up to deck card count' do
        let(:deck) { { slash: 1, block: 5 } }

        it 'raises error with correct error message' do
          expect{subject}.to raise_error(
                               Dynamoid::Errors::DocumentNotValid,
                               'Validation failed: Deck card count values must add up to deck size 10')
        end
      end
    end

    describe '#as_hash' do
      let(:create_params) { { id: 'testid', scenario_id: 1, complete: false,
                              random_seed: 1, duration: 60,
                              deck: { slash: 5, block: 5 }
      } }

      it 'return hash' do
        expect(described_class.create!(create_params).as_hash).to eq(create_params.merge(remaining: 60))
      end
    end
  end
end
