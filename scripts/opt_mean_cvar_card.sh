#!/bin/bash

set -e

DIR="$1"
NAME="$2"
GENERATIONS="$3"
POP_SIZE="$4"
CARD="$5"
BETA="$6"

printf "Optimizing portfolios utilizing the Mean-CVaR Cardinality model\n"

sed -i "1 s:MCvarCardFit(.*) [0-9]*:MCvarCardFit(\"${DIR}/assets_data\",${CARD},${BETA}) ${POP_SIZE}:" FitFuns/MCvarCardinality
julia main.jl MCvarCardinality port MULTI $GENERATIONS 1 1
printf "\nGenerated portfolios (port.ind, port.fit)\n"

mkdir -p "${DIR}/portfolio_data/${NAME}"
mv port.fit port.ind "${DIR}/portfolio_data/${NAME}"