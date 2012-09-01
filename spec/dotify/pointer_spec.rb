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
  end
end
