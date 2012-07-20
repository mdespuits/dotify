require 'dotify/cli/utilities'
require 'thor/actions'
require 'git'

module Dotify
  module CLI
    class Github

      include Utilities
      extend Utilities

      def initialize(options = {})
        self.class.run_if_git_repo do
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
        end
      end

      def self.run_if_git_repo
        if File.exists? Config.path('.git')
          return yield
        end
        inform "You need to make ~/.dotify a Git repo to run this task."
      end

    end
  end
end
