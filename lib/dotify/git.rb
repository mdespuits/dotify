require 'dotify/config'

module Dotify
  class Git

    extend ::Git

    class << self

      def repo
        @repo ||= git.open(Config.path)
      end

      private

        def git
          ::Git
        end

    end
  end
end
