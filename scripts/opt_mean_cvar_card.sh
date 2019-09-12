#!/bin/bash

set -e

DIR="$1"
GENERATIONS="$2"
POP_SIZE="$3"
CARD="$4"
BETA="$5"

printf "Optimizing portfolios utilizing the Mean-CVaR Cardinality model\n"

sed -i "1 s:MCvarCardFit(.*) [0-9]*:MCvarCardFit(\"${DIR}/assets_data\",${CARD},${BETA}) ${POP_SIZE}:" FitFuns/MCvarCardinality
julia main.jl MCvarCardinality port MULTI $GENERATIONS 1 1
printf "\nGenerated portfolios (port.ind, port.fit)\n"

mkdir -p "${DIR}/portfolio_data"
mv port.fit port.ind "${DIR}/portfolio_data"