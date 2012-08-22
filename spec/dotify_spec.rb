require 'spec_helper'

describe Dotify do
  subject { described_class }
  describe "#installed?" do
    around do |example|
      Dir.chdir(@__HOME) { example.run }
    end
    describe "when .dotify directory exists" do
      around { |example|
        FileUtils.mkdir_p(Dotify::Path.dotify)
        example.run
        FileUtils.rm_rf(Dotify::Path.dotify)
      }
      its(:installed?) { should be_true }
    end
    describe "when .dotify directory does not exist" do
      its(:installed?) { should be_false }
    end
  end

  its(:version) { should == Dotify::Version.new.level }
end
