Given /^the following files are in home:$/i do |table|
  @files_to_link = table.raw.flatten
  @files_to_link.each { |file| `touch #{Dotify::Config.home(file)}` }
end

Given /^(.*) does not exist in (home|dotify)$/i do |file, location|
  location = location == 'home' ? :home : :path
  puts `rm -rf #{Dotify::Config.send(location, file)}`
end

Given ".dotrc has contents:" do |content|
  File.open(Dotify::Config.file, 'w') do |f|
    f.puts content
  end
end

When /^they get linked by Dotify$/ do
  @files_to_link = Dotify::Collection.new(:dotfiles).map(&:filename)
  @files_to_link.each { |file| Dotify::Dot.new(file).link }
end

Then "$file should be linked to Dotify" do |file|
  File.exists?(Dotify::Config.path(file)).should == true
  File.readlink(Dotify::Config.home(file)).should == Dotify::Config.path(file)
end

Then "$file should not be linked to Dotify" do |file|
  File.exists?(Dotify::Config.path(file)).should == false
  puts `ll ~/.dotify`

end
Then /^\.(\S*) should exist in (home|dotify)$/ do |file, location|
  where = location == "home" ? :home : :path
  File.exists?(Dotify::Config.send(where, "." + file)).should == true
end
