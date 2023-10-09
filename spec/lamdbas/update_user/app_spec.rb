require_relative '../../../lambdas/update_user/app'

describe 'update user lamdba' do
  let(:event) { {
    "user_id" => 'testid1234',
    "gold" => 10,
    "reputation" => 10
  } }

  let(:user_params) { { user_id: 'testid1234', username: 'testname', gold: 100, reputation: 0 } }

  context 'when user exists' do
    let!(:user) { DeckConsultant::User.create(user_params) }

    it 'returns new updated user' do
      expect(update_user(event: event)).to include(event.transform_keys(&:to_sym))
    end

    it 'update user info' do
      expect { update_user(event: event) }.to change {
        user.reload.gold
      }.from(100).to(10)
       .and change {
         user.reload.reputation
       }.from(0).to(10)
    end

    context 'when data to update is the same' do
      let(:event) { {
        "user_id" => 'testid1234',
        "gold" => 100,
        "reputation" => 0
      } }
      let(:error_message) { "Validation failed: Gold must be greater than or equal to 0, Reputation must be greater than or equal to 0" }

      it 'does not update user info' do
        expect(user).not_to receive(:save!)
        expect(update_user(event: event)).to eq({ warning: "user not changed since it already has same values" })
      end
    end

    context 'when data to update is not sent' do
      it 'does not update user info' do
        expect { update_user(event: { "user_id" => 'testid1234' }) }.to not_change { user.gold }.and not_change { user.reputation }
      end
    end

    context 'when data to update is invalid' do
      let(:event) { {
        "user_id" => 'testid1234',
        "gold" => -1,
        "reputation" => -1
      } }
      let(:error_message) { "Validation failed: Gold must be greater than or equal to 0, Reputation must be greater than or equal to 0" }

      it 'does not update user info' do
        expect { update_user(event: event) }.to not_change { user.gold }.and not_change { user.reputation }
      end

      it 'returns error message' do
        expect(update_user(event: event)).to eq({ error: error_message })
      end
    end
  end

  context 'when user does not exist' do
    it 'returns not found message' do
      expect(DeckConsultant::User).to receive(:find).with('testid1234').and_call_original
      expect(update_user(event: event)).to eq({ message: 'User with user_id testid1234 not found' })
    end
  end
end