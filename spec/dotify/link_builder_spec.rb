require 'spec_helper'

module Dotify
  describe LinkBuilder do
    let(:pointer) { Pointer.new("#{@__HOME}/.dotify/.source", "#{@__HOME}/.destination") }
    let(:builder) { LinkBuilder.new(pointer) }
    subject { builder }
    before(:all) do
      FileUtils.mkdir_p "~/.dotify"
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
        subject.should_receive(:touch).with(subject.source).once
        subject.should_receive(:rm_rf).with(subject.source).once
      end
      it { subject.remove_source }
    end

    describe "#remove_destination" do
      before do
        subject.should_receive(:touch).with(subject.destination).once
        subject.should_receive(:rm_rf).with(subject.destination).once
      end
      it { subject.remove_destination }
    end

    describe "#link_from_source" do
      before do
        subject.should_receive(:remove_destination).once
        subject.should_receive(:link!).once
      end
      it { subject.link_from_source }
    end

    describe "#link_to_source" do
      before do
        subject.should_receive(:remove_source).once
        subject.should_receive(:move_to_source)
        subject.should_receive(:link!).once
      end
      it { subject.link_to_source }
    end

    describe "#move_to_source" do
      before do
        FileUtils.touch subject.source, subject.destination
        subject.should_receive(:touch).with(subject.destination).once
        subject.should_receive(:move).with(subject.destination, subject.source)
      end
      it { subject.move_to_source }
    end

    describe "#move_to_destination" do
      before do
        subject.should_receive(:touch).with(subject.source).once
        subject.should_receive(:move).with(subject.source, subject.destination)
      end
      it { subject.move_to_destination }
    end

    describe "#link!" do
      before do
        subject.should_receive(:touch).with(subject.source, subject.destination)
        subject.should_receive(:ln_sf).with(subject.source, subject.destination)
      end
      it { subject.link! }
    end
  end
end
