require 'spec_helper'

module Dotify
  describe Path do
    subject { Path }
    it { should respond_to :dotify }
    it { should respond_to :home }
    it { should respond_to :dotify_path }
    it { should respond_to :home_path }

    describe "#home" do
      before { Dir.should_receive(:home) }
      it "Dir.should_receive(:home)" do
        subject.home
      end
    end
    describe "#dotify" do
      its(:dotify) { should == Path.home + ".dotify" }
    end
    describe "#dotify_path" do
      subject { Path.dotify_path("example_path") }
      it { should == Path.home + ".dotify/example_path" }
    end
    describe "#home_path" do
      subject { Path.home_path("example_path") }
      it { should == Path.home + "example_path" }
    end
  end
  describe Path::DOTIFY_DIR do
    subject { Path::DOTIFY_DIR }
    it { should == '.dotify' }
  end
end
