using Plots

points = Tuple{Float64, Float64}[]

open(ARGS[1], "r") do file
  for line in readlines(file)
    text_values = split(line)
    values = map(x -> parse(Float64, x), text_values)
    push!(points, Tuple(values))
  end
end

gr()
scatter(points, label=["Frontier"], markersize=1)
savefig(ARGS[2])