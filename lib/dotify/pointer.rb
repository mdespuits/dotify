module Dotify
  class Pointer
    attr_accessor :source, :destination
    def initialize(source, destination)
      @source = source
      @destination = destination
    end

    def to_s
      "Pointer#<source: #{source} destination: #{desination}"
    end
  end
end