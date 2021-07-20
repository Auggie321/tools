centos install pgbench
```
yum search postgres |grep contrib
yum -y install postgresql-contrib.x86_64
pgbench --version
```

```
Initialization command(4000万条数据，大概6G的测试数据)
postgres=# create database test;
pgbench -h localhost -U postgres -p 5432 -i -s 400 test

## 查看所有数据库的大小，用来查看测试数据库test的大小
postgres=# select pg_database.datname, pg_size_pretty (pg_database_size(pg_database.datname)) AS size from pg_database; 

## search
pgbench -h localhost -U postgres -p 5432  -c 8 -j 8 -S -T 60 -r test

## update
pgbench -h localhost -U postgres -p 5432 -c 8 -j 8 -S -T 60 -r test -f update.sql

## insert
pgbench -h localhost -U postgres -p 5432 -c 8 -j 8 -S -T 60 -r test -f insert.sql

## 混合读写
pgbench -h localhost -U postgres -p 5432 -c 8 -j 8 -S -T 60 -r test -f test.sql
```