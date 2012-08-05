module Dotify
  MAJOR = 0
  MINOR = 6
  PATCH = 6
  PRE   = nil

  class Version

    def self.build
      @built ||= Version.new
    end

    # Build Dotify's the Semantic Version for Rubygems and Bundler
    def level
      [MAJOR, MINOR, PATCH, PRE].compact.join(".")
    end

    def current?
      !!Checker.check_latest_release!
    end

    def out_of_date?
      !current?
    end
    alias :old? :out_of_date?

    def latest
      Checker.latest
    end

    # The Checkup class is responsible for
    # reaching out to Rubygems.org and retrieving
    # the latest gem version.
    class Checker

      class << self
        attr_reader :result, :resp
      end

      def self.check_latest_release!
        @result = latest == Version.build.level
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
