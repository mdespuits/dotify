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

    describe "#setup_default_configuration" do
      before { klass.setup_default_configuration }
      its(:editor) { should == 'vim' }
      its(:shared_ignore) { should include '.DS_Store' }
      its(:shared_ignore) { should include '.Trash' }
      its(:shared_ignore) { should include '.git' }
      its(:shared_ignore) { should include '.svn' }
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