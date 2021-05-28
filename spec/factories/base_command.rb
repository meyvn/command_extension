# frozen_string_literal: true

class BaseCommand
  include CommandExtension::Base
  include CommandExtension::AfterCommit

  def execute
    after_commit do
      SidekiqMock.instance.perform(number * 2)
    end

    super
  end
end
