# ffmpeg-install-centos
FFMPEG installer for centos.

# Here is an alternative

To do so, start by getting the install script:

`wget https://raw.githubusercontent.com/q3aql/ffmpeg-install/master/ffmpeg-install`

Then make the file executable:

`chmod a+x ffmpeg-install`

Now install a release version:

`./ffmpeg-install --install release`

Now double check that it works:

`ffmpeg -version`
