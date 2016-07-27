import redis
import csv
import json

r = redis.Redis(host='localhost', port=6379)

with open('zip_tract.csv', 'rU') as csvfile:
    records = csv.DictReader(csvfile)
    for row in records:
        st = {}
        st['tract'] = row["tract"]
        st['res_ratio'] = row["res_ratio"]
        st['bus_ratio'] = row["bus_ratio"]
        st['oth_ratio'] = row["oth_ratio"]
        st['tot_ratio'] = row["tot_ratio"]
        r.set(row["zip"], json.dumps(st) )
