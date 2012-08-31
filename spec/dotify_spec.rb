require 'spec_helper'

describe Dotify do
  subject { described_class }
  describe ".installed?" do
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

  describe ".in_instance" do
    let(:inst) { mock('instance') }
    it "should temporarily set the instance to the given argument and execute the block" do
      Dotify.in_instance(inst) { 0 }.should == 0
      Dotify.instance_eval { @instance }.should be_nil
    end
  end

  describe ".setup" do
    it 'should run in the context of the Maid::Maid instance' do
      instance = mock('instance')
      instance.should_receive(:foo)
      Dotify.in_instance(instance) do
        Dotify.setup { foo }
      end
    end
  end

  its(:version) { should == Dotify::Version.new.level }
end
