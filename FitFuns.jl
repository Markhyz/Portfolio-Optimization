push!(LOAD_PATH, "../Genetic Algorithm")

module FitFuns

using LinearAlgebra

using Fitness
using Individual
using RealIndividual

struct NullFit <: Fitness.AbstractFitness{1}
  Fitness.@Fitness

  function NullFit()
    new((1,))
  end
end
function (::NullFit)()
  return (0.0, )
end
function buildArgs(::Type{NullFit}, n::Integer)
  return (n, fill((0, 1), n))
end

struct TestFit <: Fitness.AbstractFitness{1}
  Fitness.@Fitness

  function TestFit()
    new((1,))
  end
end
function (::TestFit)(x::Individual.AbstractIndividual)
  return (convert(Float64, sum(x)),)
end
function buildArgs(::Type{TestFit}, n::Integer, lb::Integer, ub::Integer)
  return (n, fill((lb, ub), n))
end

struct AckleyFit <: Fitness.AbstractFitness{1}
  Fitness.@Fitness

  function AckleyFit()
    new((-1,))
  end
end
function (::AckleyFit)(x::RealIndividual.AbstractRealIndividual)
  a, b, c, d = 20.0, 0.2, 2π, Individual.getNumGenes(x)
  s1, s2 = foldl(((x1, x2), y) -> (x1 + y ^ 2, x2 + cos(c * y)), x; init = (0, 0))
  res = -a * exp(-b * sqrt((1 / d) * s1)) - exp((1 / d) * s2) + a + exp(1.0)
  return (-res,)
end
function buildArgs(::Type{AckleyFit}, n::Integer)
  return (n, fill((-32.768, 32.768), n))
end

struct SchFit <: Fitness.AbstractFitness{2}
  Fitness.@Fitness

  function SchFit()
    new((-1, -1))
  end
end
function (::SchFit)(x::RealIndividual.AbstractRealIndividual)
  res1 = x[1] ^ 2
  res2 = (x[1] - 2) ^ 2
  return (-res1, -res2)
end
function buildArgs(::Type{SchFit}, x::Real)
  return (1, fill((-x, x), 1))
end

struct KurFit <: Fitness.AbstractFitness{2}
  Fitness.@Fitness

  function KurFit()
    new((-1, -1))
  end
end
function (::KurFit)(x::RealIndividual.AbstractRealIndividual)
  res1 = 0.0
  res2 = 0.0
  for i = 1:(length(x) - 1)
    res1 += -10 * exp(-0.2 * sqrt(x[i] ^ 2 + x[i + 1] ^ 2)) 
  end
  for gene in x
    res2 += abs(gene) ^ 0.8 + 5 * sin(gene ^ 3)
  end 
  return (-res1, -res2)
end
function buildArgs(::Type{KurFit})
  return (3, fill((-5.0, 5.0), 3))
end

struct Zdt2Fit <: Fitness.AbstractFitness{2}
  Fitness.@Fitness

  function Zdt2Fit()
    new((-1, -1))
  end
end
function (::Zdt2Fit)(x::Individual.AbstractIndividual)
  res1 = x[1]
  k = 1 + 9 * sum(@view x[2:end]) / (Individual.getNumGenes(x) - 1)
  res2 = k * (1 - (x[1] / k) ^ 2)
  return (-res1, -res2)
end
function buildArgs(::Type{Zdt2Fit})
  return (30, fill((0.0, 1.0), 30))
end

struct ViennetFit <: Fitness.AbstractFitness{3}
  Fitness.@Fitness

  function ViennetFit()
    new((-1, -1, -1))
  end
end
function (::ViennetFit)(v::Individual.AbstractIndividual)
  x, y = v[1], v[2]
  res1 = 0.5 * (x ^ 2 + y ^ 2) + sin(x ^ 2 + y ^ 2)
  res2 = ((3 * x - 2 * y + 4) ^ 2) / 8 + ((x - y + 1) ^ 2) / 27 + 15
  res3 = 1 / (x ^ 2 + y ^ 2 + 1) - 1.1 * exp(-(x ^ 2 + y ^ 2))
  return (-res1, -res2, -res3)
end
function buildArgs(::Type{ViennetFit})
  return (2, fill((-3.0, 3.0), 2))
end

struct Zdt3Fit <: Fitness.AbstractFitness{2}
  Fitness.@Fitness

  function Zdt3Fit()
    new((-1, -1))
  end
end
function (::Zdt3Fit)(x::Individual.AbstractIndividual)
  res1 = x[1]
  g = 1 + 9 * sum(@view x[2:end]) / (Individual.getNumGenes(x) - 1)
  h = 1 - sqrt(x[1] / g) - (x[1] / g) * sin(10 * π * x[1])
  res2 = g * h
  return (-res1, -res2)
end
function buildArgs(::Type{Zdt3Fit})
  return (30, fill((0.0, 1.0), 30))
end

struct MarkowitzFit <: Fitness.AbstractFitness{2}
  Fitness.@Fitness

  μ::Vector{Float64}
  σ::Matrix{Float64}

  function MarkowitzFit(filename::String)
    let μ, σ
    	open(filename, "r") do file
        num_assets = parse(Int64, strip(readline(file)))
        μ = Vector{Float64}(undef, num_assets)
        sd = Vector{Float64}(undef, num_assets)
        for i = 1:num_assets
          μ[i], sd[i] = map(x -> parse(Float64, x), split(readline(file)))
        end
        σ = Matrix{Float64}(undef, num_assets, num_assets)
        for line in readlines(file)
          values = split(line)
          i, j = parse(Int64, values[1]), parse(Int64, values[2])
          ρ = parse(Float64, values[3])
          σ[i, j] = ρ * sd[i] * sd[j]
          σ[j, i] = σ[i, j]
        end
      end
      new((1, -1), μ, σ)
    end
  end
end
function (fit::MarkowitzFit)(x::RealIndividual.RealIndividualType)
  mean = fit.μ ⋅ x
  var = 0.0
  for i = 1:Individual.getNumGenes(x), j = 1:Individual.getNumGenes(x)
    var = var + x[i] * x[j] * fit.σ[i, j]
  end
  #var = foldl((total, i) -> total + x[i] * (fit.σ[i, :] ⋅ x), 1:Individual.getNumGenes(x))
  return (mean, -var)
end
function buildArgs(::Type{MarkowitzFit}, n::Integer)
  return (n, fill((0.0, 1.0), n))
end

end