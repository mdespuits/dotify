module Dotify
  class Pointer < Struct.new(:source, :destination)

    def eql?(other)
      self.source == other.source
    end

    def inspect
      %Q{#<Dotify::Pointer @source=#{source}, @destination=#{destination}>}
    end

  end
end
