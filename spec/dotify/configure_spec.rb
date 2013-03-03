require 'spec_helper'

module Dotify

  class Configure
    def self.reset!
      @options = {}
    end
  end

  describe Configure do
    let(:klass) { Configure.new }
    subject { klass }
    before { Configure.reset! }

    describe "#setup_default_configuration" do
      before { klass.setup_default_configuration }
      its(:editor) { should == 'vim' }
      its(:shared_ignore) { should include '.DS_Store' }
      its(:shared_ignore) { should include '.Trash' }
      its(:shared_ignore) { should include '.git' }
      its(:shared_ignore) { should include '.svn' }
    end

    describe "defined options" do
      describe "getting defined editor" do
        before { subject.options = { :editor => 'vi' } }
        its(:editor) { should == 'vi'}
      end
      describe "getting undefined editor" do
        its(:editor) { should be_instance_of NullObject }
      end
    end

  end
end
