#!/bin/bash

## TODO: Merge with nagwrap.sh

DB=$1

${DB:?pass a database to sync plz}

echo "DATABASE: '$DB'"



## SOURCE database (ensro, not ensrw)

#S_DB=( $( mysql-cluster-production-1  details ) )
 S_DB=( $( mysql-staging-1             details ) )
#S_DB=( $( mysql-devel-2               details ) )


## TARGET database (ensrw, not admin)

#T_DB=( $( mysql-devel-2-ensrw              details ) )
#T_DB=( $( mysql-cluster-production-1-ensrw details ) )
#T_DB=( $( mysql-staging-1-ensrw            details ) )
 T_DB=( $( mysql-devel-2-ensrw              details ) )


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

# echo "FROM '$S_HOST' '$S_PORT' '$S_USER' '$S_PASS' OK"
# echo "TO   '$T_HOST' '$T_PORT' '$T_USER' '$T_PASS' OK"
# exit


## RUN

time \
    mysqlnaga-sync \
    --use-naga \
    --checksum \
    --directory Data \
    --database $DB \
    \
    --host       $S_HOST --port       $S_PORT \
    --user       $S_USER \
    --targethost $T_HOST --targetport $T_PORT \
    --targetuser $T_USER --targetpass $T_PASS


#--pass       $S_PASS \
