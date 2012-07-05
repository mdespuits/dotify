require 'dotify/cabinet'

describe Dotify::Cabinet do

  before do
    Dotify::Cabinet.any_instance.stub(:check_file_existence!)
    Dotify::Config.stub(:home).and_return("/tmp/home")
  end

  describe "populates the attributes correctly" do
    let(:cabinet) { Dotify::Cabinet.new(".vimrc") }
    subject { cabinet }
    it { should respond_to :filename }
    it { should respond_to :dotify }
    it { should respond_to :dotfile }
    it { should respond_to :linked? }
    it { should respond_to :linked }
    it { should respond_to :added? }
    it { should respond_to :added }

    it "should set the attributes properly" do
      cabinet.filename.should == '.vimrc'
      cabinet.dotify.should == '/tmp/home/.dotify/.vimrc'
      cabinet.dotfile.should == '/tmp/home/.vimrc'
    end
  end

  describe "existence in directories" do
    let(:cabinet) { Dotify::Cabinet.new(".bashrc") }
    subject { cabinet }
    it "should check for the existence in the home directory" do
      File.stub(:exists?).with(cabinet.dotfile).and_return true
      cabinet.should be_in_home
    end
    it "should return false if the file is not in the home directory" do
      File.stub(:exists?).with(cabinet.dotfile).and_return false
      cabinet.should_not be_in_home
    end
    it "should check for the existence of the file in Dotify" do
      File.stub(:exists?).with(cabinet.dotify).and_return true
      cabinet.should be_in_dotify
    end
    it "should return false if the file is not in Dotify" do
      File.stub(:exists?).with(cabinet.dotify).and_return false
      cabinet.should_not be_in_dotify
    end
  end

  describe Dotify::Cabinet, "#dotfile_linked_to_dotify?" do
    let(:cabinet) { Dotify::Cabinet.new(".bashrc") }
    subject { cabinet }
    it "should return false when an error is raised" do
      File.stub(:readline).and_raise StandardError
      cabinet.dotfile_linked_to_dotify?.should be_false
    end
    it "should return true if the dotfile is linked to the Dotify file" do
      File.stub(:readlink).with(cabinet.dotfile).and_return cabinet.dotify
      cabinet.dotfile_linked_to_dotify?.should be_true
    end
    it "should return false if the dotfile is not linked to the Dotify file" do
      File.stub(:readlink).with(cabinet.dotfile).and_return '/tmp/home/.another_file'
      cabinet.dotfile_linked_to_dotify?.should be_false
    end
  end

  describe Dotify::Cabinet, "#linked?" do
    let(:cabinet) { Dotify::Cabinet.new(".bashrc") }
    subject { cabinet }
    before do
      cabinet.stub(:in_dotify?).and_return true # stub identical file check
    end
    it "should return true if all checks work" do
      cabinet.stub(:dotfile_linked_to_dotify?).and_return true # stub dotify file exist check
      cabinet.should be_linked
    end
    it "should return false if one or more checks fail" do
      cabinet.stub(:dotfile_linked_to_dotify?).and_return false # stub dotify file exist check
      cabinet.should_not be_linked
    end
  end

  describe Dotify::Cabinet, "#added?" do
    let(:cabinet) { Dotify::Cabinet.new(".added") }
    subject { cabinet }
    before do
      cabinet.stub(:in_dotify?).and_return true # stub dotify file exist check
    end
    it "should return true if all checks work" do
      cabinet.stub(:dotfile_linked_to_dotify?).and_return false # stub identical file check
      cabinet.should be_added
    end
    it "should return false if one or more checks fail" do
      cabinet.stub(:dotfile_linked_to_dotify?).and_return true # stub identical file check
      cabinet.should_not be_added
    end
  end

end
