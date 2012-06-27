require 'spec_helper'
require 'dotify'
require 'dotify/checker'
require 'json'
require 'net/http'

describe Dotify::Checker do
  it Dotify::Checker, "#run_check!" do
    VCR.use_cassette "version_check" do
      Dotify::Checker.run_check!
      Dotify::Checker.version.should == '0.2.0'
    end
  end
  describe Dotify::Checker, "#out_of_date?" do
    it "should be false if version is current" do
      VCR.use_cassette "version_check" do
        Dotify::Checker.stub(:version).and_return('0.1.9')
        Dotify::Checker.out_of_date?.should == true
      end
    end
    it "should be true if version is not current" do
      VCR.use_cassette "version_check" do
        Dotify::Checker.stub(:version).and_return('0.2.0')
        Dotify::Checker.out_of_date?.should == false
      end
    end
  end
  describe Dotify::Checker, "#current?" do
    it "should be false if version is not current" do
      VCR.use_cassette "version_check" do
        Dotify::Checker.stub(:version).and_return('0.1.9')
        Dotify::Checker.current?.should == false
      end
    end
    it "should be true if version is current" do
      VCR.use_cassette "version_check" do
        Dotify::Checker.stub(:version).and_return('0.2.0')
        Dotify::Checker.current?.should == true
      end
    end
  end
end
