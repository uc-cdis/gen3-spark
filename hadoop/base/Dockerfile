# To check running container: docker exec -it tube /bin/bash
FROM quay.io/cdis/python:python3.9-buster-stable

ENV DEBIAN_FRONTEND=noninteractive \
    HADOOP_VERSION="3.3.2"

ENV HADOOP_INSTALLATION_URL="http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" \
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
    net-tools \
    netcat \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

RUN wget ${HADOOP_INSTALLATION_URL} \
    && mkdir -p $HADOOP_HOME \
    && tar -xvf hadoop-${HADOOP_VERSION}.tar.gz -C ${HADOOP_HOME} --strip-components 1 \
    && rm hadoop-${HADOOP_VERSION}.tar.gz \
    && rm -rf $HADOOP_HOME/share/doc

ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop \
    HADOOP_MAPRED_HOME=$HADOOP_HOME \
    HADOOP_COMMON_HOME=$HADOOP_HOME \
    HADOOP_HDFS_HOME=$HADOOP_HOME \
    YARN_HOME=$HADOOP_HOME \
    HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native

RUN apt-get --only-upgrade install libpq-dev

ENV PATH="${PATH}:${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${HADOOP_HOME}/sbin:${HADOOP_HOME}/bin:${JAVA_HOME}/bin:${SCALA_HOME}/bin"

ADD entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
