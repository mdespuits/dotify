module Dotify
  class Collection

    include Enumerable

    attr_accessor :units

    # Pulls an array of Units from the home
    # directory.
    def initialize
      @units ||= Filter.home
    end

    # Defined each method for Enumerable
    def each(&block)
      self.units.each(&block)
    end

    # Linked files are those files which have a
    # symbolic link pointing to the Dotify file.
    def linked
      select(&:linked?)
    end

    # Unlinked files are, of course, the opposite
    # of linked files. These are Dotify files which
    # Have no home dir files that are linked to them.
    def unlinked
      reject(&:linked?)
    end

    def to_s
      units.to_s
    end

    def inspect
      units.map(&:inspect)
    end

  end
end
