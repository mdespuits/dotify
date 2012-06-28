require 'spec_helper'
require 'dotify'
require 'dotify/version_checker'

describe Dotify::VersionChecker do
  it Dotify::VersionChecker, "#run_check!" do
    VCR.use_cassette "version_check" do
      Dotify::VersionChecker.run_check!
      Dotify::VersionChecker.version.should == '0.2.0'
    end
  end
  describe Dotify::VersionChecker, "#out_of_date?" do
    it "should be false if version is current" do
      VCR.use_cassette "version_check" do
        Dotify::VersionChecker.stub(:version).and_return('0.1.9')
        Dotify::VersionChecker.out_of_date?.should == true
      end
    end
    it "should be true if version is not current" do
      VCR.use_cassette "version_check" do
        Dotify::VersionChecker.stub(:version).and_return('0.2.0')
        Dotify::VersionChecker.out_of_date?.should == false
      end
    end
  end
  describe Dotify::VersionChecker, "#current?" do
    it "should be false if version is not current" do
      VCR.use_cassette "version_check" do
        Dotify::VersionChecker.stub(:version).and_return('0.1.9')
        Dotify::VersionChecker.current?.should == false
      end
    end
    it "should be true if version is current" do
      VCR.use_cassette "version_check" do
        Dotify::VersionChecker.stub(:version).and_return('0.2.0')
        Dotify::VersionChecker.current?.should == true
      end
    end
  end
end
