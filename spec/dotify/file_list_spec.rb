require 'spec_helper'

module Dotify
  describe FileList do
    before { described_class.reset! }
    subject { described_class }
    it { should respond_to :pointers }
    it { should respond_to :destinations }
    it { should respond_to :sources }

    describe "#dotfile_pointers" do
      it { should respond_to :dotfile_pointers }
      describe "behavior" do
        before do
          Dir.stub(:[]).with('/tmp/home/.*').and_return(["/tmp/home/.vimrc", "/tmp/home/.zshrc"])
          FileList.dotfile_pointers
        end
        subject { FileList.pointers }
        its(:first) { should be_instance_of Pointer }
        it { should have(2).pointers }
        context "first item" do
          subject { FileList.pointers.first }
          its(:source) { should == "/tmp/home/.dotify/.vimrc" }
          its(:destination) { should == "/tmp/home/.vimrc" }
        end
        context "second item" do
          subject { FileList.pointers.last }
          its(:source) { should == "/tmp/home/.dotify/.zshrc" }
          its(:destination) { should == "/tmp/home/.zshrc" }
        end
      end
    end

    describe "#add" do
      it { should respond_to :add }
      describe "adding sources" do
        let(:pointer) { mock("pointer") }
        before { FileList.add pointer }
        its(:pointers) { should include pointer }
      end
    end

    describe "sources and destinations" do
      let(:pointers) { [Pointer.new(".source1", ".destination1"), Pointer.new(".remote-desination-source", "/Application/distant/source")] }
      before { pointers.each { |p| FileList.add p } }
      describe "#sources" do
        its(:sources) { should include ".source1" }
        its(:sources) { should include ".remote-desination-source" }
      end
      describe "#destinations" do
        its(:destinations) { should include ".destination1" }
        its(:destinations) { should include "/Application/distant/source" }
      end
    end
  end
end