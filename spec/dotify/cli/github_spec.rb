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

      describe Github::Puller do
        before { Github::Puller.any_instance.stub(:inform) }
        let(:puller) { Github::Puller.new(double, double, {}) }

        describe Github::Puller, "#github_repo_url" do
          it "should return a public repo url when env is public" do
            puller.stub(:use_ssh_repo?).and_return(false)
            puller.url("mattdbridges/dots").should == "git://github.com/mattdbridges/dots.git"
          end
          it "should return a SSH repo url when env is not public" do
            puller.stub(:use_ssh_repo?).and_return(true)
            puller.url("mattdbridges/dots").should == "git@github.com:mattdbridges/dots.git"
          end
        end

        describe Github::Puller, "#clone" do
          it "should delegate to Git clone and clone to the right place" do
            puller.stub(:path).and_return("/tmp/home/.dotify")
            puller.stub(:url).and_return("something")
            Git.should_receive(:clone).with("something", "/tmp/home/.dotify")
            puller.clone
          end
        end
      end

    end
  end
end
