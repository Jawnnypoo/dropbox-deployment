require 'dropbox_api'
require 'openssl'
require 'yaml'
require 'logger'

# TODO fix some other way
# https://github.com/google/google-api-ruby-client/issues/235
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

logger = Logger.new(STDOUT)
logger.level = Logger::WARN

# Validation
config = YAML.load_file("upload-to-dropbox.yml")
testing = false
if !config["deploy"]
		puts "\nError in config file! Build file must contain a `deploy` object.\n\n"
		exit(1)
end
artifactPath = config["deploy"]["artifacts_path"]
dropboxPath = config["deploy"]["dropbox_path"]
# Just for testing...
if File.file?("testconfig")
  oauth = IO.read "testconfig"
  ENV["DROPBOX_OAUTH_BEARER"] = oauth
  testing = true
  logger.level = Logger::DEBUG
  logger.debug("We are in debug mode")
end

dropboxClient = DropboxApi::Client.new

# Upload all files
logger.debug("Artifact Path: " + artifactPath)
logger.debug("Dropbox Path: " + dropboxPath)
artifactFile = File.open(artifactPath)
artifactFile.inspect
content = IO.read(artifactFile)
dropboxClient.upload dropboxPath + "/" + File.basename(artifactFile), content
