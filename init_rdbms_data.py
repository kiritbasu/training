from peewee import *
import csv
import sys

dbtype = sys.argv[1]

if dbtype == 'mysql':
    db = MySQLDatabase('streamsetsdemo', passwd='password', user='root')
elif dbtype == 'postgres':
    db = PostgresqlDatabase('streamsetsdemo', user='postgres')

class ZipCode(Model):
    class Meta:
        database = db
    zipcode=TextField()
    latitude=DoubleField(null=True)
    longitude=DoubleField(null=True)
    city=TextField()
    county=TextField()
    state=TextField()
if __name__=='__main__':
    print "Creating tables in " + dbtype
    db.create_tables([ZipCode], safe=True)

    print "Inserting Data into " + dbtype
    outarray=[]
    with open('zip_codes_states.csv', 'rU') as f:
        reader = csv.DictReader(f)
        for line in reader:
          line['zipcode'] = line.pop('zip_code')
          try:
            line['latitude'] = float(line['latitude'])
            line['longitude'] = float(line['longitude'])
          except Exception, e:
            line['latitude'] = None
            line['longitude']=None
          outarray.append(line)

    with db.atomic():
        ZipCode.insert_many(outarray).execute()
