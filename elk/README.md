#### docker-compose elasticsearch heap size should better use [ES_HEAP_SIZE](https://github.com/spujadas/elk-docker/issues/129) ;
```
  environment:
    - ES_HEAP_SIZE=2g       ##ES
    - LS_HEAP_SIZE=1g       ##Logstash
```