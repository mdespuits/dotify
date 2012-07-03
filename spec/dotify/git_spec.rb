require 'spec_helper'
require 'git'
require 'dotify/git'

describe Dotify::Git do
  let(:repo) { Dotify::Git.repo }
  subject { repo }
  it { should be_instance_of Git::Base }
end
