#!/bin/bash
cd /home/me
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"
${MODIFIED_STARTUP}
echo okayyyyyyyyy
pwd
ls -al
ls -al /home/me
./ballisticakit_server
