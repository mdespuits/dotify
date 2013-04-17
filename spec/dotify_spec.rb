require 'spec_helper'

describe Dotify do
  subject { described_class }
  let(:instance) { double('instance').as_null_object }

  describe ".load!" do
    after { FileUtils.rm_rf Dotify.dotify_directory }
    it "should create the ~/.dotify directory if it does not exist" do
      Dotify.setup
      expect( Dotify.dotify_directory.exist? ).to be_true
    end
    it "should ensure the ~/.dotify/config.rb is created" do
      FileUtils.rm_rf Dotify.configuration_file
      Dotify.should_receive(:copy_config_template).and_call_original
      Dotify.setup
      expect( Dotify.configuration_file.exist? ).to be_true
    end
    it "should not try to create the config.rb file if it exists" do
      FileUtils.mkdir_p(Dotify.dotify_directory)
      FileUtils.touch(Dotify.configuration_file)
      Dotify.should_not_receive(:copy_config_template)
      Dotify.setup
    end
  end

  describe ".in_instance" do
    it "should temporarily set the instance to the given argument and execute the block" do
      Dotify.in_instance(instance) { 0 }.should == 0
      Dotify.instance_eval { @instance }.should be_nil
    end
  end

end
