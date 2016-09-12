#!/bin/bash

file_name=""

for f in `cat ~/listview.txt`;
do
  echo $f
  file_name=$(echo $f| cut -d'.' -f 2)
  psql -qAXt -c \
    "select 'create or replace view $file_name as ' || chr(10)|| lower(definition) || chr(10) || chr(10) || 'alter view ' || viewname || ' owner to <view_owner>;' from pg_views where schemaname || '.' || viewname = '$f'" \
     > ~/views/$file_name.sql
done

exit 0;
