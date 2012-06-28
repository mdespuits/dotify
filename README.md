# Dotify

[![Build Status](https://secure.travis-ci.org/mattdbridges/dotify.png)](http://travis-ci.org/mattdbridges/dotify) [![Dependency Status](https://gemnasium.com/mattdbridges/dotify.png)](https://gemnasium.com/mattdbridges/dotify)

Dotify is a simple CLI tool to make managing dotfiles on your system easy. When developing on a Linux/Unix basic system, keeping track of all of those dotfiles in the home directory can be pain. Some developers do not even bother managing them and many have come up with their own static or even dynamic way of managing them. This is a need in the community, and this tool makes managing these crazy files a breeze.

## Ruby Version Support

As this is a gem for use on your local system, I understand there are still many Ruby developers still stuck with using Ruby 1.8. As such, Dotify supports the following Ruby versions definitively:

* 1.8.7
* 1.9.2
* 1.9.3
* JRuby
* Rubinius

## Installation

Add this line to your application's Gemfile:

    gem 'dotify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dotify

## Usage

As dotify is a CLI tool, everything is done in the command line. Here are the current available methods for managing dotfiles.

### Preparing your system for Dotify

To setup Dotify, you must first run `dotify setup` in your terminal.

    $ dotify setup
        create /Users/computer-user/.dotify
        create /Users/computer-user/.dotrc

This will first create a `.dotify` directory in your home directory as well as a `.dotrc` file for Dotify configuration (yes, it is more dotfiles, but this is a good thing!).

In order to install files from the home directory into Dotify, you must run the `install` task.

### The .dotrc file

The `.dotrc` file in your home directory serves as the configuration file for Dotify.

#### Ignoring files

When you are linking files in your Dotify directory, some files you do not want ever want to link (`.git`, `.gitmodules`, `.gitignore`, .etc) because they are used specifically for that directory (such as git versioning). You can configure Dotify to ignore these files when calling `dotify link` in the `.dotrc` in this way:

    $ cat ~/.dotrc
    ignore:
      dotify:
      - '.git'
      - '.gitmodules'
      - '.gitignore'

The same can be done for the home directory when running `dotify setup`. There are some directories that you should not move around (`.dropbox`, `.rbenv`, `.rvm`) and do not want to accidentally attempt to move. You can do that in your `.dotrc` file as well:

    $ cat ~/.dotrc
    ignore:
      dotfiles:
      - '.dropbox'
      - '.rbenv'
      - '.rvm'

More configuration options will likely be added in future versions, so be sure to check up here for your options.

### Install Dotify

Now that you have configured Dotify to your liking, you should now run `dotify install`.

    $ dotify install
    Do you want to add .bash_history to Dotify? [Yn] n
    Do you want to add .bashrc to Dotify? [Yn] y
        create /Users/mattbridges/.dotify/.bashrc
    Do you want to add .railsrc to Dotify? [Yn] n
        create /Users/mattbridges/.dotify/.railsrc
    Do you want to add .zshrc to Dotify? [Yn] n
        create /Users/mattbridges/.dotify/.zshrc
    ...

### Add single files

After you have setup Dotify, you can add files one by one if you did not add them during setup

    $ dotify add .vimrc
          create  /Users/mattbridges/.vimrc

### Remove single files

If you don't want a particular dotfile anymore? You can just remove it.

***This actually removes the file from the home directory. Do this at your own risk***.

    $ dotify remove .vimrc
          remove  /Users/mattbridges/.vimrc

If you do this and decide to change your mind, the file is still located in the `~/.dotify` directory. You can re-link it by running `dotify link` again.

### Link up your files

This is the heart of the Dotify tool. This command will link the files within the `~/.dotify` directory into your home directory.

    $ dotify link
    Do you want to link ~/.bashrc? [Yn] Y
       create     /Users/computer-user/.bashrc
    Do you want to link ~/.gemrc? [Yn] Y
       identical  /Users/computer-user/.gemrc
    Do you want to link ~/.gitconfig? [Yn] Y
       create     /Users/computer-user/.gitconfig
    Do you want to link ~/.gitignore? [Yn] Y
    ...

You can also link files one-by-one by passing the filename to the `link` task.

    $ dotify link .bashrc
    Do you want to link ~/.bashrc? [Yn] Y
       create /Users/computer-user/.bashrc

### Unlink everything

Don't want any of the dotfiles anymore? Well, I'm not one to question. Go ahead and wipe them out.

    $ dotify unlink
    Are you sure you want to remove ~/.bashrc? [Yn] Y
       remove  /Users/computer-user/.bashrc
    Are you sure you want to remove ~/.gemrc? [Yn] Y
       remove  /Users/computer-user/.gemrc
    Are you sure you want to remove ~/.gitconfig? [Yn] n
    ...

Should you run this horrid task accidentally, you can simply run `dotify link` again if you want to restore your previous settings.

By default, `unlink` loops through all of the Dotify files. You can also pass a filename to `unlink` to unlink a single file.

    $ dotify unlink .bashrc
    Are you sure you want to remove ~/.bashrc? [Yn] Y
       remove /Users/mattbridges/.bashrc

## Confused?

Dotify can manages dotfiles from two different directions:

1. `add` and `remove` both look in the user's home directory for dotfiles to manage
2. `link` and `unlink` both look in the Dotify directory for dotfiles to manage.

In other words, when the user has dotfiles in the home directory that he/she wants Dotify to manage, they would use `dotify add [FILENAME]` (or even `setup`) to instruct Dotify to manage those files.

On the other hand, if he/she has files that they have instructed Dotify to manage but have removed them from the home directory, they would use `link` and `unlink` to re-link them into the home directory.

## Not sure what to do?

This tool is powered by the amazing library, [Thor](http://whatisthor.com/). You can use the `help` task like so:

    $ dotify help
    Tasks:
      dotify add [FILENAME]     # Add a single dotfile to the Dotify directory
      dotify help [TASK]        # Describe available tasks or one specific task
      dotify link               # Link up all of your dotfiles
      dotify remove [FILENAME]  # Remove a single dotfile from Dotify
      dotify setup              # Setup your system for Dotify to manage your dotfiles
      dotify unlink             # Unlink all of your dotfiles

And if you want a little clarity on one of the command you can run `dotify help [TASK]` to find out what other options you have in the other tasks.

## Contributing

This tool is developed with much influence from *37singals*' fantastic idea of **Do Less**. This is meant to be a *simple* tool.

Contributions are welcome and encouraged. The contrubution process is the typical Github one.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](https://github.com/mattdbridges/dotify/pull/new/master)
