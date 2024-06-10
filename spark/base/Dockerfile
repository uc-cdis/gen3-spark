# To check running container: docker exec -it tube /bin/bash
FROM quay.io/cdis/hadoop-base:v3.3.0

ENV DEBIAN_FRONTEND=noninteractive \
    HADOOP_SPARK_VERSION="3" \
    ES_HADOOP_VERSION="8.3.3" \
    SPARK_VERSION="3.3.0"

ENV SPARK_INSTALLATION_URL="http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_SPARK_VERSION}.tgz" \
    SPARK_HOME="/spark" \
    HADOOP_HOME="/hadoop" \
    JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64/"

RUN mkdir -p /usr/share/man/man1

RUN wget $SPARK_INSTALLATION_URL \
    && mkdir -p $SPARK_HOME \
    && tar -xvf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_SPARK_VERSION}.tgz -C $SPARK_HOME --strip-components 1 \
    && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_SPARK_VERSION}.tgz

RUN apt-get --only-upgrade install libpq-dev

RUN mkdir -p /var/run/sshd ${HADOOP_HOME}/hdfs ${HADOOP_HOME}/hdfs/data ${HADOOP_HOME}/hdfs/data/dfs ${HADOOP_HOME}/hdfs/data/dfs/namenode ${HADOOP_HOME}/logs

ENV PYTHONHASHSEED 1
