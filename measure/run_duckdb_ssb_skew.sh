#!/bin/bash

if [ -z "$1" ]; then
  echo "Please enter Official or QuerySplit!"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Please enter scale factor to choose the correct database!"
  exit 1
fi

#rm -f ./ssb_skew_$2.db
#
#cd ../ && make clean && GEN=ninja VERBOSE=1 make 2>&1|tee -a compile.log && cd measure
#
## create schema
#echo "create ssb_skew schema"
#echo -ne ".read create_tables.sql" | duckdb ./ssb_skew_$2.db
#
## load ssb_skew
#for table in customer_address customer_demographics date_dim warehouse ship_mode time_dim reason income_band item store call_center customer web_site store_returns household_demographics web_page promotion catalog_page inventory catalog_returns web_returns web_sales catalog_sales store_sales 
#do
#  echo "duckdb load table from ${table}.tbl"
#  if [ "$2" -eq 10 ]; then
#    command="copy ${table} from '/home/pei/Project/benchmarks/ssb_skew-postgres/code/tools/out/csv/${table}.csv' (quote '\"', escape '\\');"
#  elif [ "$2" -eq 100 ]; then
#    command="copy ${table} from '/home/pei/Project/benchmarks/ssb_skew-postgres/code/tools/out_100/csv/${table}.csv' (quote '\"', escape '\\');"
#  else
#    echo "Please enter a correct scale factor 10/100, or check the csv file path!"
#  fi
#  echo $command
#  echo -ne "${command}" | duckdb ./ssb_skew_$2.db
#done


# execute queries
dir="/home/pei/Project/benchmark/ssb-skew-duckdb/ssb-skew/queries"
iteration=1

log_name=duckdb_result_ssb_skew_$2_$1.txt

rm -rf ${log_name}
rm -rf ssb_skew_$2_result/${log_name}
mkdir -p ssb_skew_$2_result/

for i in $(eval echo {1.."${iteration}"}); do
  for sql in "${dir}"/*.sql; do
    echo "execute ${sql}" 2>&1|tee -a ${log_name};
    echo -ne ".read ${sql}" | duckdb ./ssb_skew_$2.db 2>&1|tee -a ${log_name};
  done
done

mv ${log_name} ssb_skew_$2_result/.

