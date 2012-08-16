require 'spec_helper'

module Dotify
  describe PointerActor do
    describe "methods enforced" do
      it { should respond_to :link_from_source }
      it { should respond_to :link_to_destination }
      it { should respond_to :link_to_source }
      it { should respond_to :link_from_destination }
      it { should respond_to :move_to_source }
      it { should respond_to :move_to_destination }
      it { should respond_to :remove_source }
      it { should respond_to :remove_destination }
    end
  end
end
