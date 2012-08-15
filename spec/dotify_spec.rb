require 'spec_helper'

describe Dotify do
  subject { described_class }
  describe "#installed?" do
    around do |example|
      Dir.chdir(Thor::Util.user_home) { example.run }
    end
    describe "when .dotify directory exists" do
      before(:each) { %x{mkdir -p #{File.expand_path('.dotify')}} }
      after(:each) { %x{rm -rf #{File.expand_path(".dotify")}} }
      its(:installed?) { should be_true }
    end
    describe "when .dotify directory does not exist" do
      its(:installed?) { should be_false }
    end
  end

  describe "#version" do
    its(:version) { should == Dotify::Version.new.level }
  end
end
