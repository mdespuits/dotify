Given /^Dotify is not setup$/ do
  %x[rm -rf #{Dotify::Path.dotify}]
end

Given /^Dotify is setup$/i do
  %x[
    mkdir -p #{Dotify::Path.dotify}
    touch #{Dotify::Path.home_path(".dotrc")}
  ]
end
