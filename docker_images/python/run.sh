#! /bin/bash
#
docker build -t python-hostname:1.0 .
docker run --rm -p 5000:5000 python-hostname:1.0
docker tag python-hostname:1.0 ghcr.io/titov32/python-hostname:1.0
docker push ghcr.io/titov32/python-hostname:1.0
