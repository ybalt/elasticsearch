#!/bin/bash

set -e

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- elasticsearch "$@"
fi

# Drop root privileges if we are running elasticsearch
if [ "$1" = 'elasticsearch' ]; then
	# Change the ownership of es/data to elasticsearch
	chown -R elasticsearch:elasticsearch ${ES_HOME}/data
	OPTS="-Des.transport.tcp.port=9300 -Des.http.port=9200 -Djava.awt.headless=true -Des.foreground=yes -Des.http.cors.enabled=true"

if [ -n "$SLEEP" ]; then
   echo "sleeping for ${SLEEP}"
   sleep ${SLEEP}
fi


if [ -n "$CLUSTER" ]; then
  OPTS="$OPTS -Des.cluster.name=$CLUSTER"
fi

if [ -n "$PUBLISH_ADDRESS" ]; then
  OPTS="$OPTS -Des.network.publish_host=$PUBLISH_ADDRESS"
fi

if [ -n "$BIND_ADDRESS" ]; then
  OPTS="$OPTS -Des.network.bind_host=$BIND_ADDRESS"
fi

if [ -n "$NODE_NAME" ]; then
  OPTS="$OPTS -Des.node.name=$NODE_NAME"
fi

if [ -n "$UNICAST_HOSTS" ]; then
  OPTS="$OPTS -Des.discovery.zen.ping.unicast.hosts=$UNICAST_HOSTS"
fi

if [ -n "$TRANSPORT_BIND_ADDRESS" ]; then
  OPTS="$OPTS -Des.transport.bind_host=$TRANSPORT_BIND_ADDRESS"
fi

if [ -n "$HTTP_BIND_ADDRESS" ]; then
  OPTS="$OPTS -Des.http.bind_host=$HTTP_BIND_ADDRESS"
fi

    echo "es opts $OPTS"
    export JAVA_OPTS=${JOPTS}
	exec gosu elasticsearch ${ES_HOME}/bin/elasticsearch ${OPTS}
fi

# As argument is not related to elasticsearch,
# then assume that user wants to run his own process,
# for example a `bash` shell to explore this image
exec "$@"

