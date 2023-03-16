#!/bin/sh
DATA=`date +"%Y-%m-%d_%H-%M"`
echo "`date +"%Y-%m-%d_%H-%M-%S"` A backup of the test database has been started" >> /path/to/backup/test.log
docker exec -it container_name mysqldump -uroot --password=VerySecretPWD test > test.sql | pigz > /path/to/backup/$DATA-test.sql.gz
echo "`date +"%Y-%m-%d_%H-%M-%S"` The test database has been unloaded\n" >> /path/to/backup/test.log
/usr/bin/find /path/to/backup -type f -mtime +10 -exec rm -rf {} \;