require 'dotify/cabinet'

describe Dotify::Cabinet do

  before do
    Dotify::Cabinet.any_instance.stub(:check_file_existence!)
    Dotify::Config.stub(:home).and_return("/tmp/home")
  end

  describe "non-existent file check" do
    it "should raise an error if the home file does not exist" do
      Dotify::Cabinet.any_instance.unstub(:check_file_existence!)
      File.stub(:exists?).and_return false
      expect { Dotify::Cabinet.new(".fake") }.to raise_error(Dotify::CabinetDoesNotExist)
    end
    it "should not raise an error if the home file exists" do
      Dotify::Cabinet.any_instance.unstub(:check_file_existence!)
      File.stub(:exists?).and_return true
      expect { Dotify::Cabinet.new(".fake") }.not_to raise_error(Dotify::CabinetDoesNotExist)
    end
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

  describe Dotify::Cabinet, "#linked?" do
    let(:cabinet) { Dotify::Cabinet.new(".bashrc") }
    subject { cabinet }
    before do
      cabinet.stub(:readlink).with(cabinet.dotfile).and_return cabinet.dotify # stub identical file check
    end
    it "should return true if all checks work" do
      cabinet.stub(:file_in_dotify?).and_return true # stub dotify file exist check
      cabinet.should be_linked
    end
    it "should return false if one or more checks fail" do
      cabinet.stub(:file_in_dotify?).and_return false # stub dotify file exist check
      cabinet.should_not be_linked
    end
  end

  describe Dotify::Cabinet, "#added?" do
    let(:cabinet) { Dotify::Cabinet.new(".added") }
    subject { cabinet }
    before do
      cabinet.stub(:file_in_dotify?).and_return true # stub dotify file exist check
    end
    it "should return true if all checks work" do
      cabinet.stub(:readlink).with(cabinet.dotfile).and_return false # stub identical file check
      cabinet.should be_added
    end
    it "should return false if one or more checks fail" do
      cabinet.stub(:readlink).with(cabinet.dotfile).and_return cabinet.dotify # stub identical file check
      cabinet.should_not be_added
    end
  end

end
