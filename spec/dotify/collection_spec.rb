require 'spec_helper'

module Dotify
  describe Collection do

    let(:collection) { Collection.new }
    let(:home_files) {
      [
        @bashrc = double('unit1', :filename => '.bashrc', :linked? => false),
        @gitconfig = double('unit2', :filename => '.gitconfig', :linked? => false),
        @vimrc = double('unit3', :filename => '.vimrc', :linked? => true),
      ]
    }
    describe "methods" do
      %w[linked unlinked].each do |name|
        it "should respond to #{name}" do
          collection.should respond_to name
        end
      end
    end

    it "should pull the right files from Filter.home" do
      files = [stub, stub, stub]
      Filter.stub(:home).and_return files
      collection.units.should == files
    end

    describe Collection, "#linked" do
      before do
        collection.stub(:units).and_return home_files
      end
      let(:linked) { collection.linked }
      it "should return the right Units" do
        linked.should include @vimrc
        linked.should_not include @gitconfig
        linked.should_not include @bashrc
      end
      it "should yield the correct Units" do
        expect { |b| collection.linked.each(&b) }.to yield_successive_args(*linked)
      end
    end

    describe Collection, "#unlinked" do
      before do
        collection.stub(:units).and_return home_files
      end
      let(:unlinked) { collection.unlinked }
      it "should return the right Units" do
        unlinked.should include @gitconfig
        unlinked.should include @bashrc
        unlinked.should_not include @vimrc
      end
      it "should yield the correct Units" do
        expect { |b| collection.unlinked.each(&b) }.to yield_successive_args(*unlinked)
      end
    end

    it "should call #to_s on the units" do
      collection.units.should_receive(:to_s)
      collection.to_s
    end

    it "should call #inspect on the units" do
      collection.units.each { |u| u.should_receive(:inspect) }
      collection.inspect
    end

  end
end
