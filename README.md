[![Build Status](https://secure.travis-ci.org/mattdbridges/dotify.png)](http://travis-ci.org/mattdbridges/dotify)
[![Dependency Status](https://gemnasium.com/mattdbridges/dotify.png?travis)](https://gemnasium.com/mattdbridges/dotify)
[![Code Climate](https://codeclimate.com/github/mattdbridges/dotify.png)](https://codeclimate.com/github/mattdbridges/dotify)

# Dotify

### **This is the documentation for Dotify 1.0.0.**

Much of the functionality is similar to earlier versions of Dotify, but I am re-writing everything from the ground up to make things more robust. Very little of the command-line interface has been written for this version because I am approaching this as a ["Readme-Driven Development"](http://tom.preston-werner.com/2010/08/23/readme-driven-development.html) project.

Dotify is a simple CLI tool to make managing dotfiles and other file-based configuration on your computer easy. When developing on a Linux/Unix-based system, keeping track of all of those configuration files in the home directory (and everywhere else for that matter) can be pain. Some developers do not even bother managing them and many have come up with their own static or even dynamic way of managing them.

This gem attempts solves that problem.

## Installation

Run this command in the command line to install Dotify:

    $ gem install dotify

Then, to bootstrap your setup:

    $ dotify --init
    Creating "~/.dotify" directory and config file.

## Start managing those buggers!

In order for Dotify to initially manage your dotfiles, it boils down to the `install` method. This will create the necessary directory and optional configuration file for Dotify to manage your dotfiles in an interactive way.

## Micro manage your files

Say you start using Vim as your editor and you want Dotify to start managing the `.vimrc` file and the `.vim` directory. Simple. Just run the following command.

    $ dotify --manage .vimrc, .vim
    Dotify is now managing:
    * ~/.vim
    * ~/.vimrc

## Manage any file/directory

Sublime Text 2 does not use dotfiles for configuration. Dotify previously would not have been able to help you manage these configuration.

That is no longer the case.

As of version 1.0.0, you can now tell Dotify which configuration files/directories you want to manage. Here's how

Say (on OSX) you have your Sublime Text 2 User preferences located in `/Users/user/Library/Application Support/Sublime Text 2/Packages/User/Preferences.sublime-settings`. To manage this file, you can simply call

    $ dotify --link ~/Library/Application Support/Sublime Text 2/Packages/User/Preferences.sublime-settings
    Dotify is now managing 'Preferences.sublime-settings'

This is all well and good, but what if you also change the Defaults for a file with the same name? Dotify is based on the

    $ dotify merge ~/Library/Application Support/Sublime Text 2/Packages/User/Preferences.sublime-settings --file sublime/user.settings

There will now be a file `~/.dotify/sublime/user.settings` which `/Users/user/Library/Application Support/Sublime Text 2/Packages/User/Preferences.sublime-settings` is symlinked to.

This will

Cool! Now we can

## What files are you managing?

    $ dotify list

## Drop 'em if you don't want 'em

    $ dotify drop

    $ dotify unlink .bashrc

## Install from Github

Your computer died, huh? That's why you are using Dotify in the first place! It's easy to get Dotify up and running managing your files again.

If you use Github, just give Dotify your name and repo and you are good to go. (If you have submodules in your dotfiles, Dotify will automatically initialize and update them. Disable with `--no-submodules`).

    $ dotify github mattdbridges/dots

If you are not using Github for any reason, you can pass the full repository path into the `repo` command.

    $ dotify repo git://github.com/mattdbridges/dots.git

## Versioning

## Configuration

Dotify provides a simple and straightforward DSL for managing your configuration files. Here's a sample of what you can do:

```ruby
Dotify.setup do |d|

  d.platform :osx do |d|
    d.link "~/Library/Application Support/Sublime Text 2/Packages/User/Preferences.sublime-settings", to "sublime/user.preferences"
  end

  d.platform :linux do |d|
    # do something different on Linux systems
  end

  # This allows you to have files like `~/.dotify/vimrc` and `~/.dotify/zshrc` as your links
  d.link "~/.vimrc", to: "vimrc"
  d.link "~/.zshrc", to: "zshrc"
end
```

**Ignoring Files**

**Platform Differences**

## Not sure what to do?

    $ dotify --help

## Ruby Version Support

* 1.9.2
* 1.9.3
* 2.0.0

## Contributing

Contributions are welcome and encouraged. The contrubution process is the typical Github one.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](https://github.com/mattdbridges/dotify/pull/new/master)
