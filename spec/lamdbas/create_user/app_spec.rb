require_relative '../../../lambdas/create_user/app'

describe 'create user lamdba' do
  let(:event) { {
    "user_id" => 'testid1234',
    "username" => 'testname',
    "gold" => 100,
    "reputation" => 0,
    "cards" => { "slash" => 5, "block" => 5 }
  } }

  it 'configures runtime' do
    expect(Configure).to receive(:aws)
    expect(Configure).to receive(:dynamoid)
    create_user(event: event)
  end

  it 'creates a user' do
    expect(DeckConsultant::User).to receive(:create!).with(user_id: 'testid1234',
                                                       username: 'testname',
                                                       gold: 100,
                                                       reputation: 0,
                                                       card_counts: { slash: 5, block: 5 }).and_call_original
    expect(create_user(event: event)).to eq({ message: "Created user with username testname" })
  end

  context 'when user already exists' do
    it 'does not create user' do
      create_user(event: event)
      expect(create_user(event: event)).to eq({ message: "User with user_id #{event['user_id']} already exists" })
    end
  end
end