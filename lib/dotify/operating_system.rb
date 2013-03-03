require 'rbconfig'

module Dotify
  class OperatingSystem
    def self.guess
       case host_os
       when /darwin/i        then :mac
       when /mswin|windows/i then :windows
       when /linux/i         then :linux
       when /sunos|solaris/i then :solaris
       else :unknown
       end
    end

    def self.host_os
      RbConfig::CONFIG['host_os']
    end
  end
end
