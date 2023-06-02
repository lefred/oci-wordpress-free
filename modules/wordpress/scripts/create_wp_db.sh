#!/bin/bash

wpschema="${wp_schema}"
wpname="${wp_name}"

mysqlsh --user root --password="" --host 127.0.0.1 --sql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${admin_password}';"
mysqlsh --user root --password="${admin_password}" --host 127.0.0.1 --sql -e "CREATE DATABASE $wpschema;"
mysqlsh --user root --password="${admin_password}" --host 127.0.0.1 --sql -e "CREATE USER $wpname identified by '${wp_password}';"
mysqlsh --user root --password="${admin_password}" --host 127.0.0.1 --sql -e "GRANT ALL PRIVILEGES ON $wpschema.* TO $wpname;"

echo "WordPress Database and User created !"
echo "WP USER = $wpname"
echo "WP SCHEMA = $wpschema"
