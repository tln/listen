RSpec.describe SassListen do
  let(:listener) { instance_double(SassListen::Listener, stop: nil) }

  after do
    SassListen.stop
  end

  describe '.to' do
    it 'initalizes listener' do
      expect(SassListen::Listener).to receive(:new).with('/path') { listener }
      described_class.to('/path')
    end
  end

  describe '.stop' do
    it 'stops all listeners' do
      allow(SassListen::Listener).to receive(:new).with('/path') { listener }
      expect(listener).to receive(:stop)
      described_class.to('/path')
      SassListen.stop
    end
  end
end
