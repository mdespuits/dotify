require 'spec_helper'

module Dotify
  describe Files do

    let(:home_files) {
      [
        @bashrc = double('unit1', :filename => '.bashrc', :added? => true, :linked? => false),
        @gitconfig = double('unit2', :filename => '.gitconfig', :added? => false, :linked? => false),
        @vimrc = double('unit3', :filename => '.vimrc', :added? => true, :linked? => true),
      ]
    }
    describe "methods" do
      %w[all linked unlinked].each do |name|
        it "should respond to #{name}" do
          Files.should respond_to name
        end
      end
    end

    describe Files, "#all" do
      it "should pull the right files from List.home" do
        files = [stub, stub, stub]
        List.stub(:home).and_return files
        Files.all.should == files
      end
    end

    describe Files, "#linked" do
      before do
        Files.stub(:all).and_return home_files
      end
      let(:filenames) { Files.linked }
      it "should return the right Units" do
        filenames.should include @vimrc
        filenames.should_not include @gitconfig
        filenames.should_not include @bashrc
      end
      it "should yield the correct Units" do
        expect { |b| Files.linked(&b) }.to yield_successive_args(*filenames)
      end
    end

    describe Files, "#unlinked" do
      before do
        Files.stub(:all).and_return home_files
      end
      let(:filenames) { Files.unlinked }
      it "should return the right Units" do
        filenames.should include @gitconfig
        filenames.should include @bashrc
        filenames.should_not include @vimrc
      end
      it "should yield the correct Units" do
        expect { |b| Files.unlinked(&b) }.to yield_successive_args(*filenames)
      end
    end

  end
end
