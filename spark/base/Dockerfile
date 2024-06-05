# To check running container: docker exec -it tube /bin/bash
FROM quay.io/cdis/python:python3.9-buster-stable

ENV DEBIAN_FRONTEND=noninteractive \
    HADOOP_VERSION="3" \
    ES_HADOOP_VERSION="8.3.3" \
    SPARK_VERSION="3.3.0"

ENV SPARK_INSTALLATION_URL="http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" \
    HADOOP_INSTALLATION_URL="http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" \
    SPARK_HOME="/spark" \
    HADOOP_HOME="/hadoop" \
    JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64/"

RUN mkdir -p /usr/share/man/man1

RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    libpq-dev \
    build-essential \
    libssl1.1 \
    libgnutls30 \
    ca-certificates-java \
    openjdk-11-jdk \
    openssh-server \
    # dependency for pyscopg2 - which is dependency for sqlalchemy postgres engine
    libpq-dev \
    wget \
    git \
    # dependency for cryptography
    libffi-dev \
    # dependency for cryptography
    libssl-dev \
    vim \
    dnsutils \
    && rm -rf /var/lib/apt/lists/*

RUN wget $SPARK_INSTALLATION_URL \
    && mkdir -p $SPARK_HOME \
    && tar -xvf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C $SPARK_HOME --strip-components 1 \
    && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

RUN apt-get --only-upgrade install libpq-dev

ENV PATH="${PATH}:${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${HADOOP_HOME}/sbin:${HADOOP_HOME}/bin:${JAVA_HOME}/bin:${SCALA_HOME}/bin"


RUN mkdir -p /var/run/sshd ${HADOOP_HOME}/hdfs ${HADOOP_HOME}/hdfs/data ${HADOOP_HOME}/hdfs/data/dfs ${HADOOP_HOME}/hdfs/data/dfs/namenode ${HADOOP_HOME}/logs

ENV PYTHONHASHSEED 1
