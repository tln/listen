require 'sass-listen/event/config'

RSpec.describe SassListen::Event::Config do
  let(:listener) { instance_double(SassListen::Listener) }
  let(:event_queue) { instance_double(SassListen::Event::Queue) }
  let(:queue_optimizer) { instance_double(SassListen::QueueOptimizer) }
  let(:wait_for_delay) { 1.234 }

  context 'with a given block' do
    let(:myblock) { instance_double(Proc) }

    subject do
      described_class.new(
        listener,
        event_queue,
        queue_optimizer,
        wait_for_delay) do |*args|
          myblock.call(*args)
        end
    end

    it 'calls the block' do
      expect(myblock).to receive(:call).with(:foo, :bar)
      subject.call(:foo, :bar)
    end

    it 'is callable' do
      expect(subject).to be_callable
    end
  end
end
