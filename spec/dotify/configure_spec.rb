require 'spec_helper'

module Dotify

  class Configure
    class << self
      public :guess_host_os
    end
    def self.reset!
      @options = {}
      @host = nil
    end
  end

  describe Configure do
    let(:klass) { Configure.new }
    subject { klass }
    before { Configure.reset! }

    describe "class methods" do
      subject { described_class }
      its(:dir) { should == "/tmp/home/.dotify" }
      its(:file) { should == "/tmp/home/.dotify/.dotrc" }
      its(:root) { should == '/tmp/home' }
      it "should build the right path" do
        expect(subject.path(".example-file")).to eql '/tmp/home/.dotify/.example-file'
        expect(subject.path("some/nested/.example-file")).to eql '/tmp/home/.dotify/some/nested/.example-file'
      end
    end

    describe "defined options" do
      describe "getting defined editor" do
        before { subject.options = { :editor => 'vi' } }
        its(:editor) { should == 'vi'}
      end
      describe "getting undefined editor" do
        its(:editor) { should be_instance_of NullObject }
      end
    end

    describe "#guess_host_os" do
      subject { conf.guess_host_os }
      let(:conf) { described_class }
      context "darwin" do
        before { conf.stub(:host_os).and_return("darwin") }
        it { should == :mac }
      end
      context "mswin" do
        before { conf.stub(:host_os).and_return("mswin") }
        it { should == :windows }
      end
      context "windows" do
        before { conf.stub(:host_os).and_return("windows") }
        it { should == :windows }
      end
      context "linux" do
        before { conf.stub(:host_os).and_return("linux") }
        it { should == :linux }
      end
      context "solaris" do
        before { conf.stub(:host_os).and_return("sunos") }
        it { should == :solaris }
      end
      context "solaris" do
        before { conf.stub(:host_os).and_return("solaris") }
        it { should == :solaris }
      end
      context "other" do
        before { conf.stub(:host_os).and_return("other") }
        it { should == :unknown }
      end
    end

  end
end