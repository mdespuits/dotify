Dotify.configure do |d|
  #----------------------------
  # Limit to a platform
  #----------------------------
  # Sometimes you are running different platforms and need different configuration
  # per platform.
  # Options: :osx, :linux, :solaris, :windows (not supported)
  # d.platform :osx do |d|
  #   # ...
  # end

  #----------------------------
  # Link custom files to custom path
  #----------------------------
  # There are times where you may need a custom config file or directory
  # and point it to a custom configuration path. For example, you may want to
  # do something like this:
  #
  # d.include { '/Users/username/deeply/nested/directory' }
  # d.include { '/Users/username/path/to/file.ext' }

end
