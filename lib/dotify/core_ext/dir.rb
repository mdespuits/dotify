# Override the Dir.[] method for Collection's use
class Dir
  # Drop all . and .. directories
  def self.[](*args)
    self.glob(*args).reject{|f| %w[. ..].include? File.basename(f) }
  end
end