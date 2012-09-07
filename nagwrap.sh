#!/bin/bash

DB1=$1
DB2=$2

DB1=${DB1:?plz pass a database to sync plz}
DB2=${DB2:-${DB1}}

echo "FROM DATABASE: '$DB1'"
echo " TO  DATABASE: '$DB2'"



## SOURCE database details (ensro, not ensrw)

#S_DB=( $( mysql-staging-1                  details ) )
 S_DB=( $( mysql-staging-2                  details ) )
#S_DB=( $( mysql-staging-pre                details ) )
#S_DB=( $( mysql-devel-1                    details ) )
#S_DB=( $( mysql-devel-2                    details ) )
#S_DB=( $( mysql-cluster-production-1       details ) )
#S_DB=( $( mysql-cluster-production-2       details ) )
#S_DB=( $( mysql-cluster-production-3       details ) )



## TARGET database details (ensrw, not admin)

#T_DB=( $( mysql-staging-1-ensrw            details ) )
#T_DB=( $( mysql-staging-2-ensrw            details ) )
#T_DB=( $( mysql-staging-pre-ensrw          details ) )
#T_DB=( $( mysql-devel-1-ensrw              details ) )
#T_DB=( $( mysql-devel-2-ensrw              details ) )
 T_DB=( $( mysql-cluster-production-1-ensrw details ) )
#T_DB=( $( mysql-cluster-production-2-ensrw details ) )
#T_DB=( $( mysql-cluster-production-3-ensrw details ) )



## Assign variables from the above 'details'

## These indexes differ from the below because 'ensro' has a different
## number of arguments...
S_HOST=${S_DB[4]}; S_PORT=${S_DB[6]}; S_USER=${S_DB[8]}

## These indexes differ from the above because 'ensrw' has a different
## number of arguments...
T_HOST=${T_DB[5]}; T_PORT=${T_DB[7]}; T_USER=${T_DB[9]}; T_PASS=${T_DB[11]}

## Debugging
# echo "FROM '$S_HOST' '$S_PORT' '$S_USER'"
# echo "TO   '$T_HOST' '$T_PORT' '$T_USER' '$T_PASS'"



## RUN

## Simplify cli
FROM="    --host=$S_HOST       --port=$S_PORT       --user=$S_USER"
TO="--targethost=$T_HOST --targetport=$T_PORT --targetuser=$T_USER --targetpassword=$T_PASS"

## Other example options

#    --date \
#    --checksum \
#    --count \
#    --force \

#    --no-dump \
#    --table meta \

time \
  ./bin/mysqlnag \
    --dir Logs \
    --verbose \
    --count \
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
    < <(grep core plant_16_db.list)



time \
while read -r to_db; do
    from_db=${to_db/_16_69_/_15_68_}
    
    echo Doing $from_db;
    echo Doing $to_db;
    
    time \
        ./nagwrap.sh $from_db $to_db
    
    echo
    echo
    echo
    
done \
    < <(grep core plant_16_db.list)

    < <(grep funcgen plant_16_db.list)
    < <(grep variation plant_16_db.list)
    < <(grep otherfeatures plant_16_db.list)




