#!/bin/bash

##
# 
#  postgres backup
##

# y/m/d/h/m separately
YEAR=`date +%Y`
MONTH=`date +%m`
DAY=`date +%d`
HOURS=`date +%H`
MINUTES=`date +%M`

##
# Бэкап базы
##
BACKUP_BASE_DIR="/var/www/backup"
PGHOST="/tmp"
PGUSER="postgres"
B_DB=""
OUTPUT_AR="db_"`date +%Y%m%d`".gz" 

BACKUP_DIR=$BACKUP_BASE_DIR"/db"
#mkdir --parents --verbose $BACKUP_DIR

##
#
##
function pg_backup_database
{
  DB=$1
	/usr/bin/pg_dump -bv -f $BACKUP_DIR/$DB.pgd -Fc $DB
	/bin/gzip -c $BACKUP_DIR/$DB.pgd > $BACKUP_DIR/$OUTPUT_AR
}

/bin/echo "backup db start"

if [ -n "$1" ]; then
	pg_backup_database $1
else
	DB_LIST=`/usr/bin/psql -l -t | /usr/bin/cut -d'|' -f1 | /bin/sed -e 's/ //g'`
	for DB in $DB_LIST
	do
		if [ "$DB" == $B_DB ] ; then
			pg_backup_database $DB
		fi
	done
fi

/bin/echo "backup db end"
