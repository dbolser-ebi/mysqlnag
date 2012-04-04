#!/bin/bash

DB1=$1
DB2=$2

DB1=${DB1:?plz pass a database to sync plz}
DB2=${DB2:-${DB1}}

echo "FROM DATABASE: '$DB1'"
echo " TO  DATABASE: '$DB2'"

## SOURCE database details (ensro, not ensrw)

#S_DB=( $( mysql-cluster-production-1  details ) )
#S_DB=( $( mysql-staging-1             details ) )
 S_DB=( $( mysql-devel-2               details ) )


## TARGET database details (ensrw, not admin)

#T_DB=( $( mysql-devel-2-ensrw              details ) )
#T_DB=( $( mysql-cluster-production-1-ensrw details ) )
#T_DB=( $( mysql-staging-1-ensrw            details ) )
 T_DB=( $( mysql-staging-pre-ensrw          details ) )


## Assign variables from the above 'details'

## These indexes differ from the below because 'ensro' has a different
## number of arguments!
S_HOST=${S_DB[4]}
S_PORT=${S_DB[6]}
S_USER=${S_DB[8]}
S_PASS=${S_DB[10]}

## These indexes differ from the above because 'ensrw' has a different
## number of arguments.
T_HOST=${T_DB[5]}
T_PORT=${T_DB[7]}
T_USER=${T_DB[9]}
T_PASS=${T_DB[11]}

#echo "FROM '$S_HOST' '$S_PORT' '$S_USER' '$S_PASS' OK"
#echo "TO   '$T_HOST' '$T_PORT' '$T_USER' '$T_PASS' OK"
#exit



## RUN



time \
  ./bin/mysqlnag --verbose --dir Logs \
    --date \
    ${FROM}     --database $DB1 \
    ${TO} --targetdatabase $DB2








# while read -r db; do
#     echo Doing $db;
# ##        --verbose --no-dump \
# ##        --checksum \
# ##        --count \
#     time \
#       ./bin/mysqlnag --verbose --table xref --table object_xref \
#         --dir Logs \
#         --date \
#         ${FROM} \
#         --database ${db} \
#         \
#         ${TO} \
#         --targetdatabase ${db}
#     break
#     echo
#     echo
# done \
#     < <(grep core plant_14_db.list)


