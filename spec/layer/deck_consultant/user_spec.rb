require 'user'
require 'card_count'
require 'quest'

describe DeckConsultant::User do
  let(:deck) { { slash: 10 } }
  let(:user_params) { { user_id: 'testid1234', username: 'testname', gold: 100, reputation: 0, card_counts: deck } }
  subject(:user) { DeckConsultant::User.create(user_params) }

  describe 'table name' do
    it 'defines the table name' do
      expect(described_class.table_name).to eq('deck_consultant_users')
    end
  end

  describe '.fields' do
    it 'has declared all the required fields' do
      keys = [:user_id, :username, :gold, :reputation, :card_counts, :quests_ids, :created_at, :updated_at,]
      expect(described_class.attributes.keys).to match_array(keys)
    end
  end

  describe '.associations' do
    let(:expected_associations) {
      [
        [:quests, { :class => DeckConsultant::Quest, :type => :has_many }]
      ]
    }

    it 'has expected associations' do
      expect(described_class.associations).to match_array(expected_associations)
    end
  end

  describe '#as_hash' do
    let(:pending_quest_data) { { scenario_id: 1, complete: false, random_seed: 10, duration: 60, deck: deck } }
    let(:completed_quest_data) { { scenario_id: 2, complete: true, random_seed: 98, duration: 60, deck: deck } }

    let!(:pending_quest) { user.quests.create(pending_quest_data) }
    let!(:completed_quest) { user.quests.create(completed_quest_data).update_attribute(:created_at, Time.now.beginning_of_day) }

    let(:expected_hash) {
      {
        user_id: "testid1234",
        username: "testname",
        gold: 100,
        reputation: 0,
        quests: {
          complete: [{ id: completed_quest.id, complete: true, random_seed: 98,
                       scenario_id: 2, duration: 60, remaining: 0, deck: deck }],
          pending: [{ id: pending_quest.id, complete: false, random_seed: 10,
                      scenario_id: 1, duration: 60, remaining: 60, deck: deck }]
        },
        cards: deck
      }
    }

    it 'returns hash with data' do
      expect(user.as_hash).to eq(expected_hash)
    end
  end

  describe '#user_data' do
    it 'returns hash with user data' do
      expect(user.user_data).to eq({ user_id: 'testid1234', username: 'testname', gold: 100, reputation: 0, cards: deck })
    end
  end

  describe '#quest_data' do
    let(:pending_quest_data) { { id: '1', scenario_id: 1, complete: false, random_seed: 10, duration: 10, deck: deck } }
    let(:completed_quest_data) { { id: '2', scenario_id: 2, complete: true, random_seed: 98, duration: 10, deck: deck } }
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

  describe '#set_cards' do
    let(:card_counts) { { pierce: 5, block: 5 } }

    it 'sets card data' do
      expect {
        user.set_cards(card_counts)
      }.to change { user.cards }.from({ slash: 10 }).to({ pierce: 5, block: 5 })
    end
  end

  describe '#set_quests' do
    let(:quest_data) { [
      { "id" => "testid", "complete" => true },
      { "scenario_id" => 2, "complete" => false, "random_seed" => 2, "duration" => 100, "deck" => { "slash" => 10 } }
    ] }
    let!(:quest) { user.quests.create(id: "testid", complete: false, scenario_id: 1, random_seed: 1, duration: 10, deck: { slash: 10 }) }

    it 'sets quest data for pending and complete quests' do
      expect(user.quests).to receive(:create).with(scenario_id: 2, complete: false, random_seed: 2, duration: 100, deck: { slash: 10 })
      expect { user.set_quests(quest_data) }.to change { quest.reload.complete }.from(false).to(true)
    end
  end

  describe '#destroy' do
    it 'also destroys quests' do
      expect(user.quests).to receive(:destroy_all)
      user.destroy
    end
  end
end
