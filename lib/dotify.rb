require 'fileutils'

require 'dotify/null_object'

# Everything else
require 'dotify/operating_system'
require 'dotify/pointer'
require 'dotify/path'
require 'dotify/configure'
require 'dotify/link_builder'
require 'dotify/file_list'
require 'dotify/version'
require 'dotify/app'

module Dotify

  class << self
    def in_instance(instance)
      @instance = instance
      result = yield
      @instance = nil
      result
    end

    def setup(&blk)
      @instance.instance_eval &blk
    end

    def config
      @config ||= Configure.new
    end

    def collection
      @collection ||= Collection.home
    end
  end

end
