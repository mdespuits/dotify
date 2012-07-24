require 'dotify/cli/listing'
require 'thor/shell/color'
require 'spec_helper'

module Dotify
  module CLI
    describe Listing do
      let(:collection) do
        [
          Dot.new(".dotrc"),
          Dot.new(".gitconfig"),
          Dot.new(".vimrc"),
          Dot.new(".zshrc")
        ]
      end
      let(:listing) { Listing.new(collection, { :force => true }) }
      before { listing.stub(:inform) }
      it "should assign the passed array to the :collection attr_reader" do
        listing.collection.should == collection
        listing.options.should == { :force => true }
      end
      it "should count the files correctly" do
        listing.collection.stub(:count).and_return 3
        listing.count.should == 3
      end
      it "should call say the right number of times" do
        Thor::Shell::Color.any_instance.should_receive(:say).exactly(listing.collection.size).times
        listing.write
      end
      it "should output the right content if there are no dotfiles managed" do
        listing.should_receive(:inform).once
        listing.stub(:collection).and_return []
        listing.write
      end
    end
  end
end
