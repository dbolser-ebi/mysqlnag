#!/bin/bash

DB1=$1
DB2=$2

DB1=${DB1:?plz pass a database to sync plz}
DB2=${DB2:-${DB1}}

echo "FROM DATABASE: '$DB1'"
echo " TO  DATABASE: '$DB2'"



## SOURCE database details (ensro, not ensrw)
 S_DB=( $( mysql-staging-2                  details ) )

## TARGET database details (ensrw, not admin)
 T_DB=( $( mysql-cluster-production-1-ensrw details ) )



## Assign variables from the above 'details'

## These indexes differ from the below because 'ensro' has a different
## number of arguments...
S_HOST=${S_DB[4]}; S_PORT=${S_DB[6]}; S_USER=${S_DB[8]}

## These indexes differ from the above because 'ensrw' has a different
## number of arguments...
T_HOST=${T_DB[5]}; T_PORT=${T_DB[7]}; T_USER=${T_DB[9]}; T_PASS=${T_DB[11]}

## Debugging
#echo "FROM '$S_HOST' '$S_PORT' '$S_USER'"
#echo "TO   '$T_HOST' '$T_PORT' '$T_USER' '$T_PASS'"
#exit;


## RUN

## Simplify cli
FROM="    --host=$S_HOST       --port=$S_PORT       --user=$S_USER"
TO="--targethost=$T_HOST --targetport=$T_PORT --targetuser=$T_USER --targetpassword=$T_PASS"

## Other example options

## Misc
   # --no-dump \
   # --verbose \

## Methods
   # --date \
   # --checksum \
   # --count \
   # --force \

## Used to get a (minimal) Slice adaptor
   # --force \
   # --table assembly \
   # --table coord_system \
   # --table meta \
   # --table seq_region \
   # --table mapping_set \
   # --table assembly_exception \
   # --table seq_region_attrib \
   # --table attrib_type \

## Used to dump XREFs (transcript and gene?)
   # --force \
   # --table dependent_xref \
   # --table external_synonym \
   # --table gene \
   # --table identity_xref \
   # --table interpro \
   # --table object_xref \
   # --table ontology_xref \
   # --table transcript \
   # --table unmapped_object \
   # --table xref \

time \
  ./bin/mysqlnag \
    --dir Logs \
    --verbose \
    --checksum \
    $FROM     --database $DB1 \
    $TO --targetdatabase $DB2

## Finish here because we have notes below
exit 0





## Here is how to run it over a list...

time \
while read -r from_db; do
    echo Doing $from_db;
    
    time \
        ./nagwrap.sh $from_db
    
    echo
    echo

done \
    < <(grep core plant_18_db.list)



## Here is how to run it over a list with release version renaming

time \
while read -r new_db; do
    # The list we use is the *next* release...
    old_db=${new_db/_18_71_/_17_70_}
    
    echo Doing FROM $old_db;
    echo Doing  TO  $new_db;
    
    time \
        ./nagwrap.sh $old_db $new_db
    
    echo
    echo
    echo
    
done \
    <                      plant_18_db.list &> log.18

    < <(grep variation     plant_18_db.list)
    < <(grep core          plant_18_db.list)
    < <(grep otherfeatures plant_18_db.list)
    < <(grep funcgen       plant_18_db.list)


## Find non-empty logs
find Logs -type f ! -size 0 

## Mauve logs
mv Logs Logs18
