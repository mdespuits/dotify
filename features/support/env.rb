require 'rubygems'
require 'thor/util'
require 'fileutils'

$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'cucumber/rspec/doubles'
require 'aruba/cucumber'

unless ENV["CI"]
  require 'simplecov'
  SimpleCov.start do
    coverage_dir 'coverage/cuke'
    load_adapter 'test_frameworks'
  end
end

module Dotify
  class Configure
    def reset!
      @options = {}
      @host = nil
    end
  end
end

require 'dotify'
