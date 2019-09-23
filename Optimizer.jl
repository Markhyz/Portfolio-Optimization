push!(LOAD_PATH, ".")
push!(LOAD_PATH, "../Genetic Algorithm")

module Optimizer

using GeneticAlgorithm
using RealChromosome
using BinaryChromosome
using CardinalityChromosome
using FitFuns
using Fitness
using Plots
using Printf

function evalLine(line::String)
  evaluated_line = map(x -> eval(Meta.parse(x)), split(line))
  unpacked_line = Tuple(foldl((x, y) -> y isa Tuple ? push!(x, y...) : push!(x, y), evaluated_line; init=[]))
  return Tuple(unpacked_line)
end

function readArgs(filename::String)
  open(filename, "r") do file
    fit_fun, pop_size, elite_size = evalLine(readline(file))
    sel_args = evalLine(readline(file))
    chromo_num = evalLine(readline(file))[1]
    ind_args = Array{Any}(undef, chromo_num)
    init_args = Array{Any}(undef, chromo_num)
    cross_args = Array{Any}(undef, chromo_num)
    mut_args = Array{Any}(undef, chromo_num)
    for i = 1 : chromo_num
      ind_args[i] = evalLine(readline(file))
      init_args[i] = evalLine(readline(file))
      cross_args[i] = evalLine(readline(file))
      mut_args[i] = evalLine(readline(file))
    end
    return fit_fun, pop_size, elite_size, sel_args, tuple(ind_args...), tuple(init_args...), tuple(cross_args...), tuple(mut_args...)
  end
end

function optimize(input_name, output_name, opt_alg, it, log)
  fit_fun, pop_size, elite_size, sel_args, ind_args, init_args, cross_args, mut_args = readArgs("FitFuns/$(input_name)")
  ga = GeneticAlgorithm.GeneticAlgorithmType(ind_args, fit_fun, pop_size, elite_size;
                                            init_args = init_args,
                                            sel_args = sel_args,
                                            cross_args = cross_args,
                                            mut_args = mut_args)
  gr()
  if opt_alg == "SINGLE"
    best_fit, mean_fit = GeneticAlgorithm.evolveSO!(ga, it, log)
    plot(1:it, [best_fit, mean_fit], xlims=(1, it), label=["Best" "Mean"], xlabel="Generation", ylabel="Fitness", legend=:bottomright)
    savefig("FitFuns/$(input_name)_fitness.png")
    open("$(output_name).best", "w") do out_file
      for fit in best_fit
        @printf(out_file, "%.9f\n", fit)
      end
    end
    open("$(output_name).mean", "w") do out_file
      for fit in mean_fit
        @printf(out_file, "%.9f\n", fit)
      end
    end
  elseif opt_alg == "MULTI"
    best_solutions = GeneticAlgorithm.evolveNSGA2!(ga, it, log)
    sol_fitness = [x .* Fitness.getDirection(fit_fun) for x in getindex.(best_solutions, 2)]
    if Fitness.getSize(fit_fun) < 4
      scatter(sol_fitness, label=["Frontier"], markersize=1)
      savefig("FitFuns/$(input_name)_fitness.png")
    end
    if applicable(FitFuns.output, fit_fun, best_solutions, sol_fitness, output_name)
      FitFuns.output(fit_fun, best_solutions, sol_fitness, output_name)
    end
  end
end

end