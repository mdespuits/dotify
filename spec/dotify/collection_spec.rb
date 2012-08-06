require 'spec_helper'

module Dotify

  module Config
    def reset!
      @hash = nil
    end
    def stub_config(hash)
      @hash = hash
    end
  end

  describe Collection do

    before { Config.reset! }

    let(:ldot) { LinkedDot.new(".gitconfig") }
    let(:udot) { UnlinkedDot.new(".zshrc") }

    subject { Collection.new([ldot, ldot, ldot, ldot, udot, udot]) }

    it { should respond_to :filenames }
    it { should respond_to :linked }
    it { should respond_to :unlinked }
    it { should respond_to :to_s }
    it { should respond_to :inspect }

    it { should have(6).dots }

    its(:filenames) { should include ".gitconfig" }
    its(:filenames) { should include ".zshrc" }

    its(:linked) { should include ldot }
    its(:linked) { should have(4).dots }

    its(:unlinked) { should include udot }
    its(:unlinked) { should have(2).dots }

    describe "class methods" do
      subject { Collection }
      it { should respond_to :dotfiles }
      it { should respond_to :home }
      it { should respond_to :dotify }
    end

  end

  describe Collection::Dir do

    subject { Collection::Dir }

    it { should respond_to :[] }

    describe "#[]" do
      before do
        ::Dir.stub(:[]).with("some-path").and_return %w[. .. .bashrc /path/to/another/file]
      end
      subject { Collection::Dir["some-path"] }
      it { should include '.bashrc' }
      it { should include '/path/to/another/file' }
      it { should_not include '.' }
      it { should_not include '..' }
    end

  end
end
