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

ENV CORE_CONF_fs_defaultFS=hdfs://namenode:9000 \
    CORE_CONF_hadoop_http_staticuser_user=root \
    CORE_CONF_hadoop_proxyuser_hue_hosts=* \
    CORE_CONF_hadoop_proxyuser_hue_groups=* \
    CORE_CONF_io_compression_codecs=org.apache.hadoop.io.compress.SnappyCodec \
    HDFS_CONF_dfs_webhdfs_enabled=true \
    HDFS_CONF_dfs_permissions_enabled=false \
    HDFS_CONF_dfs_namenode_datanode_registration_ip___hostname___check=false \
    YARN_CONF_yarn_log___aggregation___enable=true \
    YARN_CONF_yarn_log_server_url=http://historyserver:8188/applicationhistory/logs/ \
    YARN_CONF_yarn_resourcemanager_recovery_enabled=true \
    YARN_CONF_yarn_resourcemanager_store_class=org.apache.hadoop.yarn.server.resourcemanager.recovery.FileSystemRMStateStore \
    YARN_CONF_yarn_resourcemanager_scheduler_class=org.apache.hadoop.yarn.server.resourcemanager.scheduler.capacity.CapacityScheduler \
    YARN_CONF_yarn_scheduler_capacity_root_default_maximum___allocation___mb=8192 \
    YARN_CONF_yarn_scheduler_capacity_root_default_maximum___allocation___vcores=4 \
    YARN_CONF_yarn_resourcemanager_fs_state___store_uri=/rmstate \
    YARN_CONF_yarn_resourcemanager_system___metrics___publisher_enabled=true \
    YARN_CONF_yarn_resourcemanager_hostname=resourcemanager \
    YARN_CONF_yarn_resourcemanager_address=resourcemanager:8032 \
    YARN_CONF_yarn_resourcemanager_scheduler_address=resourcemanager:8030 \
    YARN_CONF_yarn_resourcemanager_resource__tracker_address=resourcemanager:8031 \
    YARN_CONF_yarn_timeline___service_enabled=true \
    YARN_CONF_yarn_timeline___service_generic___application___history_enabled=true \
    YARN_CONF_yarn_timeline___service_hostname=historyserver \
    YARN_CONF_mapreduce_map_output_compress=true \
    YARN_CONF_mapred_map_output_compress_codec=org.apache.hadoop.io.compress.SnappyCodec \
    YARN_CONF_yarn_nodemanager_resource_memory___mb=16384 \
    YARN_CONF_yarn_nodemanager_resource_cpu___vcores=8 \
    YARN_CONF_yarn_nodemanager_disk___health___checker_max___disk___utilization___per___disk___percentage=98.5 \
    YARN_CONF_yarn_nodemanager_remote___app___log___dir=/app-logs \
    YARN_CONF_yarn_nodemanager_aux___services=mapreduce_shuffle \
    MAPRED_CONF_mapreduce_framework_name=yarn \
    MAPRED_CONF_mapred_child_java_opts=-Xmx4096m \
    MAPRED_CONF_mapreduce_map_memory_mb=4096 \
    MAPRED_CONF_mapreduce_reduce_memory_mb=8192 \
    MAPRED_CONF_mapreduce_map_java_opts=-Xmx3072m \
    MAPRED_CONF_mapreduce_reduce_java_opts=-Xmx6144m \
    MAPRED_CONF_yarn_app_mapreduce_am_env=HADOOP_MAPRED_HOME=$HADOOP_HOME/ \
    MAPRED_CONF_mapreduce_map_env=HADOOP_MAPRED_HOME=$HADOOP_HOME/ \
    MAPRED_CONF_mapreduce_reduce_env=HADOOP_MAPRED_HOME=$HADOOP_HOME/

COPY . /gen3spark
WORKDIR /gen3spark

# ENV TINI_VERSION v0.18.0
# ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
# RUN chmod +x /tini
# ENTRYPOINT ["/tini", "--"]

CMD ["/usr/sbin/sshd", "-D"]
