# upload-to-dropbox
Deploy your CI artifacts to Dropbox

## Setup
Relies on https://github.com/Jesus/dropbox_api

You need to have an environment variable called `DROPBOX_OAUTH_BEARER`
You can create a OAUTH token here:
https://www.dropbox.com/developers/apps/create

## Limitations
Since we rely on the ruby Dropbox API client, we are limited to 150 MB. See more [here](http://jesus.github.io/dropbox_api/DropboxApi/Client.html#upload-instance_method)
