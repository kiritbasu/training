# Get a handle to the API client
from cm_api.api_client import ApiResource

#TODO: create a proper dns entry and use that.
cm_host = "localhost"
api = ApiResource(cm_host, username="cloudera", password="cloudera")

# Get a list of all clusters
cdh5 = None
for c in api.get_all_clusters():
    print c.name
    if c.version == "CDH5":
        cdh5 = c

startuplist = ['zookeeper', 'hdfs', 'hive', 'impala', 'hue']

if cdh5 is not None:
    services = [s for s in cdh5.get_all_services()]
    for name in startuplist:
        for s in services:
            if s.name==name:
                print "Starting ", s.name
                cmd = s.start().wait()
                print "Success: %s" % (cmd.success)
