#!/bin/bash
# Export tables from PostreSQL database into separate files.

host=""
db=""
tab_list=~/tmp/${db}_table.txt

psql -qAXt -h $host -d $db -c "select
n.nspname || '.' || '''"' || relname || '"'''
from pg_class c
  join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public'
  and c.relkind = 'r';" > $tab_list

for t in `cat $tab_list`;
do
  tab=`echo $t | sed "s/\'//g" | sed "s/\"//g"`
  echo $tab' '$t
  pg_dump -d $db --table=$tab -h $host --schema-only -x 
  > ~/cro/$db/sql/tables/$tab.sql
done

exit 0;
