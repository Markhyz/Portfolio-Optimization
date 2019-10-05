#!/bin/bash

set -e

DIR="$1"
NAME="$2"
PORTFOLIO_DIR="$3"
START_YEAR="$4"
END_YEAR="$5"
RISK_RATE="$6"

PERIOD_DIR="${DIR}/${START_YEAR}_${END_YEAR}"

if [ $START_YEAR -eq $END_YEAR ]
then
  PERIOD_DIR="${DIR}/${START_YEAR}"
fi

printf "Generating selected risk rate portfolio return\n"

python "${DIR}/scripts/select_portfolio_return.py" \
       "${PORTFOLIO_DIR}/portfolio_data/${NAME}/port.ind" "${PORTFOLIO_DIR}/portfolio_data/${NAME}/port.fit" $RISK_RATE \
       "${PERIOD_DIR}/assets_data" "${PERIOD_DIR}/portfolio_data" "${START_YEAR}-01-01" "${END_YEAR}-12-31"

mkdir -p "${PORTFOLIO_DIR}/plot_data"

python "${DIR}/scripts/gen_plot_data.py" "${PERIOD_DIR}/portfolio_data/selected_portfolio.ret" "${PERIOD_DIR}/plot_data/${NAME}/selected_portfolio.dat" Selecionado
printf "Generated selected portfolio (selected_portfolio.dat)\n"
