require_relative '../lib/dropbox-deployment.rb'
deployer = DropboxDeployment::Deployer.new
deployer.deploy
