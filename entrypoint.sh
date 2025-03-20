#!/bin/bash
cp -R /home/me/* /home/container
cd /home/container
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"
${MODIFIED_STARTUP}
echo okayyyyyyyyy
pwd
ls -al
./ballisticakit_server
