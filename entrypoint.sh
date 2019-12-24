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
USE_DELAY_END_RECORD="${USE_DELAY_END_RECORD:-true}"

TOORNAMENT_PLUGIN_KEY="${TOORNAMENT_PLUGIN_KEY:-azertylol}"

MAPS="${MAPS:-de_dust2,de_mirage}"
# Split string by comma into an array
IFS=',' read -ra map_array <<< "$MAPS"

CONFIG_FILE="$EBOT_HOME/config/config.ini"
CONFIG_FILE_SAMPLE="$CONFIG_FILE.smp"
CONFIG_FILE_TMP="$CONFIG_FILE.tmp"

# Remove sample maps
cat $CONFIG_FILE_SAMPLE | grep -v 'MAP\[\] = "' > $CONFIG_FILE_TMP

# Write config.ini file with configured maps
while read line; do
	if [[ "$line" =~ "[MAPS]" ]]; then
		echo $line >> $CONFIG_FILE
		for map in "${map_array[@]}"
		do
			echo "MAP[] = \"$map\"" >> $CONFIG_FILE
		done
	else
		echo $line >> $CONFIG_FILE
	fi
done < $CONFIG_FILE_TMP

rm $CONFIG_FILE_TMP

# for usage with docker-compose
while ! nc -z $MYSQL_HOST $MYSQL_PORT; do sleep 3; done

echo 'date.timezone = "${TIMEZONE}"' >> /usr/local/etc/php/conf.d/php.ini

sed -i "s/BOT_IP =.*/BOT_IP = \"$CONTAINER_IP\"/g" $CONFIG_FILE
sed -i "s/EXTERNAL_LOG_IP = .*/EXTERNAL_LOG_IP = \"$EXTERNAL_IP\"/g" $CONFIG_FILE
sed -i "s/MYSQL_IP =.*/MYSQL_IP = \"$MYSQL_HOST\"/g" $CONFIG_FILE
sed -i "s/MYSQL_PORT =.*/MYSQL_PORT = \"$MYSQL_PORT\"/g" $CONFIG_FILE
sed -i "s/MYSQL_USER =.*/MYSQL_USER = \"$MYSQL_USER\"/g" $CONFIG_FILE
sed -i "s/MYSQL_PASS =.*/MYSQL_PASS = \"$MYSQL_PASS\"/g" $CONFIG_FILE
sed -i "s/MYSQL_BASE =.*/MYSQL_BASE = \"$MYSQL_DB\"/g" $CONFIG_FILE
sed -i "s/LO3_METHOD =.*/LO3_METHOD = \"$LO3_METHOD\"/g" $CONFIG_FILE
sed -i "s/KO3_METHOD =.*/KO3_METHOD = \"$KO3_METHOD\"/g" $CONFIG_FILE
sed -i "s/DEMO_DOWNLOAD =.*/DEMO_DOWNLOAD = $DEMO_DOWNLOAD/g" $CONFIG_FILE
sed -i "s/REMIND_RECORD =.*/REMIND_RECORD = $REMIND_RECORD/g" $CONFIG_FILE
sed -i "s/DAMAGE_REPORT =.*/DAMAGE_REPORT = $DAMAGE_REPORT/g" $CONFIG_FILE
sed -i "s/DAMAGE_REPORT =.*/DAMAGE_REPORT = $DAMAGE_REPORT/g" $CONFIG_FILE
sed -i "s/DELAY_READY = .*/DELAY_READY = $DELAY_READY/g" $CONFIG_FILE
sed -i "s/USE_DELAY_END_RECORD = .*/USE_DELAY_END_RECORD = \"$USE_DELAY_END_RECORD\"/g" $CONFIG_FILE

echo -e "\n" >> $EBOT_HOME/config/plugins.ini
echo '[\eBot\Plugins\Official\ToornamentNotifier]' >> $EBOT_HOME/config/plugins.ini
echo "url=http://${EXTERNAL_IP}/matchs/toornament/export/{MATCH_ID}" >> $EBOT_HOME/config/plugins.ini
echo "key=${TOORNAMENT_PLUGIN_KEY}" >> $EBOT_HOME/config/plugins.ini

exec php "$EBOT_HOME/bootstrap.php" 

