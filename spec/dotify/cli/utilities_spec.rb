require 'spec_helper'
require 'dotify/cli/utilities'
require 'thor/actions'


module Dotify
  module CLI
    class FakeCli
      include CLI::Utilities
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
    end
  end
end
