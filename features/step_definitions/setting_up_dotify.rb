Given /^Dotify is not setup$/ do
  %x[rm -rf #{Dotify::Config.path}]
end

Given /^Dotify is setup$/i do
  %x[
    mkdir -p #{Dotify::Config.path}
    touch #{Dotify::Config.path(".dotrc")}
  ]
end
