require 'dotify/cli'
require 'thor/actions'

module Dotify
  module CLI
    module Utilities
      extend Thor::Actions

      def inform(message)
        say message, :blue
      end
    end
  end
end
