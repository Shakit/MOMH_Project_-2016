#=================================================================#
# utils.jl
# authors : Florian DELAVERNHE, Guillaume LEGRU
# date : 2nd of November 2016
#
# A simple compilation of utility functions for the 2016 MOMH Project.
#
#=================================================================#

#=================================================================#
# naturalArray function
# args : range::UnitRange{Int}
# out : A::Int[rangeMax]
function naturalArray(range)
  A = []
  for i in range
    push!(A, i)
  end
  return A
end

#=================================================================#
# filledArray function
# args : value::Int, dim::Int
# out : A::Int[dim]
function filledArray(value, dim)
  A = []
  for i in 1:dim
    push!(A, value)
  end
  return A
end

#=================================================================#
# removeAt! function
# args A::Any[]
# out : nothing
function removeAt!(A, index)
  if index >= length(A)
    pop!(A)
  else
    A[index] = pop!(A)
  end
end
