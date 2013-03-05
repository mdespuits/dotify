require 'spec_helper'

describe Dotify do
  subject { described_class }

  describe ".in_instance" do
    let(:inst) { double('instance') }
    it "should temporarily set the instance to the given argument and execute the block" do
      Dotify.in_instance(inst) { 0 }.should == 0
      Dotify.instance_eval { @instance }.should be_nil
    end
  end

  describe ".setup" do
    it 'should run in the context of the Maid::Maid instance' do
      instance = double('instance')
      instance.should_receive(:foo)
      Dotify.in_instance(instance) do
        Dotify.setup { foo }
      end
    end
  end
end
