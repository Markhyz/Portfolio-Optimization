#!/bin/bash

set -e

DIR="$1"
ASSETS_DIR="$2"
START_YEAR="$3"
END_YEAR="$4"

PERIOD_DIR="${DIR}/${START_YEAR}_${END_YEAR}"

if [ $START_YEAR -eq $END_YEAR ]
then
  PERIOD_DIR="${DIR}/${START_YEAR}"
fi

printf "Generating data for the period beginning on ${START_YEAR} and ending on ${END_YEAR}\n"

printf "\nGenerating assets data\n"

mkdir -p "${PERIOD_DIR}/assets_data"
rm -f "${PERIOD_DIR}/assets_data/*"
python "${DIR}/scripts/gen_assets_data.py" $ASSETS_DIR "${PERIOD_DIR}/assets_data" "${START_YEAR}-01-01" "${END_YEAR}-12-31"