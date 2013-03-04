module Dotify
  class Pointer < Struct.new(:source, :destination)

    def eql?(other)
      self.source == other.source
    end

    def to_s
      %{#<Dotify::Pointer source: "#{source}" destination: "#{destination}">}
    end
  end
end
