# install JDBC drivers into SDC
cd /root/training/streamsets-datacollector-1.5.1.0
mkdir -p libs-common-lib/streamsets-datacollector-jdbc-lib/lib
cp ../mysql-connector-java-5.1.39-bin.jar libs-common-lib/streamsets-datacollector-jdbc-lib/lib
echo "export STREAMSETS_LIBRARIES_EXTRA_DIR=libs-common-lib" >> libexec/sdc-env.sh
