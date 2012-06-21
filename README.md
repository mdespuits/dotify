# Dotify

[![Build Status](https://secure.travis-ci.org/mattdbridges/dotify.png)](http://travis-ci.org/mattdbridges/dotify) [![Dependency Status](https://gemnasium.com/mattdbridges/dotify.png)](https://gemnasium.com/mattdbridges/dotify)

Dotify is a simple CLI tool to make managing dotfiles on your system easy and configurable.

## Installation

Add this line to your application's Gemfile:

    gem 'dotify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dotify

## Usage

Right now, this tool is still under heavy development and brainstorming. For now, here is the output given by running `dotify help`:

    Tasks:
      dotify backup       # Backup your dotfiles for quick recovery if something goes wrong
      dotify help [TASK]  # Describe available tasks or one specific task
      dotify link         # Link up your dotfiles
      dotify restore      # Restore your backed-up dotfiles
      dotify setup        # Get your system setup for dotfile management
      dotify unlink       # Unlink all of your dotfiles

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
