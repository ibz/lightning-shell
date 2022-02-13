#!/bin/bash

lsh=$(docker ps | grep lightning-shell | awk '{print $1}')
docker exec -it $lsh /home/lnshell/.local/bin/$@
