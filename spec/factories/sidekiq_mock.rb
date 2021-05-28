# frozen_string_literal: true

class SidekiqMock
  include Singleton

  def perform(number); end
end
