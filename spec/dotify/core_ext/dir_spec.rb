require 'spec_helper'

describe Dir do
  before do
    Dir.stub(:glob).with("/.*").and_return %w[. .. .bashrc /path/to/another/file]
  end
  describe ".[]" do
    subject { Dir["/.*"] }
    it { should include '.bashrc' }
    it { should include '/path/to/another/file' }
    it { should_not include '.' }
    it { should_not include '..' }
  end
end
