require 'fileutils'
require 'pathname'

require 'dotify/operating_system'
require 'dotify/symlink'
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

    def setup
      dotify_directory.mkpath
      copy_config_template unless config_file.exist?
      FileUtils.touch(config_file)
    end

    def dotify_directory
      home + ".dotify"
    end

    def config_file
      dotify_directory + "config.rb"
    end

    def copy_config_template
      FileUtils.cp config_template, config_file
    end

    def config_template
      Pathname.new("../templates/config.rb").expand_path(File.basename(__FILE__))
    end

    def home
      Pathname.new(Dir.home)
    end

  end
end
