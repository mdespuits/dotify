require 'spec_helper'
require 'dotify/cli/utilities'
require 'rspec/matchers/built_in/yield'
require 'thor/actions'


module Dotify
  module CLI
    class FakeCli
      include CLI::Utilities
      def initialize; end
    end

    describe Utilities do
      let(:test_cli) { FakeCli.new }

      describe Utilities, "#inform" do
        it "should have an inform method" do
          expect(test_cli).to respond_to :inform
        end
        it "should delegate to Thor::Actions say method" do
          test_cli.should_receive(:say).with("some message", :blue)
          test_cli.inform("some message")
        end
      end

      describe Utilities, "#run_if_installed" do
        before do
          test_cli.stub(:inform)
        end
        it "should yield if Dotify is installed" do
          Config.stub(:installed?).and_return true
          expect { |b| test_cli.run_if_installed(&b) }.to yield_control
        end
        it "should not yield if Dotify is not installed" do
          Config.stub(:installed?).and_return false
          expect { |b| test_cli.run_if_installed(&b) }.not_to yield_control
        end
        it "should inform user if Dotiyf is not installed" do
          Config.stub(:installed?).and_return false
          test_cli.should_receive(:inform).once
          test_cli.run_if_installed { }
        end
      end
    end
  end
end
