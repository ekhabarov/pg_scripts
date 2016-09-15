#!/bin/bash
# Export functions from PostreSQL database into separate files.

host=""
db=""
func_list=~/tmp/${db}_func.txt

#Collect functions oids.
psql -qAXt -h $host -d $db -c "select
  p.oid
from pg_proc p
  join pg_namespace n on n.oid = p.pronamespace
  join pg_language l on l.oid = p.prolang
where n.nspname not in ('pg_catalog', 'information_schema')
  and probin is null
  and p.proname !~ '^(st_|postgis_|raster_|geometry|geography|_)'
  and p.proname !~ 'lockrow';" > $func_list


for foid in `cat $func_list`;
do
  echo $foid
  funcname=`psql -qAXt -h $host -d $db -c "select
    n.nspname || '.' || p.proname
    from pg_proc p
      join pg_namespace n on n.oid = p.pronamespace
    where p.oid = $foid;"`
    psql -qAXt -h $host -d $db -c "select lower(pg_get_functiondef($foid))" 
    > ~/cro/$db/sql/functions/$funcname.sql
done

exit 0;
