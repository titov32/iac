#! /bin/bash
#
docker build -t flask-ip-info .
docker run --rm -p 5000:5000 flask-ip-info

