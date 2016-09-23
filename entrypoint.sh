#!/bin/bash

CONTAINER_IP=$(hostname -i)
EXTERNAL_IP="${EXTERNAL_IP:-}"
MYSQL_HOST="${MYSQL_HOST:-mysql}"
MYSQL_PORT="${MYSQL_PORT:-3306}"
MYSQL_USER="${MYSQL_USER:-ebotv3}"
MYSQL_PASS="${MYSQL_PASS:-ebotv3}"
MYSQL_DB="${MYSQL_DB:-ebotv3}"

LO3_METHOD="${LO3_METHOD:-restart}"
KO3_METHOD="${KO3_METHOD:-restart}"
DEMO_DOWNLOAD="${DEMO_DOWNLOAD:-true}"
REMIND_RECORD="${REMIND_RECORD:-false}"
DAMAGE_REPORT="${DAMAGE_REPORT:-false}"
DELAY_READY="${DELAY_READY:-false}"
NODE_STARTUP_METHOD="${NODE_STARTUP_METHOD:-none}"

# for usage with docker-compose
while ! nc -z $MYSQL_HOST $MYSQL_PORT; do sleep 3; done

sed -i "s/BOT_IP =.*/BOT_IP = \"$CONTAINER_IP\"/g" $EBOT_HOME/config/config.ini
sed -i "s/EXTERNAL_LOG_IP = .*/EXTERNAL_LOG_IP = \"$EXTERNAL_IP\"/g" $EBOT_HOME/config/config.ini
sed -i "s/MYSQL_IP =.*/MYSQL_IP = \"$MYSQL_HOST\"/g" $EBOT_HOME/config/config.ini
sed -i "s/MYSQL_PORT =.*/MYSQL_PORT = \"$MYSQL_PORT\"/g" $EBOT_HOME/config/config.ini
sed -i "s/MYSQL_USER =.*/MYSQL_USER = \"$MYSQL_USER\"/g" $EBOT_HOME/config/config.ini
sed -i "s/MYSQL_PASS =.*/MYSQL_PASS = \"$MYSQL_PASS\"/g" $EBOT_HOME/config/config.ini
sed -i "s/MYSQL_BASE =.*/MYSQL_BASE = \"$MYSQL_DB\"/g" $EBOT_HOME/config/config.ini
sed -i "s/LO3_METHOD =.*/LO3_METHOD = \"$LO3_METHOD\"/g" $EBOT_HOME/config/config.ini
sed -i "s/KO3_METHOD =.*/KO3_METHOD = \"$KO3_METHOD\"/g" $EBOT_HOME/config/config.ini
sed -i "s/DEMO_DOWNLOAD =.*/DEMO_DOWNLOAD = $DEMO_DOWNLOAD/g" $EBOT_HOME/config/config.ini
sed -i "s/REMIND_RECORD =.*/REMIND_RECORD = $REMIND_RECORD/g" $EBOT_HOME/config/config.ini
sed -i "s/DAMAGE_REPORT =.*/DAMAGE_REPORT = $DAMAGE_REPORT/g" $EBOT_HOME/config/config.ini
sed -i "s/DELAY_READY = .*/DELAY_READY = $DELAY_READY/g" $EBOT_HOME/config/config.ini
sed -i "s/NODE_STARTUP_METHOD = .*/NODE_STARTUP_METHOD = \"$NODE_STARTUP_METHOD\"/g" $EBOT_HOME/config/config.ini

exec php "$EBOT_HOME/bootstrap.php" && forever start $EBOT_HOME/websocket_server.js $EXTERNAL_IP 12360

