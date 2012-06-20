require 'dotify/errors'

module Dotify
  class Configuration

    SHELLS = {
      :zsh => '/bin/zsh',
      :bash => '/bin/bash',
      :sh => '/bin/sh'
    }

    class << self

      def shell=(shell)
        if !SHELLS.keys.include?(shell)
          raise NonValidShell, "You must specify a valid shell: #{SHELLS.keys.map(&:inspect).join(", ")}"
        end
        @shell = shell
      end

      def shell
        @shell
      end

      def profile=(name)
        @name = name.to_s
      end

      def profile
        @name
      end

    end
  end
end
