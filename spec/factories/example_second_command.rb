# frozen_string_literal: true

class ExampleSecondCommand < BaseCommand
  attr_reader :number

  def initialize(number)
    @number = number

    super()
  end
end
