Given /^the host platform is "([^\"]*)"$/ do |platform|
  if platform == "mac"
    Dotify::OperatingSystem.stub(:guess).and_return :mac
  elsif platform == "linux"
    Dotify::OperatingSystem.stub(:guess).and_return :linux
  end
end

When /^Dotify attempts to load configuration$/ do
  Dotify.config.setup_default_configuration
  Dotify::FileList.dotfile_pointers
  Dotify.config.load!
end

Then /^Dotify should have default configuration$/ do
  Dotify.config
  Dotify.config.editor.should == "vim"
  Dotify.config.shared_ignore.should include ".DS_Store"
  Dotify.config.shared_ignore.should include ".Trash"
  Dotify.config.shared_ignore.should include ".git"
end

Then /^Dotify's editor should be "([^\"]*)"/ do |editor|
  Dotify.config.editor.should == editor
end
