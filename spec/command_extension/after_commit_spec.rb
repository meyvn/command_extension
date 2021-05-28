# frozen_string_literal: true

RSpec.describe CommandExtension::AfterCommit do # rubocop:disable Metrics/BlockLength
  let(:number) { rand(1000) }

  describe '#execute' do
    context 'example first command' do
      let(:command) { ExampleFirstCommand.new(number) }

      it 'calls sidekiq mock' do
        expect(SidekiqMock.instance).to receive(:perform).ordered.with(number)
        expect(SidekiqMock.instance).to receive(:perform).ordered.with(number * 2)

        command.execute
      end
    end

    context 'example second command' do
      let(:command) { ExampleSecondCommand.new(number) }

      it 'calls sidekiq mock' do
        expect(SidekiqMock.instance).to receive(:perform).ordered.with(number * 2)

        command.execute
      end
    end

    context 'example third command' do
      let(:command) { ExampleThirdCommand.new(number) }

      it 'calls sidekiq mock' do
        expect(SidekiqMock.instance).to receive(:perform).ordered.with(number)
        expect(SidekiqMock.instance).to receive(:perform).ordered.with(number * 2)
        expect(SidekiqMock.instance).to receive(:perform).ordered.with(number * 3)
        expect(SidekiqMock.instance).to receive(:perform).ordered.with(number * 2)

        command.execute
      end
    end
  end
end
