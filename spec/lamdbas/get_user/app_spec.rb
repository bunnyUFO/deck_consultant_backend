require_relative '../../../lambdas/get_user/app'

describe 'get user lamdba' do
  let(:event) {{
    "user_id" => 'testid1234'
  }}

  let(:user_params) { { user_id: 'testid1234', username: 'testname', gold: 100, reputation: 0 } }

  context 'when user exists' do
    let!(:user) { DeckConsultant::User.create(user_params)}


    it 'returns user info' do
      expect(DeckConsultant::User).to receive(:find).with('testid1234').and_call_original
      expect(get_user(event: event)). to include(user_params)
    end
  end

  context 'when user does not exist' do
    it 'returns not found message' do
      expect(DeckConsultant::User).to receive(:find).with('testid1234').and_call_original
      expect(get_user(event: event)). to eq({ message: 'User with user_id testid1234 not found' })
    end
  end
end