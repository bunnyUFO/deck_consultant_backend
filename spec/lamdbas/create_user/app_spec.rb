require_relative '../../../lambdas/create_user/app'

describe 'create deck_consultant lamdba' do
  it 'returns message' do
    expect(Configure).to receive(:dynamoid).with(options: { test: 'test'})
    expect(create_user).to eq({ message: 'testing' })
  end
end