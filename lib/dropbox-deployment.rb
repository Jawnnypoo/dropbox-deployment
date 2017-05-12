require 'dropbox_api'
require 'yaml'
require 'logger'
require 'find'
require 'pathname'
require 'dotenv'
Dotenv.load

module DropboxDeployment
  # Does the deployment to dropbox
  class Deployer

    def initialize
      @@logger = Logger.new(STDOUT)
      @@logger.level = Logger::WARN
    end

    def upload_file(dropbox_client, file, dropbox_path)
      file_name = File.basename(file)
      content = IO.read(file)
      @@logger.debug('Uploading ' + file_name + ' to ' + dropbox_path + '/' + file_name)
      dropbox_client.upload dropbox_path + '/' + file_name, content, mode: :overwrite
    end

    def upload_directory(dropbox_client, directory_path, dropbox_path)
      Find.find(directory_path) do |file|

        unless File.directory?(file)
          current_file_dir = File.dirname(file)
          if current_file_dir == directory_path
            modified_path = dropbox_path
          else
            # adjust for if we are a subdirectory within the desired saved build folder
            modified_path = dropbox_path + '/' + Pathname.new(current_file_dir).relative_path_from(Pathname.new(directory_path)).to_s
          end

          upload_file(dropbox_client, file, modified_path)
        end
      end
    end

    def deploy()
      # Validation
      unless File.file?('dropbox-deployment.yml')
        puts "\nNo config file found. You need a file called `dropbox-deployment.yml` with the configuration. See the README for details\n\n"
        exit(1)
      end
      config = YAML.load_file('dropbox-deployment.yml')
      testing = false
      unless config.has_key?('deploy')
        puts "\nError in config file! Build file must contain a `deploy` object.\n\n"
        exit(1)
      end
      artifact_path = config['deploy']['artifacts_path']
      dropbox_path = config['deploy']['dropbox_path']

      if ENV['DROPBOX_OAUTH_BEARER'].nil?
        puts "\nYou must have an environment variable of `DROPBOX_OAUTH_BEARER` in order to deploy to Dropbox\n\n"
        exit(1)
      end

      if config['deploy']['debug']
        @@logger.level = Logger::DEBUG
        @@logger.debug('We are in debug mode')
      end

      dropbox_client = DropboxApi::Client.new

      # Upload all files
      @@logger.debug('Artifact Path: ' + artifact_path)
      @@logger.debug('Dropbox Path: ' + dropbox_path)
      is_directory = File.directory?(artifact_path)
      @@logger.debug("Is directory: #{is_directory}")
      if is_directory
        upload_directory(dropbox_client, artifact_path, dropbox_path)
      else
        artifact_file = File.open(artifact_path)
        upload_file(dropbox_client, artifact_file, dropbox_path)
      end
      @@logger.debug('Uploading complete')
    end
  end
end
