require 'spec_helper'

module Dotify
  describe Files do

    let(:home_files) {
      [
        @bashrc = double('unit1', :filename => '.bashrc', :added? => true, :linked? => false),
        @gitconfig = double('unit2', :filename => '.gitconfig', :added? => false, :linked? => false),
        @vimrc = double('unit3', :filename => '.vimrc', :added? => true, :linked? => true),
      ]
    }
    describe "methods" do
      %w[all linked unlinked uninstalled].each do |name|
        it "should respond to #{name}" do
          Files.should respond_to name
        end
      end
    end

    describe Files, "#all" do
      it "should pull the right files from List.home" do
        files = [stub, stub, stub]
        List.stub(:home).and_return files
        Files.all.should == files
      end
    end

    describe Files, "#linked" do
      before do
        Files.stub(:all).and_return home_files
      end
      let(:filenames) { Files.linked }
      it "should return the right Units" do
        filenames.should include @vimrc
        filenames.should_not include @gitconfig
        filenames.should_not include @bashrc
      end
      it "should yield the correct Units" do
        expect { |b| Files.linked(&b) }.to yield_successive_args(*filenames)
      end
    end

    describe Files, "#unlinked" do
      before do
        Files.stub(:all).and_return home_files
      end
      let(:filenames) { Files.unlinked }
      it "should return the right Units" do
        filenames.should include @gitconfig
        filenames.should include @bashrc
        filenames.should_not include @vimrc
      end
      it "should yield the correct Units" do
        expect { |b| Files.unlinked(&b) }.to yield_successive_args(*filenames)
      end
    end

    describe Files, "#uninstalled" do
      before do
        Files.stub(:all).and_return home_files
      end
      let(:filenames) { Files.uninstalled }
      it "should return the right Units" do
        filenames.should include @gitconfig
        filenames.should_not include @bashrc
        filenames.should_not include @vimrc
      end
      it "should yield the correct Units" do
        expect { |b| Files.uninstalled(&b) }.to yield_successive_args(*filenames)
      end
    end

    it "should split a filename correct" do
      Files.filename("some/random/path/to/file.txt").should == 'file.txt'
      Files.filename("another/path/no_extension").should == 'no_extension'
    end

    describe Files, "#home" do
      it "should point to the home directory" do
        Files.home.should == '/tmp/home'
      end
      it "should return a absolute path to the file in the home directory" do
        Files.home(".vimrc").should == '/tmp/home/.vimrc'
        Files.home("/spec/home/.bashrc").should == '/tmp/home/.bashrc'
      end
    end

    describe Files, "#dotify" do
      it "should point to the Dotify directory" do
        Files.dotify.should == '/tmp/home/.dotify'
      end
      it "should return a absolute path to the file in Dotify" do
        Files.dotify(".vimrc").should == '/tmp/home/.dotify/.vimrc'
        Files.dotify("/spec/home/.bashrc").should == '/tmp/home/.dotify/.bashrc'
      end
    end

    describe Files, "#link_dotfile" do
      it "should receive a file and link it into the root path" do
        first = File.join(Config.path, ".vimrc")
        FileUtils.should_receive(:ln_s).with(Files.filename(first), Config.home).once
        Files.link_dotfile first
      end
    end

    describe Files, "#unlink_dotfile" do
      it "should receive a file and remove it from the root" do
        first = "/spec/test/.file"
        FileUtils.stub(:rm_rf).with(File.join(Config.home, Files.filename(first))).once
        Files.unlink_dotfile first
        FileUtils.unstub(:rm_rf)
      end
    end
  end
end
