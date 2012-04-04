#!/bin/bash

## TODO: Merge naga_x_to_y.sh bash code here

FROM="      --host=mysql-eg-staging-2.ebi.ac.uk            --port=4275       --user=ensro"
TO="  --targethost=mysql-cluster-eg-prod-1.ebi.ac.uk --targetport=4238 --targetuser=ensrw --targetpassword=writ3rp1"

while read -r db; do
    echo Doing $db;
    
##        --verbose --no-dump \
##        --checksum \
##        --count \
    
    time \
      ./bin/mysqlnag --verbose --table xref --table object_xref \
        --dir Logs \
        --date \
        ${FROM} \
        --database ${db} \
        \
        ${TO} \
        --targetdatabase ${db}
    
    break
    
    echo
    echo
done \
    < <(grep core plant_14_db.list)


