# Dotify

[![Build Status](https://secure.travis-ci.org/mattdbridges/dotify.png)](http://travis-ci.org/mattdbridges/dotify) [![Dependency Status](https://gemnasium.com/mattdbridges/dotify.png)](https://gemnasium.com/mattdbridges/dotify)

Dotify is a simple CLI tool to make managing dotfiles on your system easy. When developing on a Linux/Unix basic system, keeping track of all of those dotfiles in the home directory can be pain. Some developers do not even bother managing them and many have come up with their own static or even dynamic way of managing them. This is a need in the community to make managing these crazy files a breeze.

## Installation

Add this line to your application's Gemfile:

    gem 'dotify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dotify

## Usage

As dotify is a CLI tool, everything is done in the command line. Here are the current available methods for managing dotfiles.

### `dotify setup`

`dotify setup` will first create a `~/.dotify` directory in your home directory (yes, one more, but this is a good thing). It will then ask which files you want to copy from your home directory into your `.dotify` directory. 

**Note:** This will *not* link up the dotfiles. This command simply copies the files over for you without having to go searching for them manually.

### `dotify link`

This is the heart of the Dotify tool. This command will link all of the files within the `.dotify` directory into your home directory.

### `dotify unlink`

Don't want and of the dotfiles anymore? Sure. You can wipe them out.

Since this is a non-destructive task, you can simply run `dotify link` again if you want to restore your previous settings.

## Contributing

This tool is developed with much influence from *37singals*' fantastic idea of **Do Less**. This is meant to be a *simple* tool. I am more than happy to add small features, but I do not want this turning into an RVM.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
