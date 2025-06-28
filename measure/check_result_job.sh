#!/bin/bash

echo "official" 2>&1|tee -a compile.log
cd ../ && make clean && GEN=ninja VERBOSE=1 make 2>&1|tee -a compile.log && cd measure && bash ./run_duckdb_job.sh official

# enable polar
sed -i 's/bool enable_polr = false;/bool enable_polr = true;/' ../src/include/duckdb/main/client_config.hpp
sed -i 's/bool bushy_polr = false;/bool bushy_polr = true;/' ../src/include/duckdb/main/client_config.hpp

echo "polar" 2>&1|tee -a compile.log
cd ../ && make clean && GEN=ninja VERBOSE=1 make 2>&1|tee -a compile.log && cd measure && bash ./run_duckdb_job.sh polar

diff job_result/duckdb_job_result_official.txt job_result/duckdb_job_result_polar.txt 2>&1 | tee job_polar_diff.log

# reset
sed -i 's/bool enable_polr = true;/bool enable_polr = false;/' ../src/include/duckdb/main/client_config.hpp
sed -i 's/bool bushy_polr = true;/bool bushy_polr = false;/' ../src/include/duckdb/main/client_config.hpp
