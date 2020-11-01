#!/usr/bin/env bash

cp /docker-entrypoint-initdb.d/*.txt /var/lib/mysql-files
mysqlimport -uroot --password="$MYSQL_ROOT_PASSWORD" spip /var/lib/mysql-files/spip_auteurs.txt
mysqlimport -uroot --password="$MYSQL_ROOT_PASSWORD" spip /var/lib/mysql-files/spip_jobs.txt
mysqlimport -uroot --password="$MYSQL_ROOT_PASSWORD" spip /var/lib/mysql-files/spip_meta.txt
mysqlimport -uroot --password="$MYSQL_ROOT_PASSWORD" spip /var/lib/mysql-files/spip_types_documents.txt
