require 'dotify/cli/utilities'
require 'thor/actions'

module Dotify
  module CLI
    class Github

      include Utilities

      def initialize(options = {})
        if File.exists? Config.path('.git') # if the Dotify directory has been made a git repo
          repo = ::Git.open(Config.path)
          changed = repo.status.changed
          if changed.size > 0
            changed.each_pair do |file, status|
              say_status :changed, status.path, :verbose => options[:verbose]
              if options[:force] || yes?("Do you want to add '#{status.path}' to the Git index? [Yn]", :blue)
                repo.add status.path
                say_status :added, status.path, :verbose => options[:verbose]
              end
            end
            message = !options[:message].nil? ? options[:message] : ask("Commit message:", :blue)
            say message, :yellow, :verbose => options[:verbose]
            repo.commit(message)
          else
            inform "No files have been changed in Dotify."
          end
          if options[:push] || yes?("Would you like to push these changed to Github? [Yn]", :blue)
            inform 'Pushing up to Github...'
            begin
              repo.push
            rescue Exception => e
              say "There was a problem pushing to your remote repo.", :red
              say("Git Error: #{e.message}", :red) if options[:debug]
              return
            end
            inform "Successfully pushed!"
          end
        else
          inform 'Dotify has nothing to save.'
        end
      end

    end
  end
end
