Given /^a pointer within an builder with attributes\:$/ do |table|
  point = table.hashes.first
  @pointer = Dotify::Symlink.new(point["source"], point["destination"])
  @builder = Dotify::LinkBuilder.new(@pointer)
end

When /^I call "(.*)" on the builder/ do |action|
  @builder.send(action)
end

Then /^the (source|destination) should not exist/ do |what|
  File.exists?(@builder.send(what || "destination")).should be_false
end

Then /^the (source|destination) should exist/ do |what|
  File.exists?(@builder.send(what || "destination")).should be_true
end
