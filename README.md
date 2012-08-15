# Dotify

### **This is the documentation for Dotify 1.0.0.**

Much of the functionality is similar to earlier versions of Dotify, but I am re-writing everything from the ground up to make things more robust. Very little of the command-line interface has been written for this version because I am approaching this as a ["Readme-Driven Development"](http://tom.preston-werner.com/2010/08/23/readme-driven-development.html) project.

[![Build Status](https://secure.travis-ci.org/mattdbridges/dotify.png)](http://travis-ci.org/mattdbridges/dotify) [![Dependency Status](https://gemnasium.com/mattdbridges/dotify.png)](https://gemnasium.com/mattdbridges/dotify)

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/mattdbridges/dotify)

Dotify is a simple CLI tool to make managing dotfiles and other file-based configuration on your computer easy. When developing on a Linux/Unix-based system, keeping track of all of those configuration files in the home directory (and everywhere else for that matter) can be pain. Some developers do not even bother managing them and many have come up with their own static or even dynamic way of managing them.

This gem attempts solves that problem.

## Installation

Run this command in the command line to install Dotify:

    $ gem install dotify

## Installation

    $ dotify install

## Install from Github

    $ dotify github mattdbridges/dots

# Install from any remote repository

    $ dotify repo git://github.com/mattdbridges/dots.git

## Link single files

    $ dotify link .vimrc

## What files are you managing?

    $ dotify list

## Unlink the chains...

    $ dotify unlink

    $ dotify unlink .bashrc

## Versioning

## Configuration

The `.dotrc` file in `~/.dotify` serves as the configuration file for Dotify.

**Editor**

**Ignoring Files**

**Platform Differences**

## Not sure what to do?

    $ dotify help

## Ruby Version Support

As this is a gem for use on your local system, I know there are still many Ruby developers still stuck with using Ruby 1.8. As such, Dotify supports the following Ruby versions:

* 1.9.3
* 1.9.2
* 1.8.7

*Note*: As of v0.7.0, **JRuby** and **Rubinius** are now only partially supported. Trying to support all of these versions is quite difficult with the nature of this gem, so I will be focusing on MRI.

## Contributing

This tool is developed with much influence from *37singals*' fantastic idea of **Do Less**. This is meant to be a *simple* tool.

Contributions are welcome and encouraged. The contrubution process is the typical Github one.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](https://github.com/mattdbridges/dotify/pull/new/master)
