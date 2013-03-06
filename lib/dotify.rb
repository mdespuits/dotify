require 'fileutils'
require 'pathname'

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

    def load!
      setup_directory_and_config
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

    def setup_directory_and_config
      FileUtils.mkdir_p(dotify_directory)
      copy_config_template unless configuration_file.exist?
    end

    def dotify_directory
      @__dir ||= Pathname.new(File.expand_path("~/.dotify"))
    end

    def configuration_file
      @__configuration ||= dotify_directory + "config.rb"
    end

    def copy_config_template
      FileUtils.cp config_template, configuration_file
    end

    def config_template
      File.expand_path("../../templates/config.rb", __FILE__)
    end

  end
end
