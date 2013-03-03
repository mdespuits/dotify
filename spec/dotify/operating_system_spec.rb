require 'spec_helper'

include Dotify

describe OperatingSystem do

  subject { described_class }

  describe "#guess" do

    before { OperatingSystem.stub(:host_os) { os_name } }

    context "darwin" do
      let(:os_name) { "darwin" }
      its(:guess) { should == :mac }
    end

    context "mswin" do
      let(:os_name) { "mswin" }
      its(:guess) { should == :windows }
    end

    context "windows" do
      let(:os_name) { "windows" }
      its(:guess) { should == :windows }
    end

    context "linux" do
      let(:os_name) { "linux" }
      its(:guess) { should == :linux }
    end

    context "solaris" do
      let(:os_name) { "sunos" }
      its(:guess) { should == :solaris }
    end

    context "solaris" do
      let(:os_name) { "solaris" }
      its(:guess) { should == :solaris }
    end

    context "other" do
      let(:os_name) { "other" }
      its(:guess) { should == :unknown }
    end

  end
end
