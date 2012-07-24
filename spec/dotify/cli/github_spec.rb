require 'spec_helper'
require 'dotify/cli/github'

module Dotify
  module CLI
    describe Github do

      it { should respond_to :save }
      it { should respond_to :pull }

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

      describe Github, "#github_repo_url" do
        after { ENV["PUBLIC_GITHUB_REPOS"] = 'false' }
        it "should return a public repo url when env is public" do
          ENV["PUBLIC_GITHUB_REPOS"] = 'true'
          Github.new.github_repo_url("mattdbridges/dots").should == "git://github.com/mattdbridges/dots.git"
        end
        it "should return a SSH repo url when env is not public" do
          ENV["PUBLIC_GITHUB_REPOS"] = 'false'
          Github.new.github_repo_url("mattdbridges/dots").should == "git@github.com:mattdbridges/dots.git"
        end
      end
    end
  end
end
