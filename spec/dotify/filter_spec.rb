require 'spec_helper'

module Dotify
  describe Filter do

    describe Filter, "#home" do
      it "should call Filter#units with the correct path" do
        Filter.should_receive(:units).with("/tmp/home/.*").once.and_return([])
        Filter.home
      end
      it "should drop files that have been specified to be ignored" do
        Filter.stub(:units) do
          [
            Unit.new('.zshrc'),
            Unit.new('.bashrc'),
            Unit.new('.vimrc'),
            Unit.new('.gitconfig')
          ]
        end
        Config.stub(:ignore).with(:dotfiles).and_return %w[.zshrc .vimrc]
        result = Filter.home.map(&:filename)
        result.should include '.bashrc'
        result.should include '.gitconfig'
        result.should_not include '.zshrc'
        result.should_not include '.vimrc'
      end
    end

    describe Filter, "#dotify" do
      it "should call Filter#units with the correct path" do
        Filter.should_receive(:units).with("/tmp/home/.dotify/.*").once.and_return([])
        Filter.dotify
      end
      it "should drop files that have been specified to be ignored" do
        Filter.stub(:units) do
          [
            Unit.new(".gitconfig"),
            Unit.new('.vimrc'),
            Unit.new('.zshrc'),
            Unit.new('.bashrc'),
            Unit.new('.fakefile')
          ]
        end
        Config.stub(:ignore).with(:dotify).and_return %w[.gitconfig .bashrc]
        result = Filter.filenames(Filter.dotify)
        result.should include '.vimrc'
        result.should include '.zshrc'
        result.should include '.fakefile'
        result.should_not include '.bashrc'
        result.should_not include '.gitconfig'
      end
    end

    describe Filter, "#units" do
      let(:glob) { '/spec/test/.*' }
      it "should pull the glob of dotfiles from a directory" do
        Dir.should_receive(:[]).with(glob).and_return(%w[. .. /spec/test/.vimrc /spec/test/.bashrc /spec/test/.zshrc])
        Filter.units(glob)
      end
      describe "return values" do
        before do
          Dir.stub(:[]).with(glob).and_return(%w[. .. /spec/test/.vimrc /spec/test/.bashrc /spec/test/.zshrc])
        end
        let(:files) { Filter.units(glob) }
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

    describe Filter, "#filenames" do
      let(:files) { [
        Unit.new('.vimrc'), Unit.new('.bashrc'), Unit.new('.zshrc')
      ] }
      it "return only the filenames of the units" do
        result = Filter.filenames(files)
        result.should include '.vimrc'
        result.should include '.bashrc'
        result.should include '.zshrc'
      end
    end


  end
end
