# frozen_string_literal: true

class ExampleThirdCommand < BaseCommand
  attr_reader :number

  def initialize(number)
    @number = number

    super()
  end

  def execute
    subcommand(ExampleFirstCommand.new(number)).execute

    after_commit do
      SidekiqMock.instance.perform(number * 3)
    end

    super
  end
end
