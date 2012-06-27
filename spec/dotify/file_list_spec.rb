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
    it "filter out . and .. directories" do
      Dir.stub(:[]).with(glob).and_return(%w[. .. /spec/test/.vimrc /spec/test/.bashrc /spec/test/.zshrc])
      result = Dotify::FileList.list(glob)
      result.should include '.vimrc'
      result.should_not include '.'
      result.should_not include '..'
    end
  end

  describe Dotify::FileList, "#paths" do
    let(:glob) { '/spec/test/.*' }
    it "should pull the glob of dotfiles from a directory" do
      Dir.should_receive(:[]).with(glob).and_return(%w[. .. /spec/test/.vimrc /spec/test/.bashrc /spec/test/.zshrc])
      Dotify::FileList.paths(glob)
    end
    it "filter out . and .. directories" do
      Dir.stub(:[]).with(glob).and_return(%w[. .. /spec/test/.vimrc /spec/test/.bashrc /spec/test/.zshrc])
      result = Dotify::FileList.paths(glob)
      result.should include '/spec/test/.vimrc'
      result.should include '/spec/test/.bashrc'
      result.should include '/spec/test/.zshrc'
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
