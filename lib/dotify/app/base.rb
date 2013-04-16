require 'optparse'
require 'dotify'

OPTIONS = OptionParser.new do |opts|

  opts.banner = "Usage: dotify [options]"

  opts.on "-m", "--manage [FILES]", Array, "Common separates files/directories Dotify should manage" do |files|
  end

  opts.on "-v", "--version", "Dotify current version" do
    abort "Dotify v#{Dotify::VERSION}"
  end

end.parse!
