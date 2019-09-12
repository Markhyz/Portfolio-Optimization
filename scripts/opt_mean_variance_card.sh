#!/bin/bash

set -e

DIR="$1"
GENERATIONS="$2"
POP_SIZE="$3"
CARD="$4"
printf "Optimizing portfolios utilizing the Mean-Variance Cardinality model\n"

sed -i "1 s:MeanVarianceCardFit(.*) [0-9]*:MeanVarianceCardFit(\"${DIR}/assets_data\",${CARD}) ${POP_SIZE}:" FitFuns/MeanVarianceCard
julia main.jl MeanVarianceCard port MULTI $GENERATIONS 1 1
printf "\nGenerated portfolios (port.ind, port.fit)\n"

mkdir -p "${DIR}/portfolio_data"
mv port.fit port.ind "${DIR}/portfolio_data"