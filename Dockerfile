# To check running container: docker exec -it tube /bin/bash
ARG AZLINUX_BASE_VERSION=master

FROM quay.io/cdis/python-nginx-al:${AZLINUX_BASE_VERSION} AS base

# create gen3 user
# Create a group 'gen3' with GID 1000 and a user 'gen3' with UID 1000
# RUN groupadd -g 1000 gen3 && \
#     useradd -m -s /bin/bash -u 1000 -g gen3 gen3
#will change to gen3 user later

WORKDIR /gen3spark

# ------ Builder Stage ------
FROM base AS builder

ENV DEBIAN_FRONTEND=noninteractive \
    SPARK_VERSION="2.4.0" \
    HADOOP_VERSION="3.1.1" \
    SCALA_VERSION="2.12.8"

ENV SPARK_INSTALLATION_URL="http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz" \
    HADOOP_INSTALLATION_URL="http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" \
    SCALA_INSTALLATION_URL="https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz" \
    SPARK_HOME="/spark" \
    HADOOP_HOME="/hadoop" \
    SCALA_HOME="/scala"

RUN mkdir -p /usr/share/man/man1

RUN yum update && yum install -y --setopt=install_weak_deps=False \
    yum-utils \
    gcc gcc-c++ make \
    openssl openssl-devel \
    gnutls gnutls-devel \
    wget \
    tar \
    && yum clean all

RUN wget $SPARK_INSTALLATION_URL \
    && mkdir -p $SPARK_HOME \
    && tar -xvf spark-${SPARK_VERSION}-bin-without-hadoop.tgz -C $SPARK_HOME --strip-components 1 \
    && rm spark-${SPARK_VERSION}-bin-without-hadoop.tgz

RUN wget ${HADOOP_INSTALLATION_URL} \
    && mkdir -p $HADOOP_HOME \
    && tar -xvf hadoop-${HADOOP_VERSION}.tar.gz -C ${HADOOP_HOME} --strip-components 1 \
    && rm hadoop-${HADOOP_VERSION}.tar.gz \
    && rm -rf $HADOOP_HOME/share/doc

RUN wget ${SCALA_INSTALLATION_URL} \
    && mkdir -p /scala \
    && tar -xvf scala-${SCALA_VERSION}.tgz -C ${SCALA_HOME} --strip-components 1 \
    && rm scala-${SCALA_VERSION}.tgz


# ------ Final Stage ------
FROM base

    # Set environment variables
ENV SPARK_HOME="/spark" \
    HADOOP_HOME="/hadoop" \
    SCALA_HOME="/scala"

# Copy required files from build stage
COPY --from=builder ${SPARK_HOME} ${SPARK_HOME}
COPY --from=builder ${HADOOP_HOME} ${HADOOP_HOME}
COPY --from=builder ${SCALA_HOME} ${SCALA_HOME}


# Install runtime dependencies
RUN yum update && yum install -y --setopt=install_weak_deps=False \
    java-11-amazon-corretto java-11-amazon-corretto-devel \
    openssh-server \
    postgresql-devel \
    git \
    libffi libffi-devel \
    vim \
    && yum clean all

ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop \
    HADOOP_MAPRED_HOME=$HADOOP_HOME \
    HADOOP_COMMON_HOME=$HADOOP_HOME \
    HADOOP_HDFS_HOME=$HADOOP_HOME \
    YARN_HOME=$HADOOP_HOME \
    HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native \
    JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto" \
    PATH="${PATH}:${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${HADOOP_HOME}/sbin:${HADOOP_HOME}/bin:${JAVA_HOME}/bin:${SCALA_HOME}/bin}"



