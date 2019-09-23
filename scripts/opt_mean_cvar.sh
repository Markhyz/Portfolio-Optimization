#!/bin/bash

set -e

DIR="$1"
NAME="$2"
GENERATIONS="$3"
POP_SIZE="$4"
BETA="$5"

printf "Optimizing portfolios utilizing the Mean-CVaR model\n"

sed -i "1 s:MeanCvarFit(.*) [0-9]*:MeanCvarFit(\"${DIR}/assets_data\",${BETA}) ${POP_SIZE}:" FitFuns/MeanCvar
julia main.jl MeanCvar port MULTI $GENERATIONS 1 1
printf "\nGenerated portfolios (port.ind, port.fit)\n"

mkdir -p "${DIR}/portfolio_data/${NAME}"
mv port.fit port.ind "${DIR}/portfolio_data/${NAME}"