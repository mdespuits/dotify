require 'spec_helper'

module Dotify
  describe Collection do

    let(:home_files) {
      [
        @bashrc = double('unit1', :filename => '.bashrc', :linked? => false),
        @gitconfig = double('unit2', :filename => '.gitconfig', :linked? => false),
        @vimrc = double('unit3', :filename => '.vimrc', :linked? => true),
      ]
    }
    describe "methods" do
      %w[all linked unlinked].each do |name|
        it "should respond to #{name}" do
          Collection.should respond_to name
        end
      end
    end

    describe Collection, "#all" do
      it "should pull the right files from List.home" do
        files = [stub, stub, stub]
        List.stub(:home).and_return files
        Collection.all.should == files
      end
    end

    describe Collection, "#linked" do
      before do
        Collection.stub(:all).and_return home_files
      end
      let(:filenames) { Collection.linked }
      it "should return the right Units" do
        filenames.should include @vimrc
        filenames.should_not include @gitconfig
        filenames.should_not include @bashrc
      end
      it "should yield the correct Units" do
        expect { |b| Collection.linked(&b) }.to yield_successive_args(*filenames)
      end
    end

    describe Collection, "#unlinked" do
      before do
        Collection.stub(:all).and_return home_files
      end
      let(:filenames) { Collection.unlinked }
      it "should return the right Units" do
        filenames.should include @gitconfig
        filenames.should include @bashrc
        filenames.should_not include @vimrc
      end
      it "should yield the correct Units" do
        expect { |b| Collection.unlinked(&b) }.to yield_successive_args(*filenames)
      end
    end

  end
end
