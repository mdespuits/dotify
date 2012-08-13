module Dotify
  class Pointer
    attr_accessor :source, :destination
    def initialize(source, destination)
      @source = source
      @destination = destination
    end

    def to_s
      "{ \"#{source}\" => \"#{destination}\" }"
    end
  end
end