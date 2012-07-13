require 'spec_helper'
require 'dotify/unit'

class DummyUnit
  def dotfile
    '.dummy'
  end
  def dotify
    '.dotify/.dummy'
  end

  def linked?; end
  def in_home_dir?; true; end
  def in_dotify?; true; end
end

module Dotify

  describe Actions do
    let!(:dummy) { DummyUnit.new }
    subject { dummy }
    before { dummy.extend(Actions) }
    it { should respond_to :link }
    it { should respond_to :unlink }

    describe Actions, "#link" do
      before do
        subject.stub(:linked?) { false }
      end
      it "should not do anything if the file is linked" do
        subject.stub(:linked?) { true }
        subject.link.should == false
      end
      it "should not do anything if the is not in the home directory" do
        subject.stub(:linked?) { true }
        subject.stub(:in_home_dir?) { false }
        subject.link.should == false
      end
      it "should copy the file from the home directory if it is not in Dotify" do
        FileUtils.should_receive(:rm_rf).with(subject.dotfile, :verbose => false)
        FileUtils.should_receive(:ln_sf).with(subject.dotify, subject.dotfile, :verbose => false)
        subject.link
      end
      it "should simply remove the file from the home and relink it" do
        subject.stub(:in_dotify?) { false }
        FileUtils.should_receive(:cp_r).with(subject.dotfile, subject.dotify, :verbose => false)
        FileUtils.stub(:rm_rf)
        FileUtils.stub(:ln_sf)
        subject.link
      end
    end
    describe Actions, "#unlink" do
      it "should not do anything if the file is not linked" do
        subject.stub(:linked?) { false }
        FileUtils.should_not_receive(:rm_rf)
        FileUtils.should_not_receive(:cp_r)
        FileUtils.should_not_receive(:rm_rf)
        subject.unlink.should == false
      end
      it "should call the right FileUtils methods" do
        subject.stub(:linked?) { true }
        FileUtils.should_receive(:rm_rf).with(subject.dotfile, :verbose => false)
        FileUtils.should_receive(:cp_r).with(subject.dotify, subject.dotfile, :verbose => false)
        FileUtils.should_receive(:rm_rf).with(subject.dotify, :verbose => false)
        subject.unlink
      end
    end
  end
  describe Unit do

    describe "populates the attributes correctly" do
      let(:unit) { Unit.new(".vimrc") }
      subject { unit }
      it { should respond_to :filename }
      it { should respond_to :dotify }
      it { should respond_to :dotfile }
      it { should respond_to :dotfile }
      it { should respond_to :linked? }
      it { should respond_to :linked }

      it "should set the attributes properly" do
        unit.filename.should == '.vimrc'
        unit.dotify.should == '/tmp/home/.dotify/.vimrc'
        unit.dotfile.should == '/tmp/home/.vimrc'
      end
      it "should puts the filename" do
        unit.to_s.should == unit.filename
      end
    end

    describe "existence in directories" do
      let(:unit) { Unit.new(".bashrc") }
      it "should check for the existence in the home directory" do
        File.stub(:exists?).with(unit.dotfile).and_return true
        unit.in_home_dir?.should == true
      end
      it "should return false if the file is not in the home directory" do
        File.stub(:exists?).with(unit.dotfile).and_return false
        unit.in_home_dir?.should_not == true
      end
      it "should check for the existence of the file in Dotify" do
        File.stub(:exists?).with(unit.dotify).and_return true
        unit.in_dotify?.should == true
      end
      it "should return false if the file is not in Dotify" do
        File.stub(:exists?).with(unit.dotify).and_return false
        unit.in_dotify?.should == false
      end
    end

    describe Unit, "#linked_to_dotify?" do
      let(:unit) { Unit.new(".bashrc") }
      it "should return false when an error is raised" do
        unit.stub(:symlink).and_return NoSymlink
        unit.linked_to_dotify?.should be_false
      end
      it "should return true if the dotfile is linked to the Dotify file" do
        unit.stub(:symlink).and_return unit.dotify
        unit.linked_to_dotify?.should be_true
      end
      it "should return false if the dotfile is not linked to the Dotify file" do
        File.stub(:readlink).with(unit.dotfile).and_return '/tmp/home/.another_file'
        unit.linked_to_dotify?.should be_false
      end
    end

    describe Unit, "#linked?" do
      let(:unit) { Unit.new(".bashrc") }
      before do
        unit.stub(:in_dotify?).and_return true # stub identical file check
      end
      it "should return true if all checks work" do
        unit.stub(:linked_to_dotify?).and_return true # stub dotify file exist check
        unit.linked?.should == true
      end
      it "should return false if one or more checks fail" do
        unit.stub(:linked_to_dotify?).and_return false # stub dotify file exist check
        unit.linked?.should == false
      end
    end

    describe Unit, "#symlink" do
      let!(:unit) { Unit.new(".symlinked") }
      it "should return the symlink for the file" do
        File.should_receive(:readlink).with(unit.dotfile).once
        unit.symlink
      end
      it "should return NoSymlink if error or no symlink" do
        File.stub(:readlink).with(unit.dotfile).and_raise(StandardError)
        expect { unit.symlink }.not_to raise_error
        unit.symlink.should == NoSymlink
      end
    end

    describe "inspecting unit" do
      it "should display properly" do
        Unit.new(".zshrc").inspect.should == "#<Dotify::Unit filename: '.zshrc' linked: false>"
        bash = Unit.new(".bashrc")
        bash.stub(:linked?).and_return true
        bash.inspect.should == "#<Dotify::Unit filename: '.bashrc' linked: true>"

      end
    end

  end
end
