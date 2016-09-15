#!/bin/bash
# Export tables from PostreSQL database into separate files.

host=""
db=""

for t in `cat ~/tmp/${db}_table.txt`;
do
  tab=`echo $t | sed "s/\'//g" | sed "s/\"//g"`
  echo $tab' '$t
  pg_dump -d $db --table=$tab -h $host --schema-only -x 
  > ~/cro/$db/sql/tables/$tab.sql
done

exit 0;
