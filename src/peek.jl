#=================================================================#
# peek.jl
# authors : Florian DELAVERNHE, Guillaume LEGRU
# date : 2nd of November 2016
#
# The first phase of the 2016 MOMH project : Peek.
#
#=================================================================#

include("utils.jl")

#=================================================================#
# grasp function
# args : visitors::(Array{Array{Any,1},1}, Int, Int)
#        rooms::(Array{Array{Any,1},1}, Int)
#        hoursNumber::Int
#        0 <= λ::Float <= 1
#        0 <= α::Float <= 1
#        seed::Int
# out : (solution, solutionValue)::(Any[Int[4]],(Int,Int))
function grasp(visitors, rooms, hoursNumber, λ, α, seed)
  srand(seed)
  minCounter = min(visitors[2], visitors[3], rooms[2])    # the lowest value between the industrial, researcher and room numbers
  industrialLastDate = zeros(Int, visitors[2])            # keep track of the time slot of the latest date
  industrialLastRoom = filledArray(rooms[2], visitors[2]) # keep track of the place of the latest date
  researcherLastDate = zeros(Int, visitors[3])            # keep track of the time slot of the latest date
  researcherLastRoom = filledArray(rooms[2], visitors[3]) # keep track of the place of the latest date
  solution = []
  solutionValue = [0,0]

  for h in 1:hoursNumber
    remainingIndustrials = naturalArray(1:visitors[2])
    remainingResearchers = naturalArray(1:visitors[3])
    remainingRooms = naturalArray(1:rooms[2])

    # Do as such affectation as the minimum of industrial, researcher and room number
    for i in 1:minCounter
      # Select a random industrial
      industIndex = rand(1:length(remainingIndustrials))
      indust = remainingIndustrials[industIndex]


      maxUtility = 0
      bestUtilities = [(0,0,rooms[2])] # each item is (value, researcher, room)
      for j in 1:length(remainingResearchers)
        for r in 1:length(remainingRooms)
          travelledDistance = 0
          # the travelled distance is 0 if the visitor had no date at the previous time slot
          if researcherLastDate[remainingResearchers[j]] == h-1
            travelledDistance += rooms[1][researcherLastRoom[remainingResearchers[j]]][remainingRooms[r]]
          end
          if industrialLastDate[indust] == h-1
            travelledDistance += rooms[1][industrialLastRoom[indust]][remainingRooms[r]]
          end

          # compute the utility of the considered affectation
          currentUtility = λ*(visitors[1][indust][remainingResearchers[j]]) - (1-λ)*(travelledDistance)

          # if the currentUtility is better than the max, then update it
          # (discard the previous list if the previous is not interesting)
          # else keep it only if it is interesting
          if currentUtility > maxUtility
            if maxUtility >= currentUtility * α
              push!(bestUtilities, (currentUtility, j, r))
              maxUtility = currentUtility
            else
              maxUtility = currentUtility
              bestUtilities = [(currentUtility, j ,r)]
            end
          elseif currentUtility >= maxUtility * α
            push!(bestUtilities, (currentUtility, j, r))
          end
        end # r in 1:length(remainingRooms)
      end # j in 1: length(remainingResearchers)

      # filter the interesting affectations
      finalUtilities = []
      for b in bestUtilities
        if b[1] >= maxUtility * α
          push!(finalUtilities, b)
        end
      end
      bestUtilities = finalUtilities

      # pick an affectation randomly and add it to the solution
      selectedUtility = rand(bestUtilities)
      if maxUtility ==  0
        continue
      end
      push!(solution, (indust, remainingResearchers[selectedUtility[2]], remainingRooms[selectedUtility[3]], h))

      # update the solution values
      solutionValue[1] += visitors[1][indust][remainingResearchers[selectedUtility[2]]]
      travelledDistance = 0
      if researcherLastDate[selectedUtility[2]] == h-1
        travelledDistance += rooms[1][researcherLastRoom[remainingResearchers[selectedUtility[2]]]][remainingRooms[selectedUtility[3]]]
      end
      if industrialLastDate[indust] == h-1
        travelledDistance += rooms[1][industrialLastRoom[indust]][remainingRooms[selectedUtility[3]]]
      end
      solutionValue[2] += travelledDistance

      # update the temporary lists
      industrialLastDate[indust] = h
      industrialLastRoom[indust] = remainingRooms[selectedUtility[3]]
      researcherLastDate[remainingResearchers[selectedUtility[2]]] = h
      researcherLastRoom[remainingResearchers[selectedUtility[2]]] = remainingRooms[selectedUtility[3]]
      visitors[1][indust][remainingResearchers[selectedUtility[2]]] = -1
      removeAt!(remainingIndustrials, industIndex)
      removeAt!(remainingResearchers, selectedUtility[2])
      removeAt!(remainingRooms, selectedUtility[3])

    end # i in 1:minCounter
  end # h in 1:hoursNumber
  return solution, solutionValue
end # grasp function

#=================================================================#
# grasp function
# args : visitors::(Array{Array{Any,1},1}, Int, Int)
#        rooms::(Array{Array{Any,1},1}, Int)
#        hoursNumber::Int
#        0 <= Λ::Float[] <= 1
#        0 <= α::Float <= 1
#        Seeds::Int[]
# out : Solutions ::Any[(Any[Int[4]],(Int,Int))]
function peek(visitors, rooms, hoursNumber, Λ, α, Seeds)
  Solutions = []
  for λ in Λ
    for seed in Seeds
      push!(Solutions, grasp(visitors, rooms, hoursNumber, λ, α, seed))
    end
  end
  return Solutions
end
