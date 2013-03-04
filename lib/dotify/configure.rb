require 'thor/util'

module Dotify
  class Configure < Object

    CONFIG_FILE = "config.rb"

    def editor(&blk)
      @editor ||= 'vim'
      @editor = blk.call.to_s if block_given?
      @editor
    end

    def ignore(&blk)
      @ignore ||= ['.DS_Store', '.git']
      @ignore += Array(blk.call) if block_given?
      @ignore.uniq
    end

    def self.start
      @instance = new
      yield @instance
      @instance
    end

  end
end
