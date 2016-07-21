sudo docker exec -i $(sudo docker ps|tail -n1|head -c12) /home/cloudera/cloudera-manager --express
sleep 120
python clouderamanager-bootstrap.py
