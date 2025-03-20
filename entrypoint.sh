#!/bin/bash
cd /home/container
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"
${MODIFIED_STARTUP}
echo okayyyyyyyyy
pwd
ls -al
ls -al ./path/to/ballisticakit_server
./ballisticakit_server
