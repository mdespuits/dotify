module Dotify
  class Pointer < Struct.new(:source, :destination)
    def to_s
      %{#<Dotify::Pointer source: "#{source}" destination: "#{destination}">}
    end
  end
end
