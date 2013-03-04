require 'spec_helper'

module Dotify
  describe Pointer do
    subject { pointer }
    describe "default behavior" do
      let(:source) { "#{$HOME}/.dotify/.file" }
      let(:destination) { "#{$HOME}}/.file" }
      let(:pointer) { Pointer.new(source, destination) }
      its(:source) { should == source }
      its(:destination) { should == destination }
    end

    describe "#eql?" do
      subject(:pointer) { Pointer.new("example", "destination") }
      context "when they are equal" do
        let(:other) { Pointer.new("example", "destination") }
        it { pointer.eql?(other).should be_true }
      end
      context "when they have same source but different destination" do
        let(:other) { Pointer.new("example", "other-destination")}
        it { pointer.eql?(other).should be_true }
      end
      context "when they are not equal" do
        let(:other) { Pointer.new("examples", "destination") }
        it { pointer.eql?(other).should be_false }
      end
    end
  end
end
