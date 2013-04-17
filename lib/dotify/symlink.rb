module Dotify
  class Symlink

    attr_reader :source, :destination
    def initialize(source, destination)
      @source = Pathname.new(source)
      @destination = Pathname.new(destination)
    end

    def eql?(other)
      self.source == other.source
    end

    def inspect
      %Q{#<Dotify::Symlink @source=#{source}, @destination=#{destination}>}
    end

  end
end
