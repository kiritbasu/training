# install JDBC drivers into SDC
cd /root/training/streamsets-datacollector-2.2.0.0
mkdir -p libs-common-lib/streamsets-datacollector-jdbc-lib/lib
cp ../mysql-connector-java-5.1.39-bin.jar libs-common-lib/streamsets-datacollector-jdbc-lib/lib
cp ../postgresql-9.4.1212.jar libs-common-lib/streamsets-datacollector-jdbc-lib/lib
echo "export STREAMSETS_LIBRARIES_EXTRA_DIR=libs-common-lib" >> libexec/sdc-env.sh
