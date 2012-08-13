require 'spec_helper'

class Dotify::FileList
  def self.reset!
    @pointers = []
  end
end

module Dotify
  describe FileList do
    before { FileList.reset! }
    subject { FileList }
    it { should respond_to :pointers }
    it { should respond_to :destinations }
    it { should respond_to :complete }

    describe "#add" do
      it { should respond_to :add }
      describe "adding sources" do
        let(:pointer) { double("pointer") }
        before { FileList.add pointer }
        its(:pointers) { should include pointer }
      end
    end
  end
end