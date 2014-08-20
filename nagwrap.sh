#!/bin/bash

DB1=$1
DB2=$2

DB1=${DB1:?plz pass a database to sync plz}
DB2=${DB2:-${DB1}}

echo "FROM DATABASE: '$DB1'"
echo " TO  DATABASE: '$DB2'"



## SOURCE database details (ensro, not ensrw)

#S_DB=( $( mysql-eg-mirror         details ) )
 S_DB=( $( mysql-staging-1         details ) )
#S_DB=( $( mysql-staging-2         details ) )
#S_DB=( $( mysql-staging-pre       details ) )
#S_DB=( $( mysql-devel-1           details ) )
#S_DB=( $( mysql-devel-2           details ) )
#S_DB=( $( mysql-devel-3           details ) )
#S_DB=( $( mysql-prod-1            details ) )
#S_DB=( $( mysql-prod-2            details ) )
#S_DB=( $( mysql-prod-3            details ) )



## TARGET database details (ensrw, not admin)

#T_DB=( $( mysql-staging-1-ensrw   details ) )
 T_DB=( $( mysql-staging-2-ensrw   details ) )
#T_DB=( $( mysql-staging-pre-ensrw details ) )
#T_DB=( $( mysql-devel-1-ensrw     details ) )
#T_DB=( $( mysql-devel-2-ensrw     details ) )
#T_DB=( $( mysql-devel-3-ensrw     details ) )
#T_DB=( $( mysql-prod-1-ensrw      details ) )
#T_DB=( $( mysql-prod-2-ensrw      details ) )
#T_DB=( $( mysql-prod-3-ensrw      details ) )

#T_DB=( $( mysql-vmtest-ensrw      details ) )
#T_DB=( $( mysql-enaprod-ensrw     details ) )



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
TO="--targethost=$T_HOST --targetport=$T_PORT --targetuser=$T_USER \
                                              --targetpassword=$T_PASS"

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
   # --table assembly \
   # --table coord_system \
   # --table meta \
   # --table seq_region \
   # --table mapping_set \
   # --table assembly_exception \
   # --table seq_region_attrib \
   # --table attrib_type \

## Used to dump XREFs (transcript and gene?)
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

## Just dump GO XREFs?
   # --table ontology_xref \
   # --table object_xref \
   # --table xref \

## Used to dump repeat feature pipeline
   # --table repeat_feature \
   # --table simple_feature \
   # --table repeat_consensus \
   # --table meta_coord \
   # --table analysis \

## Used to dump InterProScan
   # --table protein_feature \

time \
  ./bin/mysqlnag \
    --dir Logs \
    --verbose \
    --checksum \
    $FROM     --database $DB1 \
    $TO --targetdatabase $DB2

## Finish here because we have notes below
exit 0



## Usefull query?

while read -r from_db; do
    mysql-staging-1 $from_db \
        -Ne 'SELECT MAX(UPDATE_TIME), DATABASE()
             FROM information_schema.TABLES
             WHERE TABLE_SCHEMA = DATABASE()'
done \
    < <(grep _core_ plant_19_db.list)



## Here is how to run it over a list...

list=plant_21_db.list

time \
while read -r from_db; do
    echo Doing $from_db;
    
    time ./nagwrap.sh $from_db
    
    echo
    echo
done \
    < <(grep _core_ ${list})



## Here is how to run it over a list with release version renaming

# The list we use is the *next* release...
list=plant_24_db.list
logs=plant_24_db.log

time \
while read -r new_db; do
    #old_db=${new_db/_19_72_/_18_71_}
    #old_db=${new_db/_20_73_/_19_72_}
    #old_db=${new_db/_21_74_/_20_73_}
    #old_db=${new_db/_22_75_/_21_74_}
    #old_db=${new_db/_23_76_/_22_75_}
     old_db=${new_db/_24_77_/_23_76_}
    
    echo Doing FROM $old_db;
    echo Doing  TO  $new_db;
    
    time \
        ./nagwrap.sh $old_db $new_db
    
    echo
    echo
    echo
    
done \
    < ${list} &> ${logs}

## Find non-empty logs
find Logs -type f ! -size 0 









# The list we use is the *previous* release...
list=plant_22_db.list
logs=plant_23_db.log

time \
while read -r old_db; do
    new_db=${old_db/_22_75_/_23_76_}
    
    echo Doing FROM $old_db;
    echo Doing . TO $new_db;
    
    time \
        ./nagwrap.sh $old_db $new_db &
    
    echo
    echo
    echo
    
done \
    < ${list} &> ${logs}

