require 'spec_helper'

module Dotify
  describe PointerActor do
    describe "ensure FileUtils methods are available" do
      around do |example|
        # FileUtils methods are included privately,
        # so we expose them long enough to test they
        # are indeed there.
        PointerActor.class_eval do
          public :rm_rf
          public :touch
        end
        example.run
        PointerActor.class_eval do
          private :rm_rf
          private :touch
        end
      end
      it { should respond_to :touch }
      it { should respond_to :rm_rf }
    end
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
