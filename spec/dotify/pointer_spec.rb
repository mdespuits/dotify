require 'spec_helper'

module Dotify
  describe Pointer do
    subject { pointer }
    describe "default behavior" do
      let(:source) { "/tmp/home/.dotify/.file" }
      let(:destination) { "/tmp/home/.file" }
      let(:pointer) { Pointer.new(source, destination) }
      its(:source) { should == source }
      its(:destination) { should == destination }
    end
  end
end