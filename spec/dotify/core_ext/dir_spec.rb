require 'spec_helper'

describe Dir do
  before do
    Dir.should_receive(:glob).with("some-path").and_return %w[. .. .bashrc /path/to/another/file]
  end
  describe "#[]" do
    subject { Dir["some-path"] }
    it { should include '.bashrc' }
    it { should include '/path/to/another/file' }
    it { should_not include '.' }
    it { should_not include '..' }
  end
end