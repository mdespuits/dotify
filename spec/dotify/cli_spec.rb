require 'spec_helper'
require 'dotify'
require 'thor'

module Dotify
  describe CLI do
    let!(:cli) { CLI.new }
    before do
      Dotify.stub(:installed?).and_return true
      cli.stub(:exec)
      cli.stub(:collection) { Collection.new }
    end

    describe CLI, "#edit" do
      let(:unit) { double('unit', :linked? => true, :dotify => '/tmp/dotify/.vimrc') }
      before { Unit.stub(:new).and_return(unit) }
      it "should open the editor with the passed file" do
        cli.should_receive(:exec).with([Config.editor, unit.dotify].join(" "))
        cli.edit('.vimrc')
      end
      it "should  the editor with the passed file" do
        cli.should_receive(:save)
        cli.stub(:options).and_return({ :save => true })
        cli.edit '.vimrc'
      end
      it "should not edit the file if it has not been linked" do
        unit.stub(:linked?).and_return false
        cli.should_receive(:say).with("'#{unit}' has not been linked by Dotify. Please run `dotify link #{unit}` to edit this file.", :blue)
        cli.edit('.vimrc')
      end
    end

    describe CLI, "#link" do
      before do
        cli.stub(:collection).and_return(
          double('collection', {
            :unlinked => [double('.zshrc', :in_home_dir? => true, :linked? => false), double('.gitconfig', :in_home_dir? => true, :linked? => false)],
            :linked => [double('.vimrc', :in_home_dir? => true, :linked? => true)]
          })
        )
        cli.stub(:link_file)
      end
      it "should loop through all unlinked files" do
        cli.collection.should_receive(:unlinked)
        cli.should_receive(:link_file).exactly(cli.collection.unlinked.size).times
        cli.link
      end
      it "should relink all of the files located in Dotify" do
        cli.collection.should_not_receive(:unlinked)
        cli.collection.should_receive(:linked)
        cli.stub(:options).and_return({ :relink => true })
        cli.link
      end
      it "attempt to link one single file" do
        cli.should_receive(:link_file).with(an_instance_of(Unit), {})
        cli.link('.vimrc')
      end
      it "should output a warning if Dotify is not installed" do
        Dotify.stub(:installed?).and_return false
        cli.should_receive(:not_setup_warning).once
        cli.link
      end
    end

    describe CLI, "#unlink" do
      before do
        cli.stub(:collection).and_return double(:linked => [double('.vimrc', :linked? => true), double('.bashrc', :linked? => true)])
        cli.stub(:unlink_file)
      end
      it "should loop through all unlinked files" do
        cli.collection.should_receive(:linked)
        cli.unlink
      end
      it "should call CLI#unlink_file the right number of times" do
        cli.collection.should_receive(:linked)
        cli.stub(:unlink_file)
        cli.should_receive(:unlink_file).exactly(cli.collection.linked.size).times
        cli.unlink
      end
      it "attempt to link one single file" do
        cli.should_receive(:unlink_file).with(an_instance_of(Unit), {})
        cli.unlink('.vimrc')
      end
      it "should output a warning if Dotify is not installed" do
        Dotify.stub(:installed?).and_return false
        cli.should_receive(:not_setup_warning).once
        cli.unlink
      end
    end
  end
end
