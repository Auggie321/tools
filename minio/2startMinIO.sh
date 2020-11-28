#!/bin/bash

cp /opt/minio/conf/minio /etc/default/minio
cp /opt/minio/conf/minio.service	/usr/lib/systemd/system/minio.service
systemctl daemon-reload
systemctl restart minio
systemctl enable minio
systemctl status minio