#
# Elasticsearch Dockerfile
#
# based on https://github.com/dockerfile/elasticsearch
#

# Pull base image.
FROM java:8

# grab gosu for easy step-down from root
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN arch="$(dpkg --print-architecture)" \
	&& set -x \
	&& curl -o /usr/local/bin/gosu -fSL "https://github.com/tianon/gosu/releases/download/1.3/gosu-$arch" \
	&& curl -o /usr/local/bin/gosu.asc -fSL "https://github.com/tianon/gosu/releases/download/1.3/gosu-$arch.asc" \
	&& gpg --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu

ENV ES_VERSION 2.1.0

RUN cd /opt \
    && wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/${ES_VERSION}/elasticsearch-${ES_VERSION}.tar.gz \
    && tar xvf elasticsearch-${ES_VERSION}.tar.gz \
    && mv /opt/elasticsearch-${ES_VERSION} /opt/es

ENV ES_HOME /opt/es

RUN groupadd -r elasticsearch && useradd -r -g elasticsearch elasticsearch

RUN set -ex \
	&& for path in \
		${ES_HOME}/data \
		${ES_HOME}/logs \
		${ES_HOME}/config \
	; do \
		mkdir -p "$path"; \
		chown -R elasticsearch:elasticsearch "$path"; \
	done

COPY config ${ES_HOME}/config

RUN ${ES_HOME}/bin/plugin install license

VOLUME ${ES_HOME}/data

COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9200 9300

CMD ["elasticsearch"]
