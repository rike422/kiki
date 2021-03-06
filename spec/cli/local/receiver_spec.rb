require 'spec_helper'

describe Rounders::Commands::LocalCommand, type: :aruba do
  let(:described_class) { Rounders::Commands::LocalCommand }
  let(:described_instance) { described_class.new(arguments) }
  let(:name) { 'Test' }
  let(:work_dir) { 'tmp/aruba/' }
  let(:receiver_name) { 'test_receiver' }
  let(:app_name) { 'test_app' }
  let(:app_dir) { File.join(work_dir, app_name) }

  describe 'rounders plugin' do
    before do
      Rounders::Commands::GlobalCommand.start(%W[new #{app_name} #{work_dir}])
      Dir.chdir(app_dir) do
        stub_const('Rounders::APP_PATH',
                   File.join(Dir.pwd, Rounders::Application.config.app_path).freeze)
        described_class.start(%W[generate receiver #{name} method1])
      end
    end

    after do
      FileUtils.rm_rf File.join(work_dir, app_name)
    end

    describe 'File' do
      before(:each) do
        cd app_name
      end
      it 'should generate receiver template' do
        expect(file?("app/receivers/#{receiver_name}.rb")).to be true
      end
    end
  end
end
