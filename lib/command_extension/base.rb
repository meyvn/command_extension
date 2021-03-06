# frozen_string_literal: true

module CommandExtension
  module Base
    def self.included(base)
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def execute; end

      def reset; end
    end
  end
end
