require_relative '../../../lambdas/create_user/app'

describe 'create user lamdba' do
  let(:event) {{
    "user_id" => 'testid1234',
    "username" => 'testname',
    "gold" => 100,
    "reputation" => 0
  }}

  it 'configures runtime' do
    expect(Configure).to receive(:aws)
    expect(Configure).to receive(:dynamoid)
    create_user(event: event)
  end

  it 'creates a user' do
    expect(DeckConsultant::User).to receive(:new).with( user_id: 'testid1234',
                                                           username: 'testname',
                                                           gold: 100,
                                                           reputation: 0).and_call_original
    expect(create_user(event: event)). to eq({ message: "Created user with username testname" })
  end

  context 'when there are cards' do
    let(:event) {{
      "user_id" => 'testid1234',
      "username" => 'testname',
      "gold" => 100,
      "reputation" => 0,
      "cards" => { "slash" => 5, "block" => 5}
    }}

    it 'creates a user with cards' do
      expect_any_instance_of(DeckConsultant::User).to receive(:set_cards).with({ "slash" => 5, "block" => 5}).and_call_original
      create_user(event: event)
    end
  end

  context 'when user already exsists' do
    it 'does not create user' do
      create_user(event: event)
      expect(DeckConsultant::User).to receive(:new).with( user_id: 'testid1234',
                                                              username: 'testname',
                                                              gold: 100,
                                                              reputation: 0).and_call_original
      expect(create_user(event: event)). to eq({ message: "User with user_id #{event['user_id']} already exists" })
    end
  end
end