require 'dropbox_api'
require 'openssl'

# TODO fix some other way
# https://github.com/google/google-api-ruby-client/issues/235
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
# Just for testing...
if File.file?("testconfig")
  oauth = IO.read "testconfig"
  ENV["DROPBOX_OAUTH_BEARER"] = oauth
end

dropboxClient = DropboxApi::Client.new

# Upload file
content = IO.read "test123.txt"
dropboxClient.upload "/Builds/test123.txt", content
