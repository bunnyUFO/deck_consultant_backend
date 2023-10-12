require_relative '../../../lambdas/get_user/app'

describe 'get user lamdba' do
  let(:event) { {
    "user_id" => 'testid1234'
  } }

  let(:user_params) { { user_id: 'testid1234', username: 'testname', gold: 100, reputation: 0, card_counts: { block: 10 } } }
  let(:cards) { { slash: 5, block: 5 } }
  let(:pending_quest_data) { { scenario_id: 1, complete: false, random_seed: 10, duration: 10, deck: { slash: 10 } } }
  let(:completed_quest_data) { { scenario_id: 2, complete: true, random_seed: 98, duration: 10, deck: { slash: 10 } } }

  context 'when user exists' do
    let!(:user) { DeckConsultant::User.create(user_params) }
    let!(:pending_quest) { user.quests.create(pending_quest_data) }
    let!(:completed_quest) { user.quests.create(completed_quest_data) }

    it 'returns user info' do
      expect(DeckConsultant::User).to receive(:find).with('testid1234').and_call_original
      expect(get_user(event: event)).to eq(user.as_hash)
    end
  end

  context 'when user does not exist' do
    it 'returns not found message' do
      expect(DeckConsultant::User).to receive(:find).with('testid1234').and_call_original
      expect(get_user(event: event)).to eq({ message: 'User with user_id testid1234 not found' })
    end
  end
end