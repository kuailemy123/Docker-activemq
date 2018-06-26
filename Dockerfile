FROM openjdk:8-jre-alpine
MAINTAINER Lework <lework@yeah.net>

ARG TZ=Asia/Shanghai

ENV ACTIVEMQ_VERSION=5.15.4
ENV ACTIVEMQ=apache-activemq-$ACTIVEMQ_VERSION \
    ACTIVEMQ_TCP=61616 ACTIVEMQ_AMQP=5672 ACTIVEMQ_STOMP=61613 ACTIVEMQ_MQTT=1883 ACTIVEMQ_WS=61614 ACTIVEMQ_UI=8161 \
    SHA512_VAL=26d8154fcfe17ab90508b3b9d46b40815404fa3886cfdc4eae4b06086332203bd2455475b9309ccabd76d0c9b65f523f9d3911d315c17bf4b48bd22395ea8ead \
    DRUID=1.1.10 \
    MYSQL_CONNECTOR=8.0.11 \
    ACTIVEMQ_HOME=/usr/local/activemq

RUN set -eux; \
    apk --update -t --no-cache add tzdata && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    cd /tmp && \
    wget -O $ACTIVEMQ-bin.tar.gz https://archive.apache.org/dist/activemq/$ACTIVEMQ_VERSION/$ACTIVEMQ-bin.tar.gz && \
    wget -O mysql-connector-java-$MYSQL_CONNECTOR.tar.gz https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-$MYSQL_CONNECTOR.tar.gz && \
    wget -O druid-$DRUID.jar http://repo1.maven.org/maven2/com/alibaba/druid/1.1.10/druid-$DRUID.jar && \
    if [ "$SHA512_VAL" != "$(sha512sum $ACTIVEMQ-bin.tar.gz | awk '{print($1)}')" ]; \
    then \
        echo "sha512 values doesn't match! exiting."; \
        exit 1; \
    fi; \
    tar xzf $ACTIVEMQ-bin.tar.gz -C  /usr/local/ && \
    tar zxf mysql-connector-java-$MYSQL_CONNECTOR.tar.gz && \
    mv mysql-connector-java-$MYSQL_CONNECTOR/mysql-connector-java-$MYSQL_CONNECTOR.jar /usr/local/$ACTIVEMQ/lib/web/ && \
    mv druid-$DRUID.jar /usr/local/$ACTIVEMQ/lib/optional/ && \
    ln -s /usr/local/$ACTIVEMQ $ACTIVEMQ_HOME && \
    addgroup -S activemq && adduser -S -H -G activemq -h $ACTIVEMQ_HOME activemq && \
    chown -R activemq:activemq /usr/local/$ACTIVEMQ && \
    chown -h activemq:activemq $ACTIVEMQ_HOME && \
    rm -rf /var/cache/apk/* /tmp/*

USER activemq

WORKDIR $ACTIVEMQ_HOME

VOLUME $ACTIVEMQ_HOME/data

EXPOSE $ACTIVEMQ_TCP $ACTIVEMQ_AMQP $ACTIVEMQ_STOMP $ACTIVEMQ_MQTT $ACTIVEMQ_WS $ACTIVEMQ_UI

CMD ["/bin/sh", "-c", "bin/activemq console"]
