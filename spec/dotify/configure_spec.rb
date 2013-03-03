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
      subject { Configure.guess_host_os }
      before { Configure.stub(:host_os) { os_name } }
      context "darwin" do
        let(:os_name) { "darwin" }
        it { should == :mac }
      end
      context "mswin" do
        let(:os_name) { "mswin" }
        it { should == :windows }
      end
      context "windows" do
        let(:os_name) { "windows" }
        it { should == :windows }
      end
      context "linux" do
        let(:os_name) { "linux" }
        it { should == :linux }
      end
      context "solaris" do
        let(:os_name) { "sunos" }
        it { should == :solaris }
      end
      context "solaris" do
        let(:os_name) { "solaris" }
        it { should == :solaris }
      end
      context "other" do
        let(:os_name) { "other" }
        it { should == :unknown }
      end
    end

  end
end
