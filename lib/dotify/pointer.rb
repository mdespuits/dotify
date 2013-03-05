module Dotify
  class Pointer < Struct.new(:source, :destination)

    def eql?(other)
      self.source == other.source
    end

  end
end
