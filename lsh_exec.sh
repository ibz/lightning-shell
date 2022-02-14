#!/bin/bash

lsh=$(docker ps | grep lightning-shell | awk '{print $1}')
docker exec -e PATH=/home/lnshell/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin -it $lsh $@
