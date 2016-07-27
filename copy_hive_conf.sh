mkdir -p /etc/hive/conf
sudo docker cp $(sudo docker ps|tail -n1|head -c12):/etc/hive/conf/core-site.xml /etc/hive/conf/
sudo docker cp $(sudo docker ps|tail -n1|head -c12):/etc/hive/conf/hdfs-site.xml /etc/hive/conf/
sudo docker cp $(sudo docker ps|tail -n1|head -c12):/etc/hive/conf/hive-site.xml /etc/hive/conf/
ls -l /etc/hive/conf
