#!/bin/bash

#Get Server URL, Username and Password from user
if ! env | grep ^REGISTRYHOST= > /dev/null; then
  echo -n "Enter your server's URL (ex: hub.domain.com): "
  read REGISTRYHOST
  echo -n "Choose a username to access the registry: "
  read REGISTRYUSER
  echo -n "Choose a password: "
  read REGISTRYPASSWORD
fi

#Check for Git
if [[ ! command -v git ]]; then
  if [ command -v apt-get ]; then
    apt-get install git
  else
    echo "Please install Git."
  fi
fi

#Get Docker Registry
git clone https://github.com/docker/docker-registry.git && cd docker-registry
git checkout 0.9.0 && cd ..

#Build Docker Registry container
docker build -t registry /docker-registry/.

#Run Docker Registry container
./start/start-registry.sh

#Modify NGINX configuration and certificate configuration
sed -i "s/localhost/$REGISTRYHOST/g" ./nginx/config/docker-registry.conf
sed -i "s/localhost/$REGISTRYHOST/g" ./nginx/certs/certificate-config

#Generate Password
htpasswd -bc /nginx/config/docker-registry.htpasswd $REGISTRYUSER $REGISTRYPASSWORD

#Generate SSL certificates
#Generate Root key and certificate
cd ./nginx/certs/
openssl genrsa -out registryrootCA.key 2048
openssl req -x509 -new -nodes -key registryrootCA.key -days 10000 -out registryrootCA.crt -config certificate-config
#Generat Server key
openssl genrsa -out private-registry.key 2048
#Create Signing Request
openssl req -new -key private-registry.key -out private-registry.csr -config certificate-config
#Sign
openssl x509 -req -in private-registry.csr -CA registryrootCA.crt -CAkey registryrootCA.key -CAcreateserial -out private-registry.crt -days 10000
#Add new root certificate to this server
mkdir /usr/local/share/ca-certificates/registry-root-cert
cp registryrootCA.crt /usr/local/share/ca-certificates/registry-root-cert
update-ca-certificates
cd ../../

#Build NGINX container
docker build -t nginx /nginx/.

#Run NGINX container
./start/start-nginx.sh
