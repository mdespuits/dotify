Given /^a pointer within an actor with attributes\:$/ do |table|
  point = table.hashes.first
  @pointer = Dotify::Pointer.new(point["source"], point["destination"])
  @actor = Dotify::PointerActor.new(@pointer)
end

When /^I call "(.*)" on the actor/ do |action|
  @actor.send(action)
end

Then /^the (source|destination) should not exist/ do |what|
  File.exists?(@actor.send(what || "destination")).should be_false
end

Then /^the (source|destination) should exist/ do |what|
  File.exists?(@actor.send(what || "destination")).should be_true
end