from peewee import *
import csv


db = MySQLDatabase('streamsetsdemo', passwd='password', user='root')

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
    db.create_tables([ZipCode], safe=True)

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
