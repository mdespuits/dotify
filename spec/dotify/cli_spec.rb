require 'spec_helper'
require 'dotify/cli'
require 'thor'

module Dotify
  describe CLI::Base do
    let!(:cli) { CLI::Base.new }
    before do
      Dotify.stub(:installed?).and_return true
      vimrc = Dot.new('.zshrc')
      vimrc.stub(:linked?).and_return(true)
      bash_profile = Dot.new('.bash_profile')
      bash_profile.stub(:linked?).and_return(true)
      gitconfig = Dot.new('.gitconfig')
      gitconfig.stub(:linked?).and_return(false)
      zshrc = Dot.new('.zshrc')
      zshrc.stub(:linked?).and_return(false)
      Collection.any_instance.stub(:dots).and_return([vimrc, bash_profile, gitconfig, zshrc])
    end

    describe CLI::Base, "#source_root" do
      it "should return the right path" do
        CLI::Base.source_root.should == File.expand_path("../../../templates", __FILE__)
      end
    end

    describe CLI::Base, "github actions" do
      let(:opts) { Hash.new }
      let(:github) { double("Github") }
      before do
        cli.stub(:options).and_return opts
      end
      describe CLI::Base, "#save" do
        it "should call Github save and pass in the options" do
          CLI::Github.should_receive(:new).with(opts).and_return github
          github.should_receive(:save)
          cli.save
        end
      end
      describe CLI::Base, "#github" do
        it "should create a new instance of Github with the right options and call pull with the right repo" do
          CLI::Github.should_receive(:new).with(opts).and_return github
          github.should_receive(:pull).with("mattdbridges/repo")
          cli.github("mattdbridges/repo")
        end
      end
    end

    describe CLI::Base, "#list" do
      it "should delegate to the Listing class" do
        cli.stub(:options).and_return({ :force => true })
        list = CLI::Listing.new(Dotify.collection.linked)
        CLI::Listing.should_receive(:new).with(Dotify.collection.linked, { :force => true }).and_return list
        list.should_receive(:write)
        cli.list
      end
    end

    describe CLI::Base, "#edit" do
      let(:dot) { double('dot', :linked? => true, :dotify => '/tmp/dotify/.vimrc') }
      before do
        Dot.stub(:new).and_return(dot)
        cli.stub(:exec)
        Config.stub(:installed?).and_return true
      end
      it "should open the editor with the passed file" do
        cli.should_receive(:exec).with([Config.editor, dot.dotify].join(" "))
        cli.edit('.vimrc')
      end
      it "should  the editor with the passed file" do
        cli.should_receive(:save)
        cli.stub(:options).and_return({ :save => true })
        cli.edit '.vimrc'
      end
      it "should not edit the file if it has not been linked" do
        dot.stub(:linked?).and_return false
        cli.should_receive(:say).with("'#{dot}' has not been linked by Dotify. Please run `dotify link #{dot}` to edit this file.", :blue)
        cli.edit('.vimrc')
      end
    end

    describe CLI::Base, "#link" do
      before do
        cli.stub(:file_action)
        Config.stub(:installed?).and_return true
      end
      it "should loop through all unlinked files" do
        Dotify.collection.should_receive(:unlinked).and_return Dotify.collection.reject(&:linked?)
        cli.link
      end
      it "should call link_file on the right files" do
        cli.should_receive(:file_action).exactly(Dotify.collection.unlinked.size).times
        cli.link
      end
      it "should relink all of the files located in Dotify" do
        Dotify.collection.should_not_receive(:unlinked)
        Dotify.collection.should_receive(:linked).and_return []
        cli.stub(:options).and_return({ :relink => true })
        cli.link
      end
      it "attempt to link one single file" do
        cli.should_receive(:file_action).with(:link, an_instance_of(Dot), {})
        cli.link('.vimrc')
      end
    end

    describe CLI::Base, "#unlink" do
      before do
        cli.stub(:file_action)
        Config.stub(:installed?).and_return true
      end
      it "should loop through all unlinked files" do
        Dotify.collection.should_receive(:linked).and_return Dotify.collection.select(&:linked?)
        cli.unlink
      end
      it "should call CLI#unlink_file the right number of times" do
        cli.should_receive(:file_action).exactly(Dotify.collection.linked.size).times
        cli.unlink
      end
      it "attempt to link one single file" do
        cli.should_receive(:file_action).with(:unlink, an_instance_of(Dot), {})
        cli.unlink('.vimrc')
      end
    end
  end
end
