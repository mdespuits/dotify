require 'multi_json'
require 'net/http'

module Dotify
  class VersionChecker
    class << self
      def run_check!
        return if !@version.nil?

        resp = Net::HTTP.get('rubygems.org', '/api/v1/versions/dotify.json')
        json = MultiJson.load(resp)
        @version = json.map { |v| v['number'] }.max
      end

      def current?
        Dotify::VERSION == self.version
      end

      def out_of_date?
        !current?
      end

      def version
        @version || self.run_check!
      end

      def handle_error(e)
        "Version Check Error: #{e.message}\n#{e.backtrace.join("\n")}"
      end
    end
  end
end
