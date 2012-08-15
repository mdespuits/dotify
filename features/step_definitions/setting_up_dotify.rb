Given /^Dotify is not setup$/ do
  %x[rm -rf #{Dotify::Configure.path}]
end

Given /^Dotify is setup$/i do
  %x[
    mkdir -p #{Dotify::Configure.dir}
    touch #{Dotify::Configure.path(".dotrc")}
  ]
end
