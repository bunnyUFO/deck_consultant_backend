require 'user'
require 'card_count'
require 'quest'

describe DeckConsultant::User do

  describe 'table name' do
    it 'defines the table name' do
      expect(described_class.table_name).to eq('deck_consultant_users')
    end
  end

  describe '.fields' do
    it 'has declared all the required fields' do
      keys = [:user_id, :username, :gold, :reputation, :card_counts_ids, :quests_ids, :created_at, :updated_at,]
      expect(described_class.attributes.keys).to match_array(keys)
    end
  end

  describe '.associations' do
    let(:expected_associations) {
      [
        [:card_counts, { :class => DeckConsultant::CardCount, :type => :has_many }],
        [:quests, { :class => DeckConsultant::Quest, :type => :has_many }]
      ]
    }

    it 'has expected associations' do
      expect(described_class.associations).to match_array(expected_associations)
    end
  end

  describe '#as_hash' do
    let(:user_params) { { user_id: 'testid1234', username: 'testname', gold: 100, reputation: 0 } }
    let(:card_hash) { { slash: 5, block: 5 } }
    let(:pending_quest_data) { { scenario_id: 1, complete: false, random_seed: 10, duration: 60 } }
    let(:completed_quest_data) { { scenario_id: 2, complete: true, random_seed: 98, duration: 60 } }

    let!(:user) { DeckConsultant::User.create(user_params) }
    let!(:pending_quest) { user.quests.create(pending_quest_data) }
    let!(:completed_quest) { user.quests.create(completed_quest_data).update_attribute(:created_at, Time.now.beginning_of_day) }
    let!(:cards) { card_hash.map { |n, c| user.card_counts.create(card_name: n, count: c) } }

    let(:expected_hash) {
      {
        user_id: "testid1234",
        username: "testname",
        gold: 100,
        reputation: 0,
        quests: {
          complete: [{ id: completed_quest.id, complete: true, random_seed: 98, scenario_id: 2, duration: 60, remaining: 0}],
          pending: [{ id: pending_quest.id, complete: false, random_seed: 10, scenario_id: 1, duration: 60, remaining: 60 }]
        },
        cards: card_hash
      }
    }

    it 'returns hash with data' do
      expect(user.as_hash).to eq(expected_hash)
    end
  end

  describe '#user_data' do
    let(:user_params) { { user_id: '1', username: 'test', gold: 10, reputation: 10 } }
    let!(:user) { described_class.create(user_params) }

    it 'retuns hash with user data' do
      expect(user.user_data).to eq(user_params)
    end
  end

  describe '#card_data' do
    let(:cards) { { slash: 5, block: 5 } }
    let(:user_params) { { user_id: '1', username: 'test', gold: 10, reputation: 10 } }

    let!(:user) { described_class.create(user_params) }
    let!(:card) { cards.map { |n, c| user.card_counts.create(card_name: n, count: c) } }

    it 'returns hash with card counts' do
      expect(user.card_data).to eq(cards)
    end
  end

  describe '#quest_data' do
    let(:pending_quest_data) { { id: '1', scenario_id: 1, complete: false, random_seed: 10, duration: 10 } }
    let(:completed_quest_data) { { id: '2', scenario_id: 2, complete: true, random_seed: 98, duration: 10} }
    let(:user_params) { { user_id: '1', username: 'test', gold: 10, reputation: 10 } }

    let!(:user) { described_class.create(user_params) }
    let!(:pending_quest) { user.quests.create(pending_quest_data) }
    let!(:completed_quest) { user.quests.create(completed_quest_data).update_attribute(:created_at, Time.now.beginning_of_day) }

    let(:expected_quests) {
      {
        quests: {
          pending: [pending_quest_data.merge(remaining: 10)],
          complete: [completed_quest_data.merge(remaining: 0)]
        }
      }
    }

    it 'returns hash with quests' do
      expect(user.quest_data).to eq(expected_quests)
    end
  end

  describe '#set_data' do
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

  describe '#set_cards' do
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

  describe '#set_quests' do
    let(:quest_data) { [
      { "id" => "testid", "complete" => true },
      { "scenario_id" => 2, "complete" => false, "random_seed" => 2, "duration" => 100 }
    ] }

    let(:user_params) { { user_id: '1', username: 'test', gold: 10, reputation: 10 } }

    let!(:user) { described_class.create(user_params) }
    let!(:quest) { user.quests.create(id: "testid", complete: false, scenario_id: 1, random_seed: 1, duration: 10) }

    it 'creates a user with cards' do
      expect(user.quests).to receive(:create).with(scenario_id: 2, complete: false, random_seed: 2, duration: 100 )
      expect { user.set_quests(quest_data) }.to change { quest.reload.complete }.from(false).to(true)
    end
  end
end
