Given /^Dotify is not setup$/ do
  system "rm -rf #{File.join(ENV["HOME"], ".dotify")}"
end

Given /^I have setup Dotify$/i do
  system "mkdir -p #{Dotify::Config.path}"
  system "touch #{Dotify::Config.home(".dotrc")}"
end

When /^I try to setup Dotify$/ do
  @cli.stub(:say)
  @cli.stub(:invoke).with(:edit, [Dotify::Config.file]).once
  @cli.setup
end
