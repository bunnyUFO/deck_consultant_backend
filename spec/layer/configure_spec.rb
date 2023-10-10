require 'configure'

describe Configure do
  let(:environment) { 'test' }

  describe '.aws' do
    subject { described_class.aws }

    before do
      allow(ENV).to receive(:[])
      allow(ENV).to receive(:[]).with('environment').and_return(environment)
      allow(ENV).to receive(:[]).with('AWS_REGION').and_return('us-west-2')
      allow(Aws.config).to receive(:update)
    end

    context 'when environment is development' do
      let(:environment) { 'development' }

      it 'sets aws configuration with localhost' do
        expect(Aws.config).to receive(:update).with({ region: 'us-west-2', endpoint: 'http://localstack:4566' })
        subject
      end
    end

    context 'when environment is not development' do
      it 'sets aws configuration without localhost' do
        expect(Aws.config).to receive(:update).with({ region: 'us-west-2' })
        subject
      end
    end
  end

  describe 'dynamoid' do
    subject { described_class.dynamoid }

    it 'sets configuraitons' do
      subject
      expect(Dynamoid::Config.namespace).to eq('deck_consultant')
      expect(Dynamoid::Config.timestamps).to eq(true)
    end
  end
end
