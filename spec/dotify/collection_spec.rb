require 'spec_helper'

module Dotify
  class LinkedDot < Dot
    def in_home_dir?; true; end
    def in_dotify?; true; end
    def linked_to_dotify?; true; end
  end

  class UnlinkedDot < Dot
    def in_home_dir?; true; end
    def in_dotify?; false; end
    def linked_to_dotify?; false; end
  end

  describe Collection do

    let(:collection) { Collection.new }
    let(:home_files) {
      [
        @bashrc = UnlinkedDot.new(".bashrc"),
        @gitconfig = UnlinkedDot.new(".gitconfig"),
        @vimrc = LinkedDot.new(".vimrc")
      ]
    }
    describe "methods" do
      %w[each linked unlinked].each do |name|
        it "should respond to #{name}" do
          collection.should respond_to name
        end
      end
    end

    describe "pulling Filter#home or Filter#dotify files" do
      it "should raise an error when not specifying :dotfiles or :dotify" do
        expect { Collection.new(:fake) }.to raise_error ArgumentError
      end
      it "should pull from Filter#home when default or dotfiles" do
        Filter.should_receive(:home).twice
        Collection.new(:dotfiles)
        Collection.new
      end
      it "should pull from Filter#dotify when default or dotfiles" do
        Filter.should_receive(:dotify).once
        Collection.new(:dotify)
      end
    end
    it "should pull the right files from Filter.home" do
      files = [stub, stub, stub]
      Filter.stub(:home).and_return files
      collection.dots.should == files
    end

    describe Collection, "#linked" do
      before do
        collection.stub(:dots).and_return home_files
      end
      let(:linked) { collection.linked }
      it "should return the right Dots" do
        linked.should include @vimrc
        linked.should_not include @gitconfig
        linked.should_not include @bashrc
      end
      it "should yield the correct Dots" do
        expect { |b| collection.linked.each(&b) }.to yield_successive_args(*linked)
      end
    end

    describe Collection, "#unlinked" do
      before do
        collection.stub(:dots).and_return home_files
      end
      let(:unlinked) { collection.unlinked }
      it "should return the right Dots" do
        unlinked.should include @gitconfig
        unlinked.should include @bashrc
        unlinked.should_not include @vimrc
      end
      it "should yield the correct Dots" do
        expect { |b| collection.unlinked.each(&b) }.to yield_successive_args(*unlinked)
      end
    end

    it "should call #to_s on the dots" do
      collection.dots.should_receive(:to_s)
      collection.to_s
    end

    it "should call #inspect on the dots" do
      collection.dots.each { |u| u.should_receive(:inspect) }
      collection.inspect
    end

  end
end
