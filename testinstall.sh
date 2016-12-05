#Spot Check install

echo "Checking Java Version (prints java version 1.8.0_111 if success)"
echo "*****************"
java -version

echo ""
echo "*****************"
echo ""

echo "Checking if Redis-Server is running (prints PONG if success)"
echo "*****************"
echo "PING" | redis-cli

echo ""
echo "*****************"
echo ""

echo "Checking if Redis database is populated (prints 39297 keys if success)"
echo "*****************"
redis-cli --bigkeys

echo ""
echo "*****************"
echo ""

echo "Checking if Python is installed (prints Python 2.7.12 if success)"
echo "*****************"
python --version

echo ""
echo "*****************"
echo ""

echo "Checking if there's data in MySQL (prints count=42741)"
echo "*****************"
mysql -uroot -ppassword -Dstreamsetsdemo -e 'select count(*) from zipcode'

echo ""
echo "*****************"
echo ""

echo "Checking if kafka is installed and topic created (prints mytopic if success)"
echo "*****************"
/root/kafka/bin/kafka-topics.sh --list --zookeeper localhost:2181

echo ""
echo "*****************"
echo ""

echo "Checking if JDBC Driver is intalled in SDC (prints mysql-connector-java-5.1.39-bin.jar if success)"
echo "*****************"
ls  /root/training/streamsets-datacollector-2.2.0.0/libs-common-lib/streamsets-datacollector-jdbc-lib/lib

echo ""
echo "*****************"
echo ""

echo "Checking if Cloudera Docker instance is up (prints cloudera quickstart stats if success)"
echo "*****************"
docker ps

echo ""
echo "*****************"
echo ""

echo "Checking if Cloudera is up (prints json if success)"
echo "*****************"
curl -X GET -u "cloudera:cloudera" http://localhost:7180/api/v5/clusters
