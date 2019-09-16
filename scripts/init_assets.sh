#!/bin/bash

set -e

DIR="$1"
ASSETS_DIR="$2"
IN_START_YEAR="$3"
IN_END_YEAR="$4"
OUT_START_YEAR="$5"
OUT_END_YEAR="$6"

IN_PERIOD_DIR="${DIR}/${IN_START_YEAR}_${IN_END_YEAR}"

if [ $IN_START_YEAR -eq $IN_END_YEAR ]
then
  IN_PERIOD_DIR="${DIR}/${IN_START_YEAR}"
fi

OUT_PERIOD_DIR="${DIR}/${OUT_START_YEAR}_${OUT_END_YEAR}"

if [ $OUT_START_YEAR -eq $OUT_END_YEAR ]
then
  OUT_PERIOD_DIR="${DIR}/${OUT_START_YEAR}"
fi

printf "Generating data for the period beginning on ${IN_START_YEAR} and ending on ${OUT_END_YEAR}\n"

printf "\nGenerating assets data\n"

mkdir -p "${IN_PERIOD_DIR}/assets_data"
rm -f "${IN_PERIOD_DIR}/assets_data/*"
mkdir -p "${OUT_PERIOD_DIR}/assets_data"
rm -f "${OUT_PERIOD_DIR}/assets_data/*"
python "${DIR}/scripts/gen_assets_data.py" $ASSETS_DIR "${IN_PERIOD_DIR}/assets_data" "${IN_START_YEAR}-01-01" "${IN_END_YEAR}-12-31" "${OUT_PERIOD_DIR}/assets_data" "${OUT_START_YEAR}-01-01" "${OUT_END_YEAR}-12-31"