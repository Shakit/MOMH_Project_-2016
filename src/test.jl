include("xmlreader.jl")
#include("grasp.jl")

visitors = visitorXmlReader(ARGS[1])
rooms = roomXmlReader(ARGS[2])

println(visitors)
println(rooms)
