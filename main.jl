push!(LOAD_PATH, ".")

using Optimizer

input = ARGS[1]
output = ARGS[2]
algorithm = ARGS[3]
iterations = parse(Int64, ARGS[4])
log = parse(Int64, ARGS[5])
loop = parse(Int64, ARGS[6])

Optimizer.optimize(input, output, algorithm, iterations, log)