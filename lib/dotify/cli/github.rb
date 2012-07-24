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
          repo = ::Git.open(Dotify::Config.path)
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
        run_if_not_installed do
          puller = Puller.new(repo, Config.path, options)
          puller.clone
          Dot.new(".dotrc").backup_and_link # Link the new .dotrc file before trying to link the new files
          Collection.new(:dotify).each { |file| file.backup_and_link }
          puller.initialize_submodules_in(Config.path(".gitmodules"))
          puller.finish
        end
      rescue Git::GitExecuteError => e
        caution "[ERROR]: There was an problem pulling from #{git_repo_name}.\nPlease make sure that the specified repo exists and you have access to it." 
        caution "Git Error: #{e.message}" if options[:debug]
      end

      class Puller
        attr_reader :repo, :path, :options

        include Utilities

        def initialize(repo, path, options = {})
          @repo, @path, @options = repo, path, options
          inform "Backing up dotfile and installing Dotify files..."
        end

        def clone
          inform "Pulling #{repo} from Github into #{path}..."
          @repo = Git.clone(url, path)
          self
        end

        def inform(message)
          super(message) if options[:verbose]
        end

        def finish
          inform "Dotify successfully installed #{repo} from Github!"
        end

        def url
          "git#{github_url}#{repo}.git"
        end

        def initialize_submodules_in(modules_path)
          if File.exists? modules_path
            inform "Initializing and updating submodules in Dotify now..."
            system "cd #{path} && git submodule init &> /dev/null && git submodule update &> /dev/null"
          end
          self
        end

        def github_url
          use_ssh_repo? ? '@github.com:' : '://github.com/'
        end

        def use_ssh_repo?
          options.fetch(:ssh, false) == true
        end

      end

      def self.run_if_git_repo
        return yield if File.exists? Config.path('.git')
        inform "You need to make ~/.dotify a Git repo to run this task."
      end

    end
  end
end
