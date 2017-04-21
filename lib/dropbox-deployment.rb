require 'dropbox_api'
require 'yaml'
require 'logger'
require 'find'
require 'dotenv'
Dotenv.load

module DropboxDeployment
  class Deployer

    def initialize
      @@logger = Logger.new(STDOUT)
      @@logger.level = Logger::WARN
    end

    def uploadFile(dropboxClient, file, dropboxPath)
      fileName = File.basename(file)
      content = IO.read(file)
      dropboxClient.upload dropboxPath + "/" + fileName, content, :mode => :overwrite
    end

    def uploadDirectory(dropboxClient, directoryPath, dropboxPath)
      Find.find(directoryPath) do |file|
        # TODO need to have the path of the parent as part of the dropbox path
        # so that we keep the hierarchy we want
        if !File.directory?(file)
          uploadFile(dropboxClient, file, dropboxPath)
        end
      end
    end

    def deploy()
      # Validation
      if !File.file?("dropbox-deployment.yml")
        puts "\nNo config file found. You need a file called `dropbox-deployment.yml` with the configuration. See the README for details\n\n"
        exit(1)
      end
      config = YAML.load_file("dropbox-deployment.yml")
      testing = false
      if !config.has_key?("deploy")
      		puts "\nError in config file! Build file must contain a `deploy` object.\n\n"
      		exit(1)
      end
      artifactPath = config["deploy"]["artifacts_path"]
      dropboxPath = config["deploy"]["dropbox_path"]

      if ENV["DROPBOX_OAUTH_BEARER"].nil?
        puts "\nYou must have an environment variable of `DROPBOX_OAUTH_BEARER` in order to deploy to Dropbox\n\n"
        exit(1)
      end

      if config["deploy"]["debug"]
        @@logger.level = Logger::DEBUG
        @@logger.debug("We are in debug mode")
      end

      dropboxClient = DropboxApi::Client.new

      # Upload all files
      @@logger.debug("Artifact Path: " + artifactPath)
      @@logger.debug("Dropbox Path: " + dropboxPath)
      isDirectory = File.directory?(artifactPath)
      @@logger.debug("Is directory: " + "#{isDirectory}")
      if isDirectory
        uploadDirectory(dropboxClient, artifactPath, dropboxPath)
      else
        artifactFile = File.open(artifactPath)
        uploadFile(dropboxClient, artifactFile, dropboxPath)
      end
      @@logger.debug("Uploading complete")
    end
  end
end
