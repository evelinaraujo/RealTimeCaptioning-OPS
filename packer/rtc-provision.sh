#!/bin/bash

echo "Provisions started"
sleep 30

echo "Updating the system"
sudo apt-get -y update

echo "Upgrading the system"
sudo apt-get -y upgrade

echo "Install git"
sudo apt-get install git

echo "Install curl"
sudo apt-get install curl

echo "Install Python2.7"
sudo apt-get install -y python

echo "Install nodejs"
cd ~
curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt-get install nodejs

echo "Install build essentials"
sudo apt-get install -y build-essential

echo "Check node version"
nodejs --version

echo "Install mongodb"

echo "Import the public key used by the package management system "
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10

echo "Create a list file for mongodb"
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list

echo "Reload local package database"
sudo apt-get update

echo "Clone the repo"
git clone https://github.com/CSUN-Comp490/RealTimeCaptioning.git

echo "checkout dev branch"
cd ~/RealTimeCaptioning
git checkout dev

echo "Install bower"
sudo npm install -g bower

echo "Install gulp"
sudo npm install -g gulp

echo "Install ng-cli"
sudo npm install -g ng-cli

echo "Install angular CLI"
npm install -g @angular/cli

echo "Run npm install"
npm install

### Left off right here when running on 172.16.1.111 #######

echo "Run npm install inside the backend directory"
cd backend
npm install
node indexjs

echo "Install version of mongodb"
sudo apt-get install -y mongodb-org
sudo apt-get install -y mongodb 

echo "create /data/db directory"

sudo mkdir /data
cd /data
sudo mkdir db
sudo chown -R `id -un` /data/db
cd ~


echo "Start mongodb"
cd /data && sudo mongod


#  environment variables for the project
# database-example












