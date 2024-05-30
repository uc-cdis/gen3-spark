FROM bde2020/spark-base:3.3.0-hadoop3.3

LABEL maintainer="Gezim Sejdiu <g.sejdiu@gmail.com>, Giannis Mouchakis <gmouchakis@gmail.com>"

ENV SPARK_MASTER_PORT 7077
ENV SPARK_MASTER_WEBUI_PORT 8080
ENV SPARK_MASTER_LOG /spark/logs

EXPOSE 8080 7077 6066

COPY master.sh /gen3spark
WORKDIR /gen3spark

CMD ["/bin/bash", "/master.sh"]

