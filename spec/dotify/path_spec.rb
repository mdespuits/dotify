require 'spec_helper'

module Dotify
  describe Path do
    subject { Path }
    it { should respond_to :dotify_path }
    it { should respond_to :home_path }

    describe "#home" do
      before { Path.should_receive(:user_home) }
      it "should call #user_home" do
        subject.home
      end
    end
    describe "#dotify" do
      its(:dotify) { should == '/tmp/home/.dotify' }
    end
    describe "#dotify_path" do
      subject { Path.dotify_path("example_path") }
      it { should == "/tmp/home/.dotify/example_path" }
    end
    describe "#dotify_path" do
      subject { Path.home_path("example_path") }
      it { should == "/tmp/home/example_path" }
    end
  end
  describe Path::Dir do
    subject { Path::Dir }
    it { should == '.dotify' }
  end
end
