Dotify.configure do
  #----------------------------
  # Setup the Editor
  #----------------------------
  # This is the command used to edit the configuration files
  # via `dotify edit {filename}`
  #
  # editor 'vi -w'

  #----------------------------
  # Limit to a platform
  #----------------------------
  # Sometimes you are running different platforms and need different configuration
  # per platform.
  # Options: :osx, :linux, :solaris, :windows (not supported)
  # platform :osx do
  #   ...
  # end

  #----------------------------
  # Link custom files to custom path
  #----------------------------
  # There are times where you may need a custom config file and point
  # it to a custom configuration path. For example, you may want to
  # do something like this:
  #
  # '/Users/username/directory/configuration.file' => `~/.dotify/some/configuration`
  #
  # link '/Users/username/directory/configuration.file', :to => `~/.dotify/some/configuration`

end
