docker-ebot
================

[![](https://images.microbadger.com/badges/version/hsfactory/ebot.svg)](https://microbadger.com/images/hsfactory/ebot "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/hsfactory/ebot.svg)](https://microbadger.com/images/hsfactory/ebot "Get your own image badge on microbadger.com") 

Dockerised eBot (https://github.com/deStrO/eBot-CSGO) for ease of use. 

Pre-Requisites
--------------
* Edit PUBLIC_IP ENV in the docker-compose.yml
* An host **without** mysql, if you use your own mysql, delete the mysql container in the docker-compose.yml

Settings
---------
Edit the following settings in [docker-compose.yml](docker-compose.yml) to your needs.
#### eBot
````
EXTERNAL_IP: '192.168.1.64'
MYSQL_HOST: 'mysql'
MYSQL_PORT: '3306'
MYSQL_DB: 'ebotv3'
MYSQL_USER: 'ebotv3'
MYSQL_PASS: 'ebotv3'
LO3_METHOD: 'restart'
KO3_METHOD: 'restart'
DEMO_DOWNLOAD: 'true'
REMIND_RECORD: 'false'
DAMAGE_REPORT: 'true'
DELAY_READY: 'false'
USE_DELAY_END_RECORD: 'true'
````

#### eBot-Web
````
EBOT_IP: '192.168.1.64'
EBOT_PORT: '12360'
EBOT_ADMIN_USER: 'admin'
EBOT_ADMIN_PASS: 'password'
MYSQL_HOST: 'mysql'
MYSQL_PORT: '3306'
MYSQL_DB: 'ebotv3'
MYSQL_USER: 'ebotv3'
MYSQL_PASS: 'ebotv3'
DEMO_DOWNLOAD: 'true'
TOORNAMENT_ID: ''
TOORNAMENT_SECRET: ''
TOORNAMENT_API_KEY: ''
TOORNAMENT_PLUGIN_KEY: ''
````

#### MySql
````
MYSQL_DATABASE=ebotv3
MYSQL_USER=ebotv3
MYSQL_PASSWORD=ebotv3
MYSQL_ROOT_PASSWORD=ebotv3
````

Run
---

`docker-compose up -d`

Quick start
-----------
* Connect to the running eBot web interface @ `http://$hostip/`

* To admin goto `http://$hostip/admin.php` - u:admin p:password


Thanks to
-------
* destr0
* carazzim0
