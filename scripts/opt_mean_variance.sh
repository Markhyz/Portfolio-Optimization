#!/bin/bash

set -e

DIR="$1"
NAME="$2"
GENERATIONS="$3"
POP_SIZE="$4"
CARD="$5"
BETA="$6"

printf "Optimizing portfolios utilizing the Mean-Variance model\n"

sed -i "1 s:MeanVarianceFit(.*) [0-9]*:MeanVarianceFit(\"${DIR}/assets_data\") ${POP_SIZE}:" FitFuns/MeanVariance
julia main.jl MeanVariance port MULTI $GENERATIONS 1 1
printf "\nGenerated portfolios (port.ind, port.fit)\n"

mkdir -p "${DIR}/portfolio_data/${NAME}"
mv port.fit port.ind "${DIR}/portfolio_data/${NAME}"