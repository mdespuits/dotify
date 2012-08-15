require 'spec_helper'
require 'dotify/cli'
require 'thor'

module Dotify
  describe CLI::Base do
    describe "essential tasks existence tests" do
      it { should respond_to :install }
      it { should respond_to :setup } # remove and merge with install?
      it { should respond_to :link }
      it { should respond_to :unlink }
      it { should respond_to :github }
      it { should respond_to :repo }
      it { should respond_to :edit }
      it { should respond_to :version }
    end
  end
end