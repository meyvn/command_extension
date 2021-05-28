# frozen_string_literal: true

class ExampleFirstCommand < BaseCommand
  attr_reader :number

  def initialize(number)
    @number = number

    super()
  end

  def execute
    after_commit do
      SidekiqMock.instance.perform(number)
    end

    super
  end
end
