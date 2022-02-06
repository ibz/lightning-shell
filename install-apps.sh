#!/bin/bash

while IFS= read -r line; do
    FILENAME=/home/lnshell/.local/bin/`echo $line | cut -d " " -f1`
    echo "#!/bin/bash" > $FILENAME
    echo $line | cut -d " " -f2- >> $FILENAME
    chmod +x $FILENAME
done <<< `jq -r '.apps[] | "\(.name) \(.run)"' /home/lnshell/.local/share/apps.json`
