push!(LOAD_PATH, ".")
push!(LOAD_PATH, "../Genetic Algorithm")

using GeneticAlgorithm
using RealIndividual
using FitFuns
using Fitness
using Plots

function evalLine(line::String)
  evaluated_line = map(x -> eval(Meta.parse(x)), split(line))
  unpacked_line = Tuple(foldl((x, y) -> y isa Tuple ? push!(x, y...) : push!(x, y), evaluated_line; init=[]))
  return Tuple(unpacked_line)
end

function readArgs(filename::String)
  open(filename, "r") do file
    opt_algo, it, log = evalLine(readline(file))
    ind_args = evalLine(readline(file))
    fit_fun, pop_size, elite_size = evalLine(readline(file))
    init_args = evalLine(readline(file))
    sel_args = evalLine(readline(file))
    cross_args = evalLine(readline(file))
    mut_args = evalLine(readline(file))
    return opt_algo, it, log, ind_args, fit_fun, pop_size, elite_size, init_args, sel_args, cross_args, mut_args
  end
end

function main(args)
  opt_alg, it, log, ind_args, fit_fun, pop_size, elite_size, init_args, sel_args, cross_args, mut_args = readArgs("FitFuns/$(args[1])")
  ga = GeneticAlgorithm.GeneticAlgorithmType(ind_args, fit_fun, pop_size, elite_size;
                                            init_args = init_args,
                                            sel_args = sel_args,
                                            cross_args = cross_args,
                                            mut_args = mut_args)
  gr()
  if opt_alg == "SINGLE"
    best_fit, mean_fit = GeneticAlgorithm.evolveSO!(ga, it, log)
    plot(1:it, [best_fit, mean_fit], xlims=(1, it), label=["Best" "Mean"], xlabel="Generation", ylabel="Fitness", legend=:bottomright)
  elseif opt_alg == "MULTI"
    best_solutions = GeneticAlgorithm.evolveNSGA2!(ga, it, log)
    scatter([x .* Fitness.getDirection(fit_fun) for x in getindex.(best_solutions, 2)], label=["Frontier"], markersize=1)
  end
  savefig("FitFuns/$(args[1])_fitness.png")
end

main(ARGS)