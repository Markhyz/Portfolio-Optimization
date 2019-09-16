#!/bin/bash

set -e

DIR="$1"
NAME="$2"
START_YEAR="$3"
END_YEAR="$4"

PERIOD_DIR="${DIR}/${START_YEAR}_${END_YEAR}"

if [ $START_YEAR -eq $END_YEAR ]
then
  PERIOD_DIR="${DIR}/${START_YEAR}"
fi

printf "Generating data for the period beginning on ${START_YEAR} and ending on ${END_YEAR}\n"

printf "\nGenerating benchmark data\n"

mkdir -p "${PERIOD_DIR}/benchmark_data"
rm -f "${PERIOD_DIR}/benchmark_data/*"
python "${DIR}/scripts/gen_asset_data.py" "${DIR}/assets/index" "${PERIOD_DIR}/benchmark_data" "${START_YEAR}-01-01" "${END_YEAR}-12-31"
rm -f "${PERIOD_DIR}/benchmark_data/^BVSP.in"
printf "Generated ibovespa data (^BVSP.inp)\n"

python "${DIR}/scripts/gen_cdi_data.py" "${DIR}/benchmarks/cdi.xls" "${PERIOD_DIR}/benchmark_data/cdi.inp" "${START_YEAR}-01-01" "${END_YEAR}-12-31"
printf "Generated cdi data (cdi.inp)\n"

python "${DIR}/scripts/gen_benchmark_returns.py" "${PERIOD_DIR}/benchmark_data" "${PERIOD_DIR}/benchmark_data" "${START_YEAR}-01-01" "${END_YEAR}-12-31"

printf "\nGenerating benchmark plot\n"
mkdir -p "${PERIOD_DIR}/plot_data/${NAME}"

python "${DIR}/scripts/gen_plot_data.py" "${PERIOD_DIR}/benchmark_data/^BVSP.ret" "${PERIOD_DIR}/plot_data/${NAME}/bvsp.dat" Ibovespa
printf "Generated ibovespa plot (bvsp.dat)\n"

python "${DIR}/scripts/gen_plot_data.py" "${PERIOD_DIR}/benchmark_data/cdi.ret" "${PERIOD_DIR}/plot_data/${NAME}/cdi.dat" CDI
printf "Generated cdi plot (cdi.dat)\n"