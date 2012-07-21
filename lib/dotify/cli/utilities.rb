require 'thor/shell'

module Dotify
  module CLI
    module Utilities
      include Thor::Shell

      def self.included(base) #:nodoc:
        base.extend(self)
      end

      def run_if_installed(&blk)
        return yield if Config.installed?
        inform "You need to run 'dotify setup' before you can run this task."
      end

      def inform(message)
        say message, :blue
      end

    end
  end
end
