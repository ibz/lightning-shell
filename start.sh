#! /usr/bin/env bash

if [ -x /data/on_start.sh ]; then
    /data/on_start.sh
fi

/usr/bin/tini /usr/local/bin/ttyd -- --credential ${USERNAME}:${APP_PASSWORD} bash
