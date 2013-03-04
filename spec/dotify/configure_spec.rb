require 'spec_helper'

include Dotify

describe Configure do
  describe "#start" do

    context "without any settings" do
      subject do
        Configure.start { |d| }
      end
      its(:editor) { should == 'vim' }
    end

    context "with and editor set" do
      subject do
        Configure.start do |d|
          d.editor { "emacs" }
        end
      end
      its(:editor) { should == 'emacs' }
    end

    context "with a particular platform set" do
      subject do
        Configure.start do |d|
          d.platform :osx do |d|
            d.editor { "emacs" }
          end
        end
      end
      context "when on OSX" do
        before { OperatingSystem.stub(:guess) { 'osx' }}
        its(:editor) { should == 'emacs' }
      end
      context "when on OSX" do
        before { OperatingSystem.stub(:guess) { 'linux' }}
        its(:editor) { should == 'vim' }
      end
      context "when no platform is defined by accident" do
        let(:config) do
          Configure.start do |d|
            d.platform do |d|
              d.editor { "emacs" }
            end
          end
        end
        it { expect { config }.to raise_error(ArgumentError) }
      end
    end

    context "with an editor name set as a symbol" do
      subject do
        Configure.start do |d|
          d.editor { :emacs }
        end
      end
      its(:editor) { should == 'emacs' }
    end

    context "calling ignore multiple times with same value" do
      subject do
        Configure.start do |d|
          d.ignore { '.example' }
          d.ignore { '.example' }
          d.ignore { '.example' }
        end
      end
      its(:ignore) { should have(3).items }
      its(:ignore) { should include '.example' }
    end

    context "with ignore settings with defaults" do
      subject do
        Configure.start do |d|
          d.ignore { '.sublime' }
        end
      end
      its(:editor) { should == 'vim' }
      its(:ignore) { should have(3).items }
      its(:ignore) { should include '.DS_Store' }
      its(:ignore) { should include '.git' }
      its(:ignore) { should include '.sublime' }
    end

  end
end
