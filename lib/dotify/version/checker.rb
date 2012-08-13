module Dotify
  class Version
    # The Checkup class is responsible for
    # reaching out to Rubygems.org and retrieving
    # the latest gem version.
    class Checker

      class << self
        attr_reader :result, :resp
      end

      def self.check_latest_release!
        @result = (latest == Version.build.level)
      end

      def self.latest
        fetch.map { |v| v['number'] }.max
      end

      private

        def self.fetch
          require 'multi_json'
          @resp = Net::HTTP.get('rubygems.org', '/api/v1/versions/dotify.json')
          MultiJson.load(@resp)
        end

    end
  end
end