module Dotify
  class Collection

    include Enumerable

    def self.home
      Collection.new(dotfiles(Config.home(".*"))).ignore(:dotfiles)
    end

    def self.dotify
      Collection.new(dotfiles(Config.path(".*"))).ignore(:dotify)
    end

    # Passes a Dir glob into Dir#[] and returns
    # an array of Dot objects.
    def self.dotfiles(glob)
      Dir[glob].map { |f| Dot.new(f) }
    end

    attr_accessor :dots

    # Pulls an array of Dots from the home
    # directory.
    def initialize(dots_from_filter)
      @dots ||= dots_from_filter
    end

    # Reject any files that are ignored in Dotify's
    # .dotrc file.
    #
    # Destructively alters the array of
    # Dot objects stored in @dots.
    #
    def ignore(ignore)
      ignores = Config.ignore(ignore)
      @dots = reject { |f| ignores.include?(f.filename) }
      self
    end

    # Return the filenames of the given files
    def filenames
      map(&:filename)
    end

    # Defined each method for Enumerable
    def each(&block)
      dots.each(&block)
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
      dots.to_s
    end

    def inspect
      dots.map(&:inspect)
    end

  end
end
