require 'spec_helper'

include Dotify

describe OperatingSystem do

  subject { described_class }

  def self.spec_operating_system(config_name, pretty_name)
    context "when the OS is #{config_name}" do
      let(:os_name) { config_name }
      its(:guess) { should == pretty_name }
    end
  end

  describe "#guess" do

    GUESSES = {
      "darwin" => :mac,
      "mswin" => :windows,
      "windows" => :windows,
      "linux" => :linux,
      "solaris" => :solaris,
      "sunos" => :solaris,
      "other" => :unknown
    }

    before { OperatingSystem.stub(:host_os) { os_name } }

    GUESSES.each do |key, value|
      self.spec_operating_system(key, value)
    end

  end
end
