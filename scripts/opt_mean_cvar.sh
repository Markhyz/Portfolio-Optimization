#!/bin/bash

set -e

DIR="$1"
GENERATIONS="$2"
POP_SIZE="$3"
BETA="$4"

printf "Optimizing portfolios utilizing the Mean-CVaR model\n"

sed -i "1 s:MeanCvarFit(.*) [0-9]*:MeanCvarFit(\"${DIR}/assets_data\",${BETA}) ${POP_SIZE}:" FitFuns/MeanCvar
julia main.jl MeanCvar port MULTI $GENERATIONS 1 1
printf "\nGenerated portfolios (port.ind, port.fit)\n"

mkdir -p "${DIR}/portfolio_data"
mv port.fit port.ind "${DIR}/portfolio_data"