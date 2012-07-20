require 'spec_helper'
require 'dotify/cli/github'

module Dotify
  module CLI
    describe Github do

      describe Github, "#run_if_git_repo" do
        before { Github.stub(:inform) }
        it "should yield the block if a .git directory exists in Dotify" do
          File.stub(:exists?).with(Config.path('.git')).and_return true
          expect { |b| Github.run_if_git_repo(&b) }.to yield_control
        end
        it "should yield the block if a .git directory exists in Dotify" do
          File.stub(:exists?).with(Config.path('.git')).and_return false
          expect { |b| Github.run_if_git_repo(&b) }.not_to yield_control
        end
        it "should call inform if a .git directory is missing" do
          Github.should_receive(:inform).once
          Github.run_if_git_repo { }
        end
      end
    end
  end
end
