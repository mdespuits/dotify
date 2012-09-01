require 'spec_helper'

module Dotify
  describe FileList do
    before { described_class.reset! }
    subject { described_class }
    it { should respond_to :pointers }
    it { should respond_to :destinations }
    it { should respond_to :sources }

    describe ".dotfile_pointers" do
      it { should respond_to :dotfile_pointers }
      describe "behavior" do
        before do
          Dir.stub(:[]).with("#{$HOME}/.*").and_return(["#{$HOME}/.vimrc", "#{$HOME}/.zshrc"])
          FileList.dotfile_pointers
        end
        subject { FileList.pointers }
        its(:first) { should be_instance_of Pointer }
        it { should have(2).pointers }
        context "first item" do
          subject { FileList.pointers.first }
          its(:source) { should == "#{$HOME}/.dotify/.vimrc" }
          its(:destination) { should == "#{$HOME}/.vimrc" }
        end
        context "second item" do
          subject { FileList.pointers.last }
          its(:source) { should == "#{$HOME}/.dotify/.zshrc" }
          its(:destination) { should == "#{$HOME}/.zshrc" }
        end
      end
    end

    describe ".add" do
      it { should respond_to :add }
      describe "adding single Pointer" do
        let(:pointer) { Pointer.new("sourse", "destination") }
        before { FileList.add pointer }
        it { should have(1).pointers }
        its(:pointers) { should include pointer }
      end
      describe "adding multiple Pointers" do
        let(:pointer1) { Pointer.new("source", "destination") }
        let(:pointer2) { Pointer.new("source2", "destination2") }
        before { FileList.add pointer1, pointer2 }
        it { should have(2).pointers }
        its(:pointers) { should include pointer1 }
        its(:pointers) { should include pointer2 }
      end
      describe "adding identical Pointers with different destinations" do
        let(:source1) { Pointer.new("source", "destination") }
        let(:source2) { Pointer.new("source", "destination2") }
        before { FileList.add source1, source2 }
        it { should have(1).pointers }
        its(:pointers) { should include source1 }
        its(:pointers) { should_not include source2 }
      end
    end

    describe "sources and destinations" do
      let(:pointers) { [Pointer.new(".source1", ".destination1"), Pointer.new(".remote-desination-source", "/Application/distant/source")] }
      before { FileList.add *pointers }
      describe "#sources" do
        it { should have(2).sources }
        its(:sources) { should include ".source1" }
        its(:sources) { should include ".remote-desination-source" }
      end
      describe "#destinations" do
        it { should have(2).destinations }
        its(:destinations) { should include ".destination1" }
        its(:destinations) { should include "/Application/distant/source" }
      end
    end
  end
end
