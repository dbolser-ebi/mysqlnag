#!/bin/bash

CMD1=$1
CMD2=$2

CMD1=${CMD1:?plz pass a mysql cmd to sync from plz}
CMD2=${CMD2:?plz pass a mysql cmd to sync  to  plz}

DB1=$3
DB2=$4

DB1=${DB1:?plz pass a database to sync plz}
DB2=${DB2:-${DB1}}

echo "FROM DATABASE: '$CMD1.$DB1'"
echo " TO  DATABASE: '$CMD2.$DB2'"



## Other example options

## Misc
   # --no-dump \
   # --verbose \

## Methods
   # --date \
   # --checksum \
   # --count \
   # --force \

   # --table transcript_variation \

   # --skip-table temp_individual_genotype_gg \
   # --skip-table temp_individual_genotype_tt \
   # --skip-table temp_individual_genotype_ax \
   # --skip-table temp_individual_genotype_a1 \
   # --skip-table temp_individual_genotype \

time \
  ./bin/mysqlnag --dir Logs --verbose \
    --checksum \
    $($CMD1 --details script)              --database $DB1 \
    $($CMD2 --details script_target) --targetdatabase $DB2

## Finish here because we have notes below
exit 0



## Here is a dumb 'multiple' run:

list=~/Plants/plant_list-28.txt
list=~/Plants/plant_list-29.txt

time \
  while read -r db; do
    time \
        ./nagwrap2.sh \
          mysql-staging-1 \
          mysql-prod-2-ensrw \
          $db &
    echo
done \
    < <( grep _core_ $list | grep -v thaliana | grep -v aestivum )





## Here is how to run it over a list with release version
## renaming. NOTE, we rename from OLD to NEW, so you only need the db
## list from the LAST release.

# The list we use is the *previous* release...
list=~/Plants/plant_list-26.txt
logs=migrate_to_27.log

source=mysql-staging-2
target=mysql-staging-1-ensrw

source=mysql-staging-1
target=mysql-prod-2-ensrw

time \
  while read -r old_db; do
   #new_db=${old_db/_24_77_/_25_78_}
   #new_db=${old_db/_25_78_/_26_79_}
    new_db=${old_db/_26_79_/_27_80_}
    
    echo Doing FROM $old_db;
    echo Doing . TO $new_db;
    
    time \
        ./nagwrap2.sh \
        $source \
        $target \
        $old_db \
        $new_db &
    
    echo
    echo
    echo
    
done \
    < ${list} &> ${logs}

## Find non-empty logs
find Logs -type f ! -size 0 

