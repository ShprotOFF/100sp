# 100sp
Repository of test tasks

__Running phpMyAdmin in a container__

Create a docker-compose file.yml with content
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
