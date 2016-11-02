include("xmlreader.jl")
include("peek.jl")

visitors = visitorXmlReader(ARGS[1])
rooms = roomXmlReader(ARGS[2])
hoursNumber = parse(Int, ARGS[3])
seed = 12345

Solutions = peek(visitors, rooms, hoursNumber, [1, 0], 1, [seed])

println("$Solutions")

println(naturalArray(1:10))
