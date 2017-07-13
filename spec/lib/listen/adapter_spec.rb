RSpec.describe SassListen::Adapter do

  let(:listener) { instance_double(SassListen::Listener, options: {}) }
  before do
    allow(SassListen::Adapter::BSD).to receive(:usable?) { false }
    allow(SassListen::Adapter::Darwin).to receive(:usable?) { false }
    allow(SassListen::Adapter::Linux).to receive(:usable?) { false }
    allow(SassListen::Adapter::Windows).to receive(:usable?) { false }
  end

  describe '.select' do
    it 'returns Polling adapter if forced' do
      klass = SassListen::Adapter.select(force_polling: true)
      expect(klass).to eq SassListen::Adapter::Polling
    end

    it 'returns BSD adapter when usable' do
      allow(SassListen::Adapter::BSD).to receive(:usable?) { true }
      klass = SassListen::Adapter.select
      expect(klass).to eq SassListen::Adapter::BSD
    end

    it 'returns Darwin adapter when usable' do
      allow(SassListen::Adapter::Darwin).to receive(:usable?) { true }
      klass = SassListen::Adapter.select
      expect(klass).to eq SassListen::Adapter::Darwin
    end

    it 'returns Linux adapter when usable' do
      allow(SassListen::Adapter::Linux).to receive(:usable?) { true }
      klass = SassListen::Adapter.select
      expect(klass).to eq SassListen::Adapter::Linux
    end

    it 'returns Windows adapter when usable' do
      allow(SassListen::Adapter::Windows).to receive(:usable?) { true }
      klass = SassListen::Adapter.select
      expect(klass).to eq SassListen::Adapter::Windows
    end

    context 'no usable adapters' do
      before { allow(Kernel).to receive(:warn) }

      it 'returns Polling adapter' do
        klass = SassListen::Adapter.select(force_polling: true)
        expect(klass).to eq SassListen::Adapter::Polling
      end

      it 'warns polling fallback with default message' do
        msg = described_class::POLLING_FALLBACK_MESSAGE
        expect(Kernel).to receive(:warn).with("[SassListen warning]:\n  #{msg}")
        SassListen::Adapter.select
      end

      it "doesn't warn if polling_fallback_message is false" do
        expect(Kernel).to_not receive(:warn)
        SassListen::Adapter.select(polling_fallback_message: false)
      end

      it 'warns polling fallback with custom message if set' do
        expected_msg = "[SassListen warning]:\n  custom fallback message"
        expect(Kernel).to receive(:warn).with(expected_msg)
        msg = 'custom fallback message'
        SassListen::Adapter.select(polling_fallback_message: msg)
      end
    end
  end
end
