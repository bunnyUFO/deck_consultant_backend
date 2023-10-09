require 'user'
require 'card_count'

describe DeckConsultant::User do

  describe 'table name' do
    it 'defines the table name' do
      expect(described_class.table_name).to eq('deck_consultant_users')
    end
  end

  describe '.fields' do
    it 'has declared all the required fields' do
      keys = [:user_id, :username, :gold, :reputation, :card_counts_ids, :created_at, :updated_at,]
      expect(described_class.attributes.keys).to match_array(keys)
    end
  end

  describe '.associations' do
    let(:expected_associations) {
      [
        [:card_counts, { :class => DeckConsultant::CardCount, :type => :has_many }]
      ]
    }

    it 'has expected associations' do
      expect(described_class.associations).to match_array(expected_associations)
    end
  end

  describe '.user_data' do
    let(:user_params) { { user_id: '1', username: 'test', gold: 10, reputation: 10 } }
    let!(:user) { described_class.create(user_params) }

    it 'retuns hash with user data' do
      expect(user.user_data).to eq(user_params)
    end
  end

  describe '.card_data' do
    let(:cards) { { "slash" => 5, "block" => 5 } }
    let(:user_params) { { user_id: '1', username: 'test', gold: 10, reputation: 10 } }

    let!(:user) { described_class.create(user_params) }
    let!(:card) { cards.map { |n, c| user.card_counts.create(card_name: n, count: c) } }

    it 'returns hash with card counts' do
      expect(user.card_data).to eq(cards)
    end
  end

  describe '.set_data' do
    let(:user_params) { { user_id: '1', username: 'test', gold: 100, reputation: 0 } }
    let!(:user) { described_class.create(user_params) }

    it 'creates a user with cards' do
      expect {
        user.set_data(gold: 10, reputation: 10)
        user.save!
      }.to change {
        user.reload.gold
      }.from(100).to(10)
       .and change {
         user.reload.reputation
       }.from(0).to(10)
    end
  end

  describe '.set_cards' do
    let(:cards) { { "slash" => 5, "block" => 5 } }
    let(:user_params) { { user_id: '1', username: 'test', gold: 10, reputation: 10 } }

    let!(:user) { described_class.create(user_params) }
    let!(:card) { user.card_counts.create(card_name: 'slash', count: 1) }

    it 'creates a user with cards' do
      expect(user.card_counts).not_to receive(:create).with(card_name: 'slash', count: 5)
      expect(user.card_counts).to receive(:create).with(card_name: 'block', count: 5)
      expect { user.set_cards(cards) }.to change { card.reload.count }.from(1).to(5)
    end
  end
end
