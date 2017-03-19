#!/usr/bin/env ruby

require 'dropbox_api'
require 'yaml'
require 'logger'

logger = Logger.new(STDOUT)
logger.level = Logger::WARN

def uploadFile(dropboxClient, file, dropboxPath)
  fileName = File.basename(file)
  content = IO.read(file)
  dropboxClient.upload dropboxPath + "/" + fileName, content
end

def uploadDirectory(dropboxClient, directoryPath, dropboxPath)
  Dir.foreach(directoryPath) do |item|
  next if item == '.' or item == '..'
    # do work on real items
    uploadFile(dropboxClient, item, dropboxPath)
  end
end
# Validation
config = YAML.load_file("upload-to-dropbox.yml")
testing = false
if !config["deploy"]
		puts "\nError in config file! Build file must contain a `deploy` object.\n\n"
		exit(1)
end
artifactPath = config["deploy"]["artifacts_path"]
dropboxPath = config["deploy"]["dropbox_path"]

# Just for testing, load the local oauth token from the file
if File.file?("testconfig")
  oauth = IO.read "testconfig"
  ENV["DROPBOX_OAUTH_BEARER"] = oauth
  testing = true
end

if config["deploy"]["debug"]
  logger.level = Logger::DEBUG
  logger.debug("We are in debug mode")
end

dropboxClient = DropboxApi::Client.new

# Upload all files
logger.debug("Artifact Path: " + artifactPath)
logger.debug("Dropbox Path: " + dropboxPath)
isDirectory = File.directory?(artifactPath)
logger.debug("Is directory: " + "#{isDirectory}")
if isDirectory
  uploadDirectory(dropboxClient, artifactPath, dropboxPath)
else
  artifactFile = File.open(artifactPath)
  uploadFile(dropboxClient, artifactFile, dropboxPath)
end
