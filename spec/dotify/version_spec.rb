require 'spec_helper'
require 'dotify/version'

module Dotify
  describe Version do
    it { should respond_to :out_of_date? }
    it { should respond_to :current? }
    it { should respond_to :level }
    it { should respond_to :latest }

    describe "#level" do
      its(:level) { should be_instance_of String }
      its(:level) { should =~ /#{MAJOR}\./ }
      its(:level) { should =~ /\.#{MINOR}/ }
      its(:level) { should =~ /\.#{PATCH}/ }
    end

    describe "#build" do
      subject { Version }
      its(:build) { should be_instance_of described_class }
    end

    describe "Checker delegation" do
      it "should delegate to Checker#check_latest_release!" do
        Version::Checker.should_receive(:check_latest_release!).once
        Version.build.current?
      end
      it "should delegate to Checker#check_latest_release!" do
        Version::Checker.should_receive(:latest).once
        Version.build.latest
      end
    end

    describe "retrieving the version" do
      subject { Version.build }
      context "when out of date" do
        before { Version::Checker.stub(:check_latest_release!).and_return(true) }
        its(:current?) { should == true }
        its(:out_of_date?) { should == false }
      end
      context "when up to date" do
        before { Version::Checker.stub(:check_latest_release!).and_return(false) }
        its(:out_of_date?) { should == true }
        its(:current?) { should == false }
      end
    end
  end

  class Version
    describe Checker do
      subject { Checker }
      it { should respond_to :check_latest_release! }
      it { should respond_to :latest }

      describe "#latest" do
        subject { Checker }
        use_vcr_cassette "check latest version"
        its(:latest) { should == '0.6.6' }
      end

      describe "#check_latest_release" do
        use_vcr_cassette "check latest version"
        subject { Checker }
        context "out of date" do
          before {
            Version.build.stub(:level).and_return '1.0.0'
            Checker.check_latest_release!
          }
          it "should prove that the latest version is newer than the current one" do
            Checker.result.should == false
          end
        end
        context "out of date" do
          before {
            Version.build.stub(:level).and_return '0.6.6'
            Checker.check_latest_release!
          }
          its(:result) { should == true }
        end
      end
    end
  end
end
