#!/bin/bash
# Export views from PostreSQL database into separate files.

file_name=""
host=""
db=""

for f in `cat ~/${db}_views.txt`;
do
  echo $f
  file_name=$(echo $f| cut -d'.' -f 2)
  psql -qAXt -h $host -d $db \
    -c "select 'create or replace view $file_name as'
    || chr(10)|| lower(definition) || chr(10) || chr(10) ||
    'alter view ' || viewname || ' owner to ' || viewowner || ';'
    from pg_views where schemaname || '.' || viewname = '$f'" \
     > ~/cro/$db/sql/views/$file_name.sql
done

exit 0;
