## Setup a basic Ubuntu 14.04 box with stuff needed to run StreamSets Demo Environment

## Update your package manager.
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates

## Add the new GPG key.
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

sudo touch /etc/apt/sources.list.d/docker.list
sudo echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list

sudo add-apt-repository ppa:webupd8team/java

## Update your package manager.
sudo apt-get update

## Install the recommended package.
sudo apt-get -y install linux-image-extra-$(uname -r)

## Update your package manager.
sudo apt-get update

sudo apt-get -y install vim

#install docker
curl -sSL https://get.docker.com/ | sh

#install python necessities
sudo apt-get install -y python-pip libmysqlclient-dev python-dev

#mysql server
sudo apt-get install -y mysql-server

# java
sudo apt-get install -y oracle-java7-installer

# zookeeper daemon
sudo apt-get install -y zookeeperd

#docker-compose
sudo pip install docker-compose

#cloudera manager api
sudo pip install cm-api

#install AWS client
sudo pip install awscli

#python mysql
sudo pip install mysql-python

#client to simplyify mysql operations
sudo pip install peewee

#download MySQL Drivers
wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.39.tar.gz
tar xvzf mysql-connector-java-5.1.39.tar.gz
cp mysql-connector-java-5.1.39/mysql-connector-java-5.1.39-bin.jar .
rm -rf mysql-connector-java-5.1.39 mysql-connector-java-5.1.39.tar.gz

#download kafka and start as daemon
wget http://apache.mirrors.tds.net/kafka/0.9.0.1/kafka_2.11-0.9.0.1.tgz
tar -xf kafka_2.11-0.9.0.1.tgz
rm kafka_2.11-0.9.0.1.tgz
mv kafka_2.11-0.9.0.1 kafka
nohup ~/kafka/bin/kafka-server-start.sh ~/kafka/config/server.properties > kafka.log 2>&1 &

#start up docker compose in background
sudo docker-compose up -d
