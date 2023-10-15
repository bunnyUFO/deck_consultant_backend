require_relative '../../../lambdas/delete_user/app'

describe 'delete lamdba' do
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

    it 'returns delete message' do
      expect(delete_user(event: event)).to eq({ message: "Deleted user with username testname" })
    end

    it 'returns deletes user and quests' do
      expect { delete_user(event: event) }
        .to change {
          DeckConsultant::User.all.count
        }.by(-1)
         .and change { DeckConsultant::Quest.all.count }.by(-2)
    end
  end

  context 'when user does not exist' do
    it 'returns not found message' do
      expect(DeckConsultant::User).to receive(:find).with('testid1234').and_call_original
      expect(delete_user(event: event)).to eq({ message: 'User with user_id testid1234 not found' })
    end
  end
end