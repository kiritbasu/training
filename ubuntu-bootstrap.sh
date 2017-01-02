## Setup a basic Ubuntu 16 box with stuff needed to run StreamSets Demo Environment

## Update your package manager.
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates

## Add the new GPG key.
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

sudo touch /etc/apt/sources.list.d/docker.list
sudo echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list

#for java7
sudo add-apt-repository ppa:webupd8team/java

#install redis from dotdeb
# /etc/apt/sources.list.d/dotdeb.org.list
echo deb http://packages.dotdeb.org squeeze all >> /etc/apt/sources.list.d/dotdeb.org.list
echo deb-src http://packages.dotdeb.org squeeze all >> /etc/apt/sources.list.d/dotdeb.org.list
wget -q -O - http://www.dotdeb.org/dotdeb.gpg | sudo apt-key add -
sudo apt-get update

## Install the recommended package.
sudo apt-get -y install linux-image-extra-$(uname -r)

## Update package manager.
sudo apt-get update

#install python necessities
sudo apt-get install -y python-pip libmysqlclient-dev python-dev

sudo pip install --upgrade pip

sudo apt-get -y install vim

# install redis
sudo apt-get -y install redis-server
sudo update-rc.d redis-server defaults
sudo /etc/init.d/redis-server start

#install redis python client
sudo pip install redis

#setup redis database
python init_redis_data.py

# set default mysql password
sudo apt-get install -y debconf-utils
echo mysql-server-5.5 mysql-server/root_password password password | sudo debconf-set-selections
echo mysql-server-5.5 mysql-server/root_password_again password password | sudo debconf-set-selections

echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections

#mysql server
sudo apt-get install -y mysql-server

# java
sudo apt-get install -y oracle-java8-installer

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

#install postgres
sudo apt-get install -y postgresql postgresql-contrib libpq-dev

sudo pip install psycopg2

#download postgres Drivers
wget https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar

#setup databases
./setup_rdbms.sh

#download kafka and start as daemon
wget http://apache.mirrors.tds.net/kafka/0.9.0.1/kafka_2.11-0.9.0.1.tgz
tar -xf kafka_2.11-0.9.0.1.tgz
rm kafka_2.11-0.9.0.1.tgz
mv kafka_2.11-0.9.0.1 /root/kafka

nohup /root/kafka/bin/zookeeper-server-start.sh /root/kafka/config/zookeeper.properties > /root/kafka/zookeeper.log 2>&1 &
sleep 10
nohup /root/kafka/bin/kafka-server-start.sh /root/kafka/config/server.properties > /root/kafka/kafka.log 2>&1 &
/root/kafka/bin/kafka-topics.sh --zookeeper localhost:2181 --create --topic mytopic --partitions 1 --replication-factor 1

#install maven
sudo apt-get install -y maven

#install elasticsearch
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.1.1.deb
sudo dpkg -i elasticsearch-5.1.1.deb
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch

#install kibana
wget https://artifacts.elastic.co/downloads/kibana/kibana-5.1.1-amd64.deb
sudo dpkg -i kibana-5.1.1-amd64.deb

#download and extract StreamSets
wget https://archives.streamsets.com/datacollector/2.2.0.0/tarball/streamsets-datacollector-all-2.2.0.0.tgz
tar xvzf streamsets-datacollector-all-2.2.0.0.tgz

#install jdbc drivers to sdc
./install_jdbc_drivers.sh

#download fake log generator
git clone https://github.com/kiritbasu/Fake-Apache-Log-Generator.git

#install docker
curl -sSL https://get.docker.com/ | sh

#install cdh
source /dev/stdin <<< "$(curl -sL http://tiny.cloudera.com/clusterdock.sh)"
clusterdock_run ./bin/start_cluster cdh
