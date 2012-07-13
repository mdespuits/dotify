# Dotify

[![Build Status](https://secure.travis-ci.org/mattdbridges/dotify.png)](http://travis-ci.org/mattdbridges/dotify) [![Dependency Status](https://gemnasium.com/mattdbridges/dotify.png)](https://gemnasium.com/mattdbridges/dotify)

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/mattdbridges/dotify)

Dotify is a simple CLI tool to make managing dotfiles on your system easy. When developing on a Linux/Unix-based system, keeping track of all of those dotfiles in the home directory can be pain. Some developers do not even bother managing them and many have come up with their own static or even dynamic way of managing them. This is a need in the community, and this tool makes managing these crazy files a breeze.

## Ruby Version Support

As this is a gem for use on your local system, I know there are still many Ruby developers still stuck with using Ruby 1.8. As such, Dotify supports the following Ruby versions definitively:

* 1.8.7
* 1.9.2
* 1.9.3
* JRuby
* Rubinius

## Installation

Run this command in the command line to install Dotify:

    $ gem install dotify

## Installation

To install Dotify, you must first run `dotify install` in your terminal.

    $ dotify install
        create /Users/computer-user/.dotify
        create /Users/computer-user/.dotrc
    Editing config file...
    Do you want to link .bashrc to the home directory? [Yn] n
        linked  /Users/computer-user/.bashrc
    Do you want to link .dotrc to the home directory? [Yn] n
        linked  /Users/computer-user/.dotrc
    Do you want to add .railsrc to Dotify? [Yn] n
        linked  /Users/computer-user/.railsrc
    Do you want to add .zshrc to Dotify? [Yn] n
        linked  /Users/computer-user/.zshrc
    ...

This will first create a `.dotify` directory in your home directory as well as a `.dotrc` file for Dotify configuration (yes, it is more dotfiles, but this is a good thing!).

During the installation process, a Vim instance will open with a sample `.dotrc` file for you to edit and configure if you desire. This will allow your configuration to be used prior to Dotify's full installation. See more about the `.dotrc` file in the [Configuration](https://github.com/mattdbridges/dotify/tree/cli-rewrite#configuration) section.

Alternatively, you could run `dotify setup` to setup Dotify's configuration, followed by `dotify install` to add the initial files into Dotify.

## Link single files

After you have setup Dotify, you can add files one by one if you did not add them during setup.

    $ dotify link .vimrc
        linked  /Users/computer-user/.vimrc

## Unlink the chains...

Don't want any of the dotfiles anymore? Or want to drop one? Well, I'm not one to question. Go ahead and move them back into the home directory.

    $ dotify unlink
    Do you want to unlink .bash_profile from the home directory? [Yn] Y
        unlinked  /Users/computer-user/.bash_profile
    Do you want to unlink .dotrc from the home directory? [Yn] Y
        unlinked  /Users/computer-user/.dotrc
    Do you want to unlink .gemrc from the home directory? [Yn]
    ...

Should you run this task and decide to change your mind, you can simply run `dotify link` or `dotify link [FILE]` again if you want to restore your changes.

By default, `unlink` loops through all of the Dotify files. You can also pass a filename to `unlink` to unlink a single file.

    $ dotify unlink .bashrc
    Are you sure you want to remove ~/.bashrc? [Yn] Y
        unlinked  /Users/computer-user/.bashrc

## Versioning

The whole purpose of this gem was to manage the dotfiles on your system. What better way to do this than under version control using [Git](http://git-scm.com/) and [Github](https://github.com)?

* To version your Dotify installation, simple make `.dotify` a Git repository. If you don't know how to do that, I recommend you start reading [here](http://git-scm.com/book/en/Getting-Started).
* Add your remote repository via `git remote add [NAME] [REPO]`.

*From this point, you can manage your dotfiles entirely from Dotify.*

* To edit a dotfile managed by Dotify, simple run `dotify edit [DOTFILE]` and replace **[DOTFILE]** with the name of the file you want to edit. This will open a Vim instance containing that file for editing.
* Once you have saved your edits, simple run `dotify save` and Dotify will walk you through the steps of committing your changes and pushing them up to Github.

## Configuration

The `.dotrc` file in your home directory serves as the configuration file for Dotify. It is a [YAML](http://www.yaml.org/) formatted file.

### Dotify Editor

When you run `dotify edit [DOTFILE]`, by default the file opens in Vim for editing. You can change this by adding this following to your `.dotrc` file.

    editor: 'vi'
    # or 'vim' or 'emacs' etc...

Vim and Emacs are the only two editors that have been successfully used with this configuration option, but if you find another, please [let me know](https://github.com/mattdbridges/dotify/issues/new) and I will update the documentation.

### Ignoring files

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

## Not sure what to do?

This tool is powered by the amazing library, [Thor](http://whatisthor.com/). You can use the `help` task like so:

    $ dotify help
    Tasks:
      dotify edit [FILE]          # Edit a dotify file
      dotify help [TASK]          # Describe available tasks or one specific task
      dotify install              # Install files from your home directory into Dotify
      dotify link [[FILENAME]]    # Link up one or all of your dotfiles (FILENAME is optional)
      dotify save                 # Save Dotify files and push to Github.
      dotify setup                # Setup your system for Dotify to manage your dotfiles
      dotify unlink [[FILENAME]]  # Unlink one or all of your dotfiles (FILENAME is optional)
      dotify version              # Check your Dotify version

## Contributing

This tool is developed with much influence from *37singals*' fantastic idea of **Do Less**. This is meant to be a *simple* tool.

Contributions are welcome and encouraged. The contrubution process is the typical Github one.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](https://github.com/mattdbridges/dotify/pull/new/master)
