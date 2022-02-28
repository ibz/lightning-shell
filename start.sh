#! /usr/bin/env bash

if [ -x /data/on_start.sh ]; then
    /data/on_start.sh
fi

if [ ! -x /data/lsh_exec.sh ]; then
    cp /lsh_exec.sh /data/lsh_exec.sh
    chown lnshell:lnshell /data/lsh_exec.sh
    chmod +x /data/lsh_exec.sh
fi

if [ ! -x /data/lsh_exec_ni.sh ]; then
    cp /lsh_exec.sh /data/lsh_exec_ni.sh
    chown lnshell:lnshell /data/lsh_exec_ni.sh
    chmod +x /data/lsh_exec_ni.sh
fi

/usr/bin/tini /usr/local/bin/ttyd -- --credential ${USERNAME}:${APP_PASSWORD} bash
