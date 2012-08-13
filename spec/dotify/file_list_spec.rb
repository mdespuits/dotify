require 'spec_helper'

module Dotify
  describe FileList do
    subject { FileList }
    it { should respond_to :pointers }
    it { should respond_to :destinations }
    it { should respond_to :complete }
  end
end