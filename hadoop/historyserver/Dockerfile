FROM quay.io/cdis/hadoop-base:3.3.0

HEALTHCHECK CMD curl -f http://localhost:9870/ || exit 1

ENV HDFS_CONF_dfs_namenode_name_dir=file:///hadoop/dfs/name
RUN mkdir -p /hadoop/dfs/name
VOLUME /hadoop/dfs/name

ADD run.sh /gen3spark/run.sh
RUN chmod a+x /gen3spark/run.sh
WORKDIR /gen3spark

EXPOSE 9870

CMD ["/gen3spark/run.sh"]