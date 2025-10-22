#!/bin/bash

if [ -z "$1" ]; then
  echo "Please enter scale factor to choose the correct database!"
  exit 1
fi

echo "Official" 2>&1|tee -a compile.log
cd ../ && make clean && GEN=ninja VERBOSE=1 make 2>&1|tee -a compile.log && cd measure && bash ./run_duckdb_ssb_skew.sh Official $1

# enable polar
sed -i 's/bool enable_polr = false;/bool enable_polr = true;/' ../src/include/duckdb/main/client_config.hpp
sed -i 's/bool bushy_polr = false;/bool bushy_polr = true;/' ../src/include/duckdb/main/client_config.hpp

echo "Polar" 2>&1|tee -a compile.log
cd ../ && make clean && GEN=ninja VERBOSE=1 make 2>&1|tee -a compile.log && cd measure && bash ./run_duckdb_ssb_skew.sh polr $1

diff ssb_skew_$1_result/duckdb_result_ssb_skew_$1_Official.txt ssb_skew_$1_result/duckdb_result_ssb_skew_$1_polr.txt 2>&1 | tee ssb_skew_$1_polr_diff.log

# reset
sed -i 's/bool enable_polr = true;/bool enable_polr = false;/' ../src/include/duckdb/main/client_config.hpp
sed -i 's/bool bushy_polr = true;/bool bushy_polr = false;/' ../src/include/duckdb/main/client_config.hpp
