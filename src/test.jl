include("xmlreader.jl")
#include("grasp.jl")

# naturalArray function
# args : range::UnitRange{Int64}
# out : A::Int64[rangeMax]
function naturalArray(range)
  A = []
  for i in range
    push!(A, i)
  end
  return A
end

# grasp function
# args : visitors::(Array{Array{Any,1},1}, Int64, Int64)
#        rooms::(Array{Array{Any,1},1}, Int64)
#        hoursNumber::Int64
#        0 <= λ::Float64 <= 1
#        0 <= α::Float64 <= 1
#        seed::Int64
# out :
function grasp(visitors, rooms, hoursNumber, λ, α, seed)
  srand(seed)
  minCounter = min(visitors[2], visitors[3], rooms[2])
  industrialLastDate = zeros(Int64, visitors[2])
  industrialLastRoom = zeros(Int64, visitors[2])
  researcherLastDate = zeros(Int64, visitors[3])
  researcherLastRoom = zeros(Int64, visitors[3])
  roomLastDate = zeros(Int64, rooms[2])

  for h in 1:hoursNumber
    remainingIndustrials = naturalArray(1:visitors[2])
    for i in 1:minCounter
      indust = rand(remainingIndustrials)
      remainingIndustrials[indust] = pop!(remainingIndustrials)


    end
  end
end

visitors = visitorXmlReader(ARGS[1])
rooms = roomXmlReader(ARGS[2])
hoursNumber = parse(Int64, ARGS[3])
seed = 12345

println(naturalArray(1:10))
