docker run -d --name registry -v ~/images:/tmp/registry -p 127.0.0.1:5000:5000 -e SETTINGS_FLAVOR=local registry:0.9.0
