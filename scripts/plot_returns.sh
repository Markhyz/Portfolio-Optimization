#!/bin/bash

set -e

DIR="$1"
PORTFOLIO_DIR="$2"
NAME="$3"
START_YEAR="$4"
END_YEAR="$5"

PERIOD_DIR="${DIR}/${START_YEAR}_${END_YEAR}"

if [ $START_YEAR -eq $END_YEAR ]
then
  PERIOD_DIR="${DIR}/${START_YEAR}"
fi

printf "Generating portfolio returns\n"

mkdir -p "${PERIOD_DIR}/portfolio_data"

python "${DIR}/scripts/gen_portfolio_returns.py" \
       "${PORTFOLIO_DIR}/portfolio_data/${NAME}/port.ind" "${PORTFOLIO_DIR}/portfolio_data/${NAME}/port.fit" \
       "${PERIOD_DIR}/assets_data" "${PERIOD_DIR}/portfolio_data" "${START_YEAR}-01-01" "${END_YEAR}-12-31"

mkdir -p "${PERIOD_DIR}/plot_data/${NAME}"

printf "\nGenerating portfolios plot data\n"
python "${DIR}/scripts/gen_plot_data.py" "${PERIOD_DIR}/portfolio_data/balanced_portfolio.ret" "${PERIOD_DIR}/plot_data/${NAME}/balanced_portfolio.dat" Balanceado
printf "Generated best performance portfolio (balanced_portfolio.dat)\n"
python "${DIR}/scripts/gen_plot_data.py" "${PERIOD_DIR}/portfolio_data/risky_portfolio.ret" "${PERIOD_DIR}/plot_data/${NAME}/risky_portfolio.dat" Arriscado
printf "Generated most return portfolio (risky_portfolio.dat)\n"
python "${DIR}/scripts/gen_plot_data.py" "${PERIOD_DIR}/portfolio_data/safe_portfolio.ret" "${PERIOD_DIR}/plot_data/${NAME}/safe_portfolio.dat" Seguro
printf "Generated lowest risk portfolio (safe_portfolio.dat)\n"

python "${DIR}/scripts/plot_returns.py" "${PERIOD_DIR}/plot_data/${NAME}"
printf "\nGenerated returns plot\n"

cd "${PERIOD_DIR}/plot_data/${NAME}"
gnuplot returns.plot > returns.png