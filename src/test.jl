include("xmlreader.jl")
include("peek.jl")

visitors = visitorXmlReader(ARGS[1])
rooms = roomXmlReader(ARGS[2])
hoursNumber = parse(Int, ARGS[3])
seed = 12345

Λ = []
λ = 0
while λ <= 1
  push!(Λ,λ)
  λ = λ + 0.1
end # λ <= 1

Solutions = peek(visitors, rooms, hoursNumber, Λ, 0.0, [seed])

println("$Solutions")
