require 'configure'

describe 'configure lambda layer' do
  it 'logs dynamoid options' do
    expect_any_instance_of(Logger).to receive(:info).with('test')
    Configure.dynamoid(options: 'test')
  end
end