require 'spec_helper'
require 'git'
require 'dotify/git'

describe Dotify::Git do
  it "should try to open the git repo" do
    Git.stub(:open).with(Dotify::Config.path)
    Dotify::Git.repo
  end
end
