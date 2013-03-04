require 'spec_helper'

include Dotify

describe Configure do
  describe "#start" do

    context "without any settings" do
      subject do
        Configure.start { |d| }
      end
      its(:editor) { should == 'vim' }
    end

    context "with and editor set" do
      subject do
        Configure.start do |d|
          d.editor { "emacs" }
        end
      end
      its(:editor) { should == 'emacs' }
    end

    context "with an editor name set as a symbol" do
      subject do
        Configure.start do |d|
          d.editor { :emacs }
        end
      end
      its(:editor) { should == 'emacs' }
    end

    context "with ignore settings with defaults" do
      subject do
        Configure.start do |d|
          d.ignore { '.sublime' }
        end
      end
      its(:editor) { should == 'vim' }
      its(:ignore) { should have(3).items }
      its(:ignore) { should include '.DS_Store' }
      its(:ignore) { should include '.git' }
      its(:ignore) { should include '.sublime' }
    end

  end
end
