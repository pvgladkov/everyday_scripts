#!/bin/bash

##
# 
#  
##

# папка с бэкапами
BACKUP_DIR=""

DBNAME=""

# срок хранения бэкапов (в днях)
DAYS="14"

# доступы
DBUSER=
DBPASS=
DBHOST=

# текущая дата
DATE=`date +%Y-%M-%d`

# y/m/d/h/m separately
YEAR=`date +%Y`
MONTH=`date +%m`
DAY=`date +%d`
HOURS=`date +%H`
MINUTES=`date +%M`

# пошли бэкапить
cd $BACKUP_DIR
backup_name="$YEAR-$MONTH-$DAY.$HOURS-$MINUTES.$DBNAME.backup.sql" 
backup_tarball_name="$backup_name.tar.gz" 

`/usr/bin/mysqldump -h "$DBHOST" --databases "$DBNAME" -u "$DBUSER" --password="$DBPASS" > "$backup_name"`
echo "   backup $backup_name" 

`/bin/tar -zcf "$backup_tarball_name" "$backup_name"`
echo "   compress $backup_tarball_name" 

`/bin/rm "$backup_name"`
echo "   cleanup $backup_name" 

# удалим старые файлы
/usr/bin/find $BACKUP_DIR -type f -mtime +$DAYS -print0 | xargs -0 rm -f

echo "done!"
