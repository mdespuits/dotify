module Dotify
  class Symlink < Struct.new(:source, :destination)

    def eql?(other)
      self.source == other.source
    end

    def inspect
      %Q{#<Dotify::Symlink @source=#{source}, @destination=#{destination}>}
    end

  end
end
