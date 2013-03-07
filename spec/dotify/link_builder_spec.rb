require 'spec_helper'

module Dotify
  describe LinkBuilder do
    let(:source) { Pathname.new("#{Dir.home}/.dotify/.source") }
    let(:destination) { Pathname.new("#{Dir.home}/.dotify/.destination") }
    let(:pointer) { Pointer.new(source, destination) }
    subject(:builder) { LinkBuilder.new(pointer) }

    before(:each) do
      FileUtils.mkdir_p File.expand_path("~/.dotify")
    end

    after(:each) do
      FileUtils.rm_rf File.expand_path("~/.dotify")
    end

    describe "receives the Pointer's attributes" do
      it { should respond_to :pointer }
      it { should respond_to :source }
      it { should respond_to :destination }
      its(:source) { should == pointer.source }
      its(:destination) { should == pointer.destination }
    end
    describe "methods enforced" do
      it { should respond_to :link_from_source }
      it { should respond_to :link_to_source }
      it { should respond_to :move_to_source }
      it { should respond_to :move_to_destination }
      it { should respond_to :remove_source }
      it { should respond_to :remove_destination }
    end

    describe "#remove_source" do
      before do
        FileUtils.touch(source)
        subject.remove_source
      end
      it { source.should_not exist }
    end

    describe "#remove_destination" do
      before do
        FileUtils.touch(destination)
        subject.remove_destination
      end
      it { destination.should_not exist }
    end

    describe "#link_from_source" do
      before do
        subject.link_from_source
      end
      it { source.should exist }
      it { destination.should exist }
      it { destination.should be_symlink }
    end

    describe "#link_to_source" do
      before do
        subject.link_to_source
      end
      it { source.should exist }
      it { destination.should exist }
      it { destination.should be_symlink }
    end

    describe "#move_to_source" do
      before do
        subject.move_to_source
      end
      it { source.should exist }
      it { destination.should_not exist }
    end

    describe "#move_to_destination" do
      before do
        subject.move_to_destination
      end
      it { destination.should exist }
      it { source.should_not exist }
    end

    describe "#link!" do
      before do
        subject.link!
      end
      it { source.should exist }
      it { destination.should exist }
      it { destination.should be_symlink }
    end
  end
end
