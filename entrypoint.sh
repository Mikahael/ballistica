#!/bin/bash
mv /home/me/* /home/container
cd /home/container
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"
${MODIFIED_STARTUP}
echo hewllow_worldd
curl -O https://raw.githubusercontent.com/Mikahael/ballistica/refs/heads/main/src/assets/server_package/config.toml
pwd
ls -al
./ballisticakit_server
