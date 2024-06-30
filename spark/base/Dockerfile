# To check running container: docker exec -it tube /bin/bash
FROM quay.io/cdis/hadoop-base:v3.3.0

ENV DEBIAN_FRONTEND=noninteractive \
    HADOOP_SPARK_VERSION="3" \
    ES_HADOOP_VERSION="8.3.3" \
    SQOOP_VERSION="1.4.7" \
    SPARK_VERSION="3.3.0" \
    MAVEN_ES_URL="https://search.maven.org/remotecontent?filepath=org/elasticsearch" \
    ES_SPARK_30_2_12="elasticsearch-spark-30_2.12" \
    ES_SPARK_20_2_11="elasticsearch-spark-20_2.11"

ENV MAVEN_ES_SPARK_VERSION="${MAVEN_ES_URL}/${ES_SPARK_30_2_12}/${ES_HADOOP_VERSION}/${ES_SPARK_30_2_12}-${ES_HADOOP_VERSION}"

ENV SPARK_INSTALLATION_URL="http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_SPARK_VERSION}.tgz" \
    SQOOP_INSTALLATION_URL="http://archive.apache.org/dist/sqoop/${SQOOP_VERSION}/sqoop-${SQOOP_VERSION}.bin__hadoop-2.6.0.tar.gz" \
    HADOOP_INSTALLATION_URL="http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" \
    ES_HADOOP_INSTALLATION_URL="https://artifacts.elastic.co/downloads/elasticsearch-hadoop/elasticsearch-hadoop-${ES_HADOOP_VERSION}.zip" \
    SPARK_HOME="/spark" \
    SQOOP_HOME="/sqoop" \
    HADOOP_HOME="/hadoop" \
    ES_HADOOP_HOME="/es-hadoop" \
    JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64/"
ENV ES_HADOOP_HOME_VERSION="${ES_HADOOP_HOME}/elasticsearch-hadoop-${ES_HADOOP_VERSION}"

RUN mkdir -p /usr/share/man/man1
RUN mkdir -p $SQOOP_HOME

RUN wget $SPARK_INSTALLATION_URL \
    && mkdir -p $SPARK_HOME \
    && tar -xvf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_SPARK_VERSION}.tgz -C $SPARK_HOME --strip-components 1 \
    && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_SPARK_VERSION}.tgz

RUN mkdir -p $SPARK_HOME/apps

RUN apt-get --only-upgrade install libpq-dev

RUN mkdir -p /var/run/sshd ${HADOOP_HOME}/hdfs ${HADOOP_HOME}/hdfs/data ${HADOOP_HOME}/hdfs/data/dfs ${HADOOP_HOME}/hdfs/data/dfs/namenode ${HADOOP_HOME}/logs

RUN wget ${ES_HADOOP_INSTALLATION_URL} \
    && mkdir -p $ES_HADOOP_HOME \
    && unzip elasticsearch-hadoop-${ES_HADOOP_VERSION}.zip -d ${ES_HADOOP_HOME} \
    && rm elasticsearch-hadoop-${ES_HADOOP_VERSION}.zip

RUN wget ${MAVEN_ES_SPARK_VERSION}.jar -O ${ES_HADOOP_HOME_VERSION}/dist/${ES_SPARK_20_2_11}-${ES_HADOOP_VERSION}.jar
RUN wget ${MAVEN_ES_SPARK_VERSION}-javadoc.jar -O ${ES_HADOOP_HOME_VERSION}/dist/${ES_SPARK_20_2_11}-${ES_HADOOP_VERSION}-javadoc.jar
RUN wget ${MAVEN_ES_SPARK_VERSION}-sources.jar -O ${ES_HADOOP_HOME_VERSION}/dist/${ES_SPARK_20_2_11}-${ES_HADOOP_VERSION}-sources.jar

ENV PYTHONHASHSEED 1
