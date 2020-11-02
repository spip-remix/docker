#!/usr/bin/env bash

mysqlimport -uroot --password="$MYSQL_ROOT_PASSWORD" spip /docker-entrypoint-initdb.d/spip_auteurs.txt
mysqlimport -uroot --password="$MYSQL_ROOT_PASSWORD" spip /docker-entrypoint-initdb.d/spip_jobs.txt
mysqlimport -uroot --password="$MYSQL_ROOT_PASSWORD" spip /docker-entrypoint-initdb.d/spip_meta.txt
mysqlimport -uroot --password="$MYSQL_ROOT_PASSWORD" spip /docker-entrypoint-initdb.d/spip_types_documents.txt
