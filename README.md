# 100sp
Repository of test tasks

__Running phpMyAdmin in a container__

Create a file docker-compose.yml with content
```
services:
  mariadb:
    image: mariadb
    restart: always
    volumes:
      - ./mariadb:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: VerySecretPWD

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    links: 
      - mariadb:db
    ports:
      - 8765:80
    environment:
      MYSQL_ROOT_PASSWORD: VerySecretPWD
    depends_on:
      - mariadb
```
Then enter the command `docker-compose up -d`

You can view the list of running containers with the `docker ps` command

We transfer the dump file to the host with the container `scp /path/to/dump.sql username@ip_address:/path/dump.sql`

Then we transfer the dump to the container `docker cp dump.sql container_name:/home`

We enter the DBMS management console of the container `docker exec -it container_name mysql -uroot -p
VerySecretPWD`

Create a database and exit `CREATE DATABASE test;` `exit`

We go into the container `docker exec -it container_name bash`

And upload the dump to the created database `mysql -u root -p test < /home/dump.sql` `VerySecretPWD`

__Backups__

All actions are performed not in the container, but on the host

create a backup directory `mkdir -p /path/to/backup`

Create a file backup.sh with the contents
```
#!/bin/sh
DATA=`date +"%Y-%m-%d_%H-%M"`
echo "`date +"%Y-%m-%d_%H-%M-%S"` A backup of the test database has been started" >> /path/to/backup/test.log
docker exec -it container_name mysqldump -uroot --password=VerySecretPWD test > test.sql | pigz > /path/to/backup/$DATA-test.sql.gz
echo "`date +"%Y-%m-%d_%H-%M-%S"` The test database has been unloaded\n" >> /path/to/backup/test.log
/usr/bin/find /path/to/backup -type f -mtime +10 -exec rm -rf {} \;
```
A database dump will be created every night and its relevance will be the last 10 days

Making the file executable `chmod +x backup.sh`

And create a task in the crown `crontab -e ` `0 0 * * * /path/to/backup.sh`
