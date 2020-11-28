#!/bin/bash
## Get /usr/bin/minio && /usr/bin/mc
cd /usr/bin/
wget https://dl.min.io/server/minio/release/linux-amd64/minio
wget https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x minio mc

minio --version
mc --version
