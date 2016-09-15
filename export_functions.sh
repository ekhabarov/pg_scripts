#!/bin/bash
# Export functions from PostreSQL database into separate files.

host=""
db="dbname"
func_list=~/tmp/${db}_func.txt


psql -qAXt -h $host -d $db -c "select
n.nspname || '.' || '''"' || relname || '"'''
from pg_class c
  join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public'
  and c.relkind = 'r';" > $func_list

for f in `cat $func_list`;
do
  echo $f
  funcname=`psql -qAXt -h $host -d $db -c "select
    n.nspname || '.' || p.proname
    from pg_proc p
      join pg_namespace n on n.oid = p.pronamespace
    where p.oid = $f;"`
    psql -qAXt -h $host -d $db -c "select lower(pg_get_functiondef($f))" 
    > ~/cro/$db/sql/functions/$funcname.sql
done

exit 0;
