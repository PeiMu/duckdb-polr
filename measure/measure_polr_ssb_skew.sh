#!/bin/bash

if [ -z "$1" ]; then
  echo "Please enter scale factor to choose the correct database!"
  exit 1
fi

mkdir -p ssb_skew_$1_result/
rm -rf compile.log

echo "official" 2>&1|tee -a compile.log
cd ../ && make clean && GEN=ninja VERBOSE=1 make >> compile.log 2>&1 && cd measure && bash ./hyperfine_in_mem_ssb_skew.sh official nan $1

# enable polar
sed -i 's/bool enable_polr = false;/bool enable_polr = true;/' ../src/include/duckdb/main/client_config.hpp
sed -i 's/bool bushy_polr = false;/bool bushy_polr = true;/' ../src/include/duckdb/main/client_config.hpp

echo "polr" 2>&1|tee -a compile.log
cd ../ && make clean && GEN=ninja VERBOSE=1 make >> compile.log 2>&1 && cd measure && bash ./hyperfine_in_mem_ssb_skew.sh polr nan $1

mv compile.log ssb_skew_$1_result/.

# reset
sed -i 's/bool enable_polr = true;/bool enable_polr = false;/' ../src/include/duckdb/main/client_config.hpp
sed -i 's/bool bushy_polr = true;/bool bushy_polr = false;/' ../src/include/duckdb/main/client_config.hpp
