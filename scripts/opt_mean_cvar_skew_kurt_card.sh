#!/bin/bash

set -e

DIR="$1"
NAME="$2"
GENERATIONS="$3"
POP_SIZE="$4"
CARD="$5"
BETA="$6"

printf "Optimizing portfolios utilizing the Mean-CVaR-Skewness-Kurtosis Cardinality model\n"

sed -i "1 s:MCVaRSkewKurtCardFit(.*) [0-9]*:MCVaRSkewKurtCardFit(\"${DIR}/assets_data\",${CARD},${BETA}) ${POP_SIZE}:" FitFuns/MCvarSkewKurtCard
julia main.jl MCvarSkewKurtCard port MULTI $GENERATIONS 1 1
printf "\nGenerated portfolios (port.ind, port.fit)\n"

mkdir -p "${DIR}/portfolio_data/${NAME}"
mv port.fit port.ind "${DIR}/portfolio_data/${NAME}"