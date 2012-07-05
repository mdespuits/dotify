require 'dotify/config'
require 'dotify/list'
require 'dotify/files'
require 'fileutils'

describe Dotify::Files do


  before do
    Dotify::Config.stub(:home).and_return '/home/tmp'
  end
  describe "methods" do
    it "should respond to linked" do
      Dotify::Files.should respond_to :linked
    end
    it "should respond to installed" do
      Dotify::Files.should respond_to :installed
    end
    it "should respond to unlinked" do
      Dotify::Files.should respond_to :unlinked
    end
  end

  it "should split a filename correct" do
    Dotify::Files.filename("some/random/path/to/file.txt").should == 'file.txt'
    Dotify::Files.filename("another/path/no_extension").should == 'no_extension'
  end

  describe Dotify::Files, "#home" do
    it "should return the path to the file when it is linked in the root" do
      Dotify::Files.home.should == '/home/tmp'
    end
    it "should return the path to the file when it is linked in the root" do
      Dotify::Files.home(".vimrc").should == '/home/tmp/.vimrc'
      Dotify::Files.home("/spec/home/.bashrc").should == '/home/tmp/.bashrc'
    end
  end

  describe Dotify::Files, "#dotify" do
    it "should return the path to the file when it is linked in the root" do
      Dotify::Files.dotify.should == '/home/tmp/.dotify'
    end
    it "should return the path to the file when it is linked in the root" do
      Dotify::Files.dotify(".vimrc").should == '/home/tmp/.dotify/.vimrc'
      Dotify::Files.dotify("/spec/home/.bashrc").should == '/home/tmp/.dotify/.bashrc'
    end
  end

  describe Dotify::Files, "#linked" do
    before do
      Dotify::List.stub(:dotify) do
        ['/spec/test/.bash_profile', '/spec/test/.bashrc', '/spec/test/.zshrc']
      end
    end
    let!(:files) { Dotify::Files.linked }
    it "should return the list of dotfiles in the dotify path" do
      files.map! { |f| Dotify::Files.filename(f) }
      files.should include '.bash_profile'
      files.should include '.bashrc'
      files.should include '.zshrc'
    end
    it "shoud yield the files if a block is given" do
      yields = files.map { |f| [f, Dotify::Files.filename(f)] }
      expect { |b| Dotify::Files.linked(&b) }.to yield_successive_args(*yields)
    end
  end

  describe Dotify::Files, "#unlinked" do
    before do
      Dotify::Files.stub(:linked) do
        ['/spec/test/.vimrc', '/spec/test/.bashrc', '/spec/test/.zshrc']
      end
      Dotify::Files.stub(:installed) do
        ['/root/test/.bashrc', '/root/test/.zshrc']
      end
    end
    it "should return the list of unlinked dotfiles in the root path" do
      unlinked = Dotify::Files.unlinked.map { |u| Dotify::Files.filename(u) }
      unlinked.should include '.vimrc'
      unlinked.should_not include '.bashrc'
    end
    it "shoud yield the unlinked files if a block is given" do
      unlinked = Dotify::Files.unlinked.map { |u| [u, Dotify::Files.filename(u)] }
      expect { |b| Dotify::Files.unlinked(&b) }.to yield_successive_args(*unlinked)
    end
  end

  describe Dotify::Files, "#installed" do
    before do
      Dotify::Files.stub(:linked) do
        %w[/spec/test/.zshrc /spec/test/.bashrc /spec/test/.vimrc /spec/test/.dotify]
      end
      Dotify::List.stub(:home) do
        %w[/root/test/.bashrc /root/test/.vimrc]
      end
    end
    it "should return the list of installed dotfiles in the root path" do
      installed = Dotify::Files.installed.map { |i| Dotify::Files.filename(i) }
      installed.should include '.vimrc'
      installed.should include '.bashrc'
      installed.should_not include '.zshrc'
      installed.should_not include '.dotify'
    end
    it "shoud yield the installed files if a block is given" do
      installed = Dotify::Files.installed.map { |i| [i, Dotify::Files.filename(i)] }
      expect { |b| Dotify::Files.installed(&b) }.to yield_successive_args(*installed)
    end
  end

  describe Dotify::Files, "#uninstalled" do
    before do
      Dotify::Files.stub(:linked) do
        %w[/spec/test/.zshrc /spec/test/.bashrc /spec/test/.vimrc /spec/test/.dotify]
      end
      Dotify::List.stub(:home) do
        %w[/root/test/.zshrc /root/test/.bashrc /root/test/.pryrc /root/test/.dropbox]
      end
    end
    it "should return the list of uninstalled dotfiles in the root path" do
      uninstalled = Dotify::Files.uninstalled.map { |i| Dotify::Files.filename(i) }
      uninstalled.should_not include '.zshrc'
      uninstalled.should_not include '.bashrc'
      uninstalled.should include '.pryrc'
      uninstalled.should include '.dropbox'
    end
    it "shoud yield the installed files if a block is given" do
      uninstalled = Dotify::Files.uninstalled.map { |i| [i, Dotify::Files.filename(i)] }
      expect { |b| Dotify::Files.uninstalled(&b) }.to yield_successive_args(*uninstalled)
    end
  end

  describe Dotify::Files, "#link_dotfile" do
    it "should receive a file and link it into the root path" do
      first = File.join(Dotify::Config.path, ".vimrc")
      FileUtils.should_receive(:ln_s).with(Dotify::Files.filename(first), Dotify::Config.home).once
      Dotify::Files.link_dotfile first
    end
  end

  describe Dotify::Files, "#unlink_dotfile" do
    it "should receive a file and remove it from the root" do
      first = "/spec/test/.file"
      FileUtils.stub(:rm_rf).with(File.join(Dotify::Config.home, Dotify::Files.filename(first))).once
      Dotify::Files.unlink_dotfile first
      FileUtils.unstub(:rm_rf)
    end
  end
end
