require 'dotify/cli/utilities'
require 'thor/actions'
require 'git'

module Dotify
  module CLI
    class Github

      include Utilities

      attr_reader :options

      def initialize(options = {})
        @options = options
      end

      def save
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

      def pull(repo)
        return inform "Dotify has already been setup." if Dotify.installed?
        git_repo_name = "git@github.com:#{repo}.git"
        inform "Pulling #{repo} from Github into #{Config.path}..."
        Git.clone(git_repo_name, Config.path)
        inform "Backing up dotfile and installing Dotify files..."
        Collection.new(:dotify).each { |file| file.backup_and_link }
        if File.exists? File.join(Config.path, ".gitmodules")
          inform "Initializing and updating submodules in Dotify now..."
          system "cd #{Config.path} && git submodule init &> /dev/null && git submodule update &> /dev/null"
        end
        inform "Dotify successfully installed #{repo} from Github!"
      rescue Git::GitExecuteError => e
        say "[ERROR]: There was an problem pulling from #{git_repo_name}.\nPlease make sure that the specified repo exists and you have access to it.", :red
        say "Git Error: #{e.message}", :red if options[:debug]
      end

      def self.run_if_git_repo
        return yield if File.exists? Config.path('.git')
        inform "You need to make ~/.dotify a Git repo to run this task."
      end

    end
  end
end
