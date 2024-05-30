FROM quay.io/cdis/hadoop-base:3.3.0

HEALTHCHECK CMD curl -f http://localhost:9864/ || exit 1

ENV HDFS_CONF_dfs_datanode_data_dir=file:///hadoop/dfs/data
RUN mkdir -p /hadoop/dfs/data
VOLUME /hadoop/dfs/data

ADD run.sh /run.sh
RUN chmod a+x /run.sh
WORKDIR /gen3spark

EXPOSE 9864

CMD ["/gen3spark/run.sh"]
