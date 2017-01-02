#Setup a MySQL Database
mysql -uroot -ppassword -e 'CREATE DATABASE streamsetsdemo;'
python init_rdbms_data.py mysql

#setup a postgres DATABASE
sudo -u postgres createdb streamsetsdemo
sudo -u postgres psql -c "alter user postgres with encrypted password 'postgres' "
sudo -u postgres python init_rdbms_data.py postgres
