module Dotify
  MAJOR = 0
  MINOR = 6
  PATCH = 6
  RCPRE = nil

  class Version

    def self.build
      @built ||= Version.new
    end

    # Build Dotify's the Semantic Version for Rubygems and Bundler
    def level
      [MAJOR, MINOR, PATCH, RCPRE].compact.join(".")
    end

    def current?
      !!current
    end

    def out_of_date?
      !current
    end
    alias :old? :out_of_date?

    # Delegates checking Rubygems.org to the Checker class
    def current
      Checker.check_latest_release!
    end

    def latest
      Checker.latest_version
    end

    # The Checkup class is responsible for
    # reaching out to Rubygems.org and retrieving
    # the latest gem version.
    class Checker

      class << self
        attr_reader :result, :resp
      end

      def self.check_latest_release!
        @result = latest_version == Version.build.level
      end

      def self.latest_version
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
