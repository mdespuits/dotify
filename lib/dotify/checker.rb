module Dotify
  class Checker
    class << self
      def run_check!
        if @version.nil?
          resp = Net::HTTP.get('rubygems.org', '/api/v1/versions/dotify.json')
          json = JSON.parse(resp)
          @version = json.map { |v| v['number'] }.max
        end
        @version
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
    end
  end
end
