require 'dotify/cli/listing'
require 'thor/shell/color'
require 'spec_helper'

module Dotify
  module CLI
    describe Listing do
      let(:listing) { Listing.new }
      before { listing.stub(:inform) }
      it "should pull all of the linked files in Collection" do
        listing.collection.should == Dotify.collection.linked
      end
      it "should inform the user of the number of files linked" do
        listing.collection.stub(:count).and_return 3
        listing.count.should == 3
      end
      it "should output the right content" do
        listing.stub(:collection).and_return [
          Dot.new(".dotrc"),
          Dot.new(".gitconfig"),
          Dot.new(".vimrc"),
          Dot.new(".zshrc")
        ]
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
