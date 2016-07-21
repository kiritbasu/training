sudo docker exec -it $(sudo docker ps|tail -n1|head -c12) /home/cloudera/cloudera-manager --express
python clouderamanager-bootstrap.py
