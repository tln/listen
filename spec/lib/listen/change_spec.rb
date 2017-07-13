RSpec.describe SassListen::Change do
  let(:config) { instance_double(SassListen::Change::Config) }
  let(:dir) { instance_double(Pathname) }
  let(:record) { instance_double(SassListen::Record, root: '/dir') }
  subject { SassListen::Change.new(config, record) }

  let(:full_file_path) { instance_double(Pathname, to_s: '/dir/file.rb') }
  let(:full_dir_path) { instance_double(Pathname, to_s: '/dir') }

  before do
    allow(dir).to receive(:+).with('file.rb') { full_file_path }
    allow(dir).to receive(:+).with('dir1') { full_dir_path }
  end

  describe '#change' do
    before do
      allow(config).to receive(:silenced?).and_return(false)
    end

    context 'with build options' do
      it 'calls still_building! on record' do
        allow(config).to receive(:queue)
        allow(SassListen::File).to receive(:change)
        subject.invalidate(:file, 'file.rb', build: true)
      end
    end

    context 'file' do
      context 'with known change' do
        it 'notifies change directly to listener' do
          expect(config).to receive(:queue).
            with(:file, :modified, Pathname.new('/dir'), 'file.rb', {})

          subject.invalidate(:file, 'file.rb', change: :modified)
        end

        it "doesn't notify to listener if path is silenced" do
          expect(config).to receive(:silenced?).and_return(true)
          expect(config).to_not receive(:queue)
          subject.invalidate(:file, 'file.rb', change: :modified)
        end
      end

      context 'with unknown change' do

        it 'calls SassListen::File#change' do
          expect(SassListen::File).to receive(:change).with(record, 'file.rb')
          subject.invalidate(:file, 'file.rb', {})
        end

        it "doesn't call SassListen::File#change if path is silenced" do
          expect(config).to receive(:silenced?).
            with('file.rb', :file).and_return(true)

          expect(SassListen::File).to_not receive(:change)
          subject.invalidate(:file, 'file.rb', {})
        end

        context 'that returns a change' do
          before { allow(SassListen::File).to receive(:change) { :modified } }

          context 'listener listen' do
            it 'notifies change to listener' do
              expect(config).to receive(:queue).
                with(:file, :modified, Pathname.new('/dir'), 'file.rb')

              subject.invalidate(:file, 'file.rb', {})
            end

            context 'silence option' do
              it 'notifies change to listener' do
                expect(config).to_not receive(:queue)
                subject.invalidate(:file, 'file.rb', silence: true)
              end
            end
          end
        end

        context 'that returns no change' do
          before { allow(SassListen::File).to receive(:change) { nil } }

          it "doesn't notifies no change" do
            expect(config).to_not receive(:queue)
            subject.invalidate(:file, 'file.rb', {})
          end
        end
      end
    end

    context 'directory' do
      let(:dir_options) { { recursive: true } }

      it 'calls SassListen::Directory#new' do
        expect(SassListen::Directory).to receive(:scan).
          with(subject, 'dir1', dir_options)

        subject.invalidate(:dir, 'dir1', dir_options)
      end
    end
  end
end
