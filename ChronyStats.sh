#!/bin/bash

for HOST in $( chronyc -n sources | egrep -v "MS|===|0ns$" | awk '{ print $2 }' )
do
   AVG=$( grep ${HOST} ../statistics.log | tail -100 | awk '{ sum += $5 } END { if (sum < 0) { sum = -sum } ; print sum / NR }' )
   NAME=$( getent hosts ${HOST} | awk '{ print $2 }' )
   echo ${AVG} ${NAME} ${HOST}
done | sort -k 1,1g > mystatistics.sort

logrotate --force --verbose ./logrotate.conf

for FILE in mystatistics.sort.*
do
    awk '{ print $2 }' ${FILE} > $( echo ${FILE} | sed -e 's/sort/rank/g' )
done
