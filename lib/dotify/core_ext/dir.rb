class Dir
  def self.[](*args)
    self.glob(*args).reject{|f| %w[. ..].include? File.basename(f) }
  end
end