require 'spec_helper'
require 'dotify/config'
require 'dotify/file_list'

describe Dotify::FileList do

  describe Dotify::FileList, "#list" do
    let(:glob) { '/spec/test/.*' }
    it "should pull the glob of dotfiles from a directory" do
      Dir.should_receive(:[]).with(glob).and_return(%w[. .. /spec/test/.vimrc /spec/test/.bashrc /spec/test/.zshrc])
      Dotify::FileList.list(glob)
    end
    describe "return values" do
      before do
        Dir.stub(:[]).with(glob).and_return(%w[. .. /spec/test/.vimrc /spec/test/.bashrc /spec/test/.zshrc])
      end
      let(:files) { Dotify::FileList.list(glob) }
      it "should return the right filenames" do
        files.should include '.vimrc'
        files.should include '.bashrc'
        files.should include '.zshrc'
      end
      it "should filter out . and .. directories" do
        files.should_not include '.'
        files.should_not include '..'
      end
    end
  end

  describe Dotify::FileList, "#paths" do
    let(:glob) { '/spec/test/.*' }
    it "should pull the glob of dotfiles from a directory" do
      Dir.should_receive(:[]).with(glob).and_return(%w[. .. /spec/test/.vimrc /spec/test/.bashrc /spec/test/.zshrc])
      Dotify::FileList.paths(glob)
    end
    describe "return values" do
      before do
        Dir.stub(:[]).with(glob).and_return(%w[. .. /spec/test/.vimrc /spec/test/.bashrc /spec/test/.zshrc])
      end
      let(:files) { Dotify::FileList.paths(glob) }
      it "should return the right directories" do
        files.should include '/spec/test/.vimrc'
        files.should include '/spec/test/.bashrc'
        files.should include '/spec/test/.zshrc'
      end
      it "should filter out . and .. directories" do
        files = Dotify::FileList.paths(glob)
        files.should_not include '.'
        files.should_not include '..'
      end
    end
  end

  describe Dotify::FileList, "#filenames" do
    let(:files) { %w[/spec/test/.vimrc /spec/test/.bashrc /spec/test/.zshrc] }
    it "should use Files#file_name to change the files" do
      Dotify::Files.should_receive(:file_name).exactly(files.count).times
      Dotify::FileList.filenames(files)
    end
    it "return only" do
      result = Dotify::FileList.filenames(files)
      result.should include '.vimrc'
      result.should include '.bashrc'
      result.should include '.zshrc'
    end
  end


end