RUN echo 'export HADOOP_OPTS="-Djava.net.preferIPv4Stack=true -Dsun.security.krb5.debug=true -Dsun.security.spnego.debug"' >> $HADOOP_CONF_DIR/hadoop-env.sh && \
    echo 'export HADOOP_OS_TYPE="${HADOOP_OS_TYPE:-$(uname -s)}"' >> ${HADOOP_CONF_DIR}/hadoop-env.sh && \
    echo 'export HDFS_NAMENODE_OPTS="-Dhadoop.security.logger=INFO,RFAS"' >> $HADOOP_CONF_DIR/hadoop-env.sh && \
    echo 'export HDFS_SECONDARYNAMENODE_OPTS="-Dhadoop.security.logger=INFO,RFAS"' >> $HADOOP_CONF_DIR/hadoop-env.sh && \
    echo 'export HDFS_DATANODE_OPTS="-Dhadoop.security.logger=ERROR,RFAS"' >> $HADOOP_CONF_DIR/hadoop-env.sh && \
    echo "export HDFS_DATANODE_USER=root" >> $HADOOP_CONF_DIR/hadoop-env.sh && \
    echo "export HDFS_NAMENODE_USER=root" >> $HADOOP_CONF_DIR/hadoop-env.sh && \
    echo "export HDFS_SECONDARYNAMENODE_USER=root" >> $HADOOP_CONF_DIR/hadoop-env.sh && \
    echo "export JAVA_HOME=${JAVA_HOME}" >> $HADOOP_CONF_DIR/hadoop-env.sh && \
    echo "export HADOOP_HOME=${HADOOP_HOME}" >> $HADOOP_CONF_DIR/hadoop-env.sh && \
    echo "export HADOOP_CLASSPATH=${HADOOP_CLASSPATH}:${HADOOP_HOME}/share/hadoop/tools/lib" >> $HADOOP_CONF_DIR/hadoop-env.sh && \
    echo "export YARN_RESOURCEMANAGER_USER=root" >> $HADOOP_CONF_DIR/yarn-env.sh && \
    echo "export YARN_NODEMANAGER_USER=root" >> $HADOOP_CONF_DIR/yarn-env.sh && \
    echo "export SPARK_DIST_CLASSPATH=$(hadoop --config $HADOOP_HOME/etc/hadoop classpath):/hadoop/share/hadoop/tools/lib/*" >> ${SPARK_HOME}/conf/spark-env.sh && \
    echo "export SPARK_MASTER_HOST=0.0.0.0" >> ${SPARK_HOME}/conf/spark-env.sh && \
    echo "spark.eventLog.enabled           true" >> ${SPARK_HOME}/conf/spark-defaults.conf && \
    echo "spark.eventLog.compress          true" >> ${SPARK_HOME}/conf/spark-defaults.conf && \
    echo "spark.eventLog.dir               hdfs://0.0.0.0:8021/logs" >> ${SPARK_HOME}/conf/spark-defaults.conf && \
    echo "spark.history.fs.logDirectory    file:/spark/logs" >> ${SPARK_HOME}/conf/spark-defaults.conf && \
    echo "spark.ui.enabled                 true" >> ${SPARK_HOME}/conf/spark-defaults.conf && \
    echo "spark.broadcast.compress         true" >> ${SPARK_HOME}/conf/spark-defaults.conf && \
    echo "spark.io.compression.codec       org.apache.spark.io.SnappyCompressionCodec" >> ${SPARK_HOME}/conf/spark-defaults.conf && \
    echo "spark.io.compression.snappy.blockSize    32k" >> ${SPARK_HOME}/conf/spark-defaults.conf && \
    echo "spark.serializer                 org.apache.spark.serializer.KryoSerialize" >> ${SPARK_HOME}/conf/spark-defaults.conf && \
    echo "spark.app.name                   gen3spark" >> ${SPARK_HOME}/conf/spark-defaults.conf


EXPOSE 22 4040 7077 8020 8030 8031 8032 8042 8088 9000 10020 19888 50010 50020 50070 50075 50090

RUN mkdir -p /var/run/sshd ${HADOOP_HOME}/hdfs ${HADOOP_HOME}/hdfs/data ${HADOOP_HOME}/hdfs/data/dfs ${HADOOP_HOME}/hdfs/data/dfs/namenode ${HADOOP_HOME}/logs \
        && ssh-keygen -A

COPY . /gen3spark
WORKDIR /gen3spark

# ENV TINI_VERSION v0.18.0
# ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
# RUN chmod +x /tini
# ENTRYPOINT ["/tini", "--"]

CMD ["/usr/sbin/sshd", "-D"]
