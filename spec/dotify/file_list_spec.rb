require 'spec_helper'

module Dotify
  class FileList
    def self.reset!
      @pointers = []
    end
  end
end

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
          Dir.stub(:[]).with("#{Dir.home}/.*").and_return(["#{Dir.home}/.vimrc", "#{Dir.home}/.zshrc"])
          FileList.dotfile_pointers
        end
        subject { FileList.pointers }
        its(:first) { should be_instance_of Symlink }
        it { should have(2).pointers }
        context "first item" do
          subject { FileList.pointers.first }
          its(:source) { should == Path.home + ".dotify/.vimrc" }
          its(:destination) { should == Path.home + ".vimrc" }
        end
        context "second item" do
          subject { FileList.pointers.last }
          its(:source) { should == Path.home + ".dotify/.zshrc" }
          its(:destination) { should == Path.home + ".zshrc" }
        end
      end
    end

    describe ".add" do
      it { should respond_to :add }
      describe "adding single Symlink" do
        let(:pointer) { Symlink.new("sourse", "destination") }
        before { FileList.add pointer }
        it { should have(1).pointers }
        its(:pointers) { should include pointer }
      end
      describe "adding multiple Symlinks" do
        let(:pointer1) { Symlink.new("source", "destination") }
        let(:pointer2) { Symlink.new("source2", "destination2") }
        before { FileList.add pointer1, pointer2 }
        it { should have(2).pointers }
        its(:pointers) { should include pointer1 }
        its(:pointers) { should include pointer2 }
      end
      describe "adding identical Symlinks with different destinations" do
        let(:source1) { Symlink.new("source", "destination") }
        let(:source2) { Symlink.new("source", "destination2") }
        before { FileList.add source1, source2 }
        it { should have(1).pointers }
        its(:pointers) { should include source1 }
        its(:pointers) { should_not include source2 }
      end
    end

    describe "sources and destinations" do
      let(:pointers) { [Symlink.new(".source1", ".destination1"), Symlink.new(".remote-desination-source", "/Application/distant/source")] }
      before { FileList.add *pointers }
      describe "#sources" do
        it { should have(2).sources }
        its(:sources) { should include Pathname.new(".source1") }
        its(:sources) { should include Pathname.new(".remote-desination-source") }
      end
      describe "#destinations" do
        it { should have(2).destinations }
        its(:destinations) { should include Pathname.new(".destination1") }
        its(:destinations) { should include Pathname.new("/Application/distant/source") }
      end
    end
  end
end
