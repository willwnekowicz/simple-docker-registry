One Click Docker Registry
=====================

OK, so one click might be an exaggeration, but the goal of this project is to create a ridiculously easy setup script for a private docker registry server with authentication through NGINX using SSL.

The script will setup two containers:

1. [docker-registry v0.9.0](https://registry.hub.docker.com/_/registry/)  
  Configured for local storage and persisted by using a volume.
2. [NGINX](https://registry.hub.docker.com/_/nginx/)  
  Configured with SSL certs and linked to the docker-registry container

Dependencies: You'll need Git and Docker already installed on your server.  
Need a server? I recommend [Digital Ocean](https://www.digitalocean.com/?refcode=f19a6a1ccdc8).

##Server Install Instructions

The one liner:
`git clone https://github.com/flysonic10/one-click-docker-registry.git && cd one-click-docker-registry && ./build.sh`

##Client Install Instructions

Because the server will be using a self-signed certificate, you'll need to set this certificate as 'trusted' on any client machine you will use to access the registry. First, you'll need to retrieve the certificate that your server created, then copy it to the trusted certificates of the client machine.

####Retrieve Certificate
1. On your server: `cat one-click-docker-registry/nginx/certs/registryrootCA.crt`
2. Copy all the output including the BEGIN CERTIFICATE and END CERTIFICATE lines

--------

####OSX through Boot2Docker
1. SSH into your boot2docker virtual machine:  
  `boot2docker ssh`  
2. Append certificate to ca-certificates.crt:  
  - `sudo vi /etc/ssl/certs/ca-certificates.crt`
  - `G` `a` `ENTER` `ctrl-v` `:x` `ENTER`
3. Restart Docker:  
  `sudo /etc/init.d/docker restart`
4. Exit the VM:  
  `exit`



####Linux
1. `mkdir /usr/local/share/ca-certificates/registry-root-cert`
2. `cp registryrootCA.crt /usr/local/share/ca-certificates/registry-root-cert`
3. `update-ca-certificates`

##Usage

- `docker login https://your-server-url.com`

- `docker tag whaever-image your-server-url.com/whatever-image`

- `docker push your-server-url.com/test-image`



That's all folks.
