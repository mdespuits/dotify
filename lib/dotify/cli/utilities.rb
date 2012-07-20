require 'thor/shell'

module Dotify
  module CLI
    module Utilities
      include Thor::Shell

      def inform(message)
        say message, :blue
      end

      def run_if_installed
        return yield if Config.installed?
        inform "You need to install Dotify before running this task"
      end
    end
  end
end
