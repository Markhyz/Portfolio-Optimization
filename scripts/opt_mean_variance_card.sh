#!/bin/bash

set -e

DIR="$1"
NAME="$2"
GENERATIONS="$3"
POP_SIZE="$4"
CARD="$5"
printf "Optimizing portfolios utilizing the Mean-Variance Cardinality model\n"

sed -i "1 s:MeanVarianceCardFit(.*) [0-9]*:MeanVarianceCardFit(\"${DIR}/assets_data\",${CARD}) ${POP_SIZE}:" FitFuns/MeanVarianceCard
julia main.jl MeanVarianceCard port MULTI $GENERATIONS 1 1
printf "\nGenerated portfolios (port.ind, port.fit)\n"

mkdir -p "${DIR}/portfolio_data/${NAME}"
mv port.fit port.ind "${DIR}/portfolio_data/${NAME}"