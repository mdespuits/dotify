require 'fileutils'

class Fake

  def self.paths
    path = File.dirname(File.dirname(__FILE__))
    fake_root = File.join(path, 'fake-root')
    dotify = File.join(fake_root, '.dotify')
    [fake_root, dotify]
  end

  def self.tearup
    fake_root, dotify = paths
    FileUtils.mkdir_p fake_root
    FileUtils.mkdir_p dotify
    FileUtils.touch File.join(dotify, '.vimrc')
    FileUtils.touch File.join(dotify, '.bashrc')
    FileUtils.touch File.join(dotify, '.zshrc')
    FileUtils.touch File.join(dotify, '.irbrc.erb')
    FileUtils.touch File.join(dotify, '.fake.erb')
  end

  def self.teardown
    fake_root, dotify = paths
    FileUtils.rm_rf fake_root
  end

  def self.root_path
    fake_root, dotify = paths
    fake_root
  end
  def self.dotify_path
    fake_root, dotify = paths
    dotify
  end
end
