#!/bin/bash

script_name=`basename $0`

if [[ "$script_name" == *"_ni"* ]]; then # non-interactive
    extra_param=
else
    extra_param="-it"
fi

lsh=$(docker ps | grep lightning-shell | awk '{print $1}')
docker exec -e PATH=/home/lnshell/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin $extra_param $lsh $@
