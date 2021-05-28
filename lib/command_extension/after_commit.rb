# frozen_string_literal: true

module CommandExtension
  module AfterCommit
    def self.included(base)
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module InstanceMethods
      attr_writer :after_commit_queue_enabled

      def after_commit_queue
        @after_commit_queue ||= []
      end

      def reset
        @after_commit_queue = nil
        super
      end

      def after_commit(method = nil, &block)
        after_commit_queue << proc { send(method) } if method
        after_commit_queue << block if block
        true
      end

      def after_commit_queue_enabled
        @after_commit_queue_enabled = true if @after_commit_queue_enabled.nil?
        @after_commit_queue_enabled
      end

      def after_commit_queue_enabled?
        after_commit_queue_enabled
      end

      def execute
        run_after_commit_queue if after_commit_queue_enabled?
        super
      end

      def subcommand(command)
        command.after_commit_queue_enabled = false
        after_commit do
          command.run_after_commit_queue
        end
        command
      end

      def run_after_commit_queue
        self.class.run_after_commit_queue(self)
        after_commit_queue.each(&:call)
      end
    end

    module ClassMethods
      def after_commit_queue
        @after_commit_queue ||= []
      end

      def after_commit(method = nil, &block)
        after_commit_queue << method if method
        after_commit_queue << block if block
        true
      end

      def run_after_commit_queue(instance)
        after_commit_queue.each do |m|
          case m
          when Symbol, String
            instance.__send__(m)
          else
            instance.instance_eval(m)
          end
        end
      end
    end
  end
end
