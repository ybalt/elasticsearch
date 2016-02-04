# elasticsearch
Elasticsearch dockerized image automation cluster-ready

This image is ready for Ansible deploy and Weave network

Docker-compose file to run:

```
elasticsearch:
  image: ybalt/elasticsearch
  ports:
   - "9200:9200"
   - "9300:9300"
  volumes:
   - /opt/es/data:/data
  environment:                                                                                                                        
    CLUSTER: clustername
    NODE_NAME: es1
    PUBLISH_ADDRESS: eth0
    BIND_ADDRESS: 0.0.0.0
    SLEEP: 5
    UNICAST_HOSTS: es1,es2,es3
```

Where:
CLUSTER - cluster name (should be the same for all nodes)
NODE_NAME - any unique name per host
PUBLISH_ADDRESS - address(interface) for unicast
SLEEP - num of seconds delay to start if node.id != 1 (helps to avoid HostUnknown for docker container)
UNICAST_HOSTS - list of hosts for unicast discovery
