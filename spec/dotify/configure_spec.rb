require 'spec_helper'

module Dotify

  class Configure
    def self.reset!
      @links = []
    end
  end

  describe Configure do
    describe "#start" do

      before { Configure.reset! }

      context "without any settings" do
        subject do
          Configure.start { |d| }
        end
        its(:ignore) { should be_empty }
      end

      context "should allow an array of ignores in a single definition" do
        subject do 
          Configure.start do |d|
            d.ignore { %w[another set of .things] }
          end
        end
        its(:ignore) { should have(4).items }
        its(:ignore) { should include 'another' }
        its(:ignore) { should include '.things' }
      end

      context "with a particular platform set" do
        subject do
          Configure.start do |d|
            d.platform :osx do |d|
              d.ignore { "another-thing" }
            end
          end
        end
        context "when on OSX" do
          before { OperatingSystem.stub(:guess) { 'osx' }}
          its(:ignore) { should include "another-thing" }
        end
        context "when on OSX" do
          before { OperatingSystem.stub(:guess) { 'linux' }}
          its(:ignore) { should_not include "another-thing" }
        end
        context "when no platform is defined by accident" do
          let(:config) do
            Configure.start do |d|
              d.platform do |d|
                d.ignore { "emacs" }
              end
            end
          end
          it { expect { config }.to raise_error(ArgumentError) }
        end
      end

      context "calling ignore multiple times with same value" do
        subject do
          Configure.start do |d|
            d.ignore { '.example' }
            d.ignore { '.example' }
            d.ignore { '.example' }
          end
        end
        its(:ignore) { should have(1).items }
        its(:ignore) { should include '.example' }
      end

      context "with link should create a pointer" do
        let(:config) do
          Configure.start do |d|
            d.symlink("source", "destination")
            d.symlink("another-source", "another-destination")
          end
        end
        subject { config.symlinks }
        it { should have(2).items }
        it { subject.first.source.should =~ /source\z/i }
        it { subject.first.destination.should =~ /destination\z/i }
      end

      context "with ignore settings with defaults" do
        subject do
          Configure.start do |d|
            d.ignore { '.sublime' }
          end
        end
        its(:ignore) { should have(1).items }
        its(:ignore) { should include '.sublime' }
      end

    end
  end
end
