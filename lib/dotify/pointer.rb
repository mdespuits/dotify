module Dotify
  class Pointer
    attr_accessor :source, :destination
    def initialize(source, destination)
      @source = source
      @destination = destination
    end
  end
end