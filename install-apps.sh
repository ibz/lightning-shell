#!/bin/bash

while IFS=read -r line; do
    FILENAME=/home/lnshell/.local/bin/`echo $line | cut -d " " -f1`
    printf "#!/bin/bash" > $FILENAME
    echo $line | cut -d " " -f2- >> $FILENAME
done <<< `jq -r '.apps[] | "\(.name) \(.run)"' /build/apps/apps.json`

chown -R lnshell:lnshell /home/lnshell/.local/bin
chmod +x /home/lnshell/.local/bin/*
