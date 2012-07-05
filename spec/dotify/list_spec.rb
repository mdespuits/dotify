require 'spec_helper'

module Dotify
  describe List do

    describe List, "#home" do
      it "should call List#list with the correct path" do
        List.should_receive(:units).with("/tmp/home/.*").once.and_return([])
        List.home
      end
      it "should drop files that have been specified to be ignored" do
        List.stub(:units) do
          [
            Unit.new('.zshrc'),
            Unit.new('.bashrc'),
            Unit.new('.vimrc'),
            Unit.new('.gitconfig')
          ]
        end
        Config.stub(:ignore).with(:dotfiles).and_return %w[.zshrc .vimrc]
        result = List.home.map(&:filename)
        result.should include '.bashrc'
        result.should include '.gitconfig'
        result.should_not include '.zshrc'
        result.should_not include '.vimrc'
      end
    end

    describe List, "#dotify" do
      it "should call List#list with the correct path" do
        List.should_receive(:units).with("/tmp/home/.dotify/.*").once.and_return([])
        List.dotify
      end
      it "should drop files that have been specified to be ignored" do
        List.stub(:units) do
          [
            Unit.new(".gitconfig"),
            Unit.new('.vimrc'),
            Unit.new('.zshrc'),
            Unit.new('.bashrc'),
            Unit.new('.fakefile')
          ]
        end
        Config.stub(:ignore).with(:dotify).and_return %w[.gitconfig .bashrc]
        result = List.filenames(List.dotify)
        result.should include '.vimrc'
        result.should include '.zshrc'
        result.should include '.fakefile'
        result.should_not include '.bashrc'
        result.should_not include '.gitconfig'
      end
    end

    describe List, "#units" do
      let(:glob) { '/spec/test/.*' }
      it "should pull the glob of dotfiles from a directory" do
        Dir.should_receive(:[]).with(glob).and_return(%w[. .. /spec/test/.vimrc /spec/test/.bashrc /spec/test/.zshrc])
        List.units(glob)
      end
      describe "return values" do
        before do
          Dir.stub(:[]).with(glob).and_return(%w[. .. /spec/test/.vimrc /spec/test/.bashrc /spec/test/.zshrc])
        end
        let(:files) { List.units(glob) }
        it "should return the right directories" do
          f = files.map(&:filename)
          f.should include '.vimrc'
          f.should include '.bashrc'
          f.should include '.zshrc'
        end
        it "should filter out . and .. directories" do
          f = files.map(&:filename)
          f.should_not include '.'
          f.should_not include '..'
        end
      end
    end

    describe List, "#filenames" do
      let(:files) { [
        Unit.new('.vimrc'), Unit.new('.bashrc'), Unit.new('.zshrc')
      ] }
      it "return only the filenames of the units" do
        result = List.filenames(files)
        result.should include '.vimrc'
        result.should include '.bashrc'
        result.should include '.zshrc'
      end
    end


  end
end
