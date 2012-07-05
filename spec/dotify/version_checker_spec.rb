require 'spec_helper'
require 'dotify/version_checker'

module Dotify
  describe VersionChecker do
    it "#run_check! should return the right version number" do
      VCR.use_cassette "version_check" do
        VersionChecker.version.should == '0.2.0'
      end
    end
    describe VersionChecker, "#out_of_date?" do
      it "should be return the correct value if version is not current" do
        VersionChecker.stub(:current?).and_return(false)
        VersionChecker.out_of_date?.should == true
        VersionChecker.stub(:current?).and_return(true)
        VersionChecker.out_of_date?.should == false
      end
    end
    describe VersionChecker, "#current?" do
      it "should be false if version is not current" do
        with_constants "Dotify::VERSION" => '0.2.0' do
          VersionChecker.stub(:version).and_return('0.1.9')
          VersionChecker.current?.should == false
        end
      end
      it "should be true if version is current" do
        with_constants "Dotify::VERSION" => '0.2.0' do
          VersionChecker.stub(:version).and_return('0.2.0')
          VersionChecker.current?.should == true
        end
      end
    end
  end
end
