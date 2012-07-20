require 'thor/actions'

module Dotify
  module CLI
    module Utilities
      include Thor::Shell

      def inform(message)
        say message, :blue
      end
    end
  end
end
