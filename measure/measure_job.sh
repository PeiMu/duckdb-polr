#!/bin/bash

mkdir -p job_result/
rm -rf compile.log

echo "official" 2>&1|tee -a compile.log
cd ../ && make clean && GEN=ninja VERBOSE=1 make >> compile.log 2>&1 && cd measure && bash ./hyperfine_in_mem_job.sh official nan

# enable polar
sed -i 's/bool enable_polr = false;/bool enable_polr = true;/' ../src/include/duckdb/main/client_config.hpp
sed -i 's/bool bushy_polr = false;/bool bushy_polr = true;/' ../src/include/duckdb/main/client_config.hpp

cd ../ && make clean && GEN=ninja VERBOSE=1 make >> compile.log 2>&1 && cd measure && bash ./hyperfine_in_mem_job.sh polr nan

mv compile.log job_result/.

# reset
sed -i 's/bool enable_polr = true;/bool enable_polr = false;/' ../src/include/duckdb/main/client_config.hpp
sed -i 's/bool bushy_polr = true;/bool bushy_polr = false;/' ../src/include/duckdb/main/client_config.hpp
