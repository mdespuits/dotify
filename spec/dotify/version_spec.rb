require 'spec_helper'
require 'dotify/version'

module Dotify
  describe Version do
    describe Version, "#to_s" do
      it "should equal the right number" do
        expect(Version.to_s).to eq(Dotify::VERSION)
      end
    end
    it "#run_check! should return the right version number" do
      VCR.use_cassette "version_check" do
        Version.version.should == '0.2.0'
      end
    end
    describe Version, "#out_of_date?" do
      it "should be return the correct value if version is not current" do
        Version.stub(:current?).and_return(false)
        Version.out_of_date?.should == true
        Version.stub(:current?).and_return(true)
        Version.out_of_date?.should == false
      end
    end
    describe Version, "#current?" do
      it "should be false if version is not current" do
        stub_const "Dotify::VERSION", '0.2.0'
          Version.stub(:version).and_return('0.1.9')
        Version.current?.should == false
    end
      it "should be true if version is current" do
        stub_const "Dotify::VERSION", '0.2.0'
        Version.stub(:version).and_return('0.2.0')
        Version.current?.should == true
      end
    end
  end
end
