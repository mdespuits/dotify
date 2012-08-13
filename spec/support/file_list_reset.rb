module Dotify
  class FileList
    def self.reset!
      @pointers = []
    end
  end
end

RSpec.configure do |c|
  c.before(:each) { Dotify::FileList.reset! }
end
