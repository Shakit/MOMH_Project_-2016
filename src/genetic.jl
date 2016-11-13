function initialPopulation(visitors, rooms, hoursNumber)
  Λ = []
  λ = 0
  k = 10
  while λ <= 1
    push!(Λ,λ)
    λ = λ + 1/k
    k = k + 1
  end # λ <= 1
  push!(Λ,1)
  Population = peek(visitors, rooms, hoursNumber, Λ, 1, [seed])
  for i in 1:length(Λ)
    push!(Population, grasp(visitors, rooms, hoursNumber, 1, 0.001, seed)
  end # i in 1:20
  return Population
end # initialPopulation function

function rank!(Population)
  if length(Population) > 1
    middle = Int(length(Population) / 2)
    left = Population[1:middle]
    right = Population[middle+1:length(Population)]
    rank!(left)
    rank!(right)

    #fusion
    aux = []
    i = 1
    j = 1
    while i <= length(left) && j <= length(right)
      if left[i][1] > right[j][1]
        push!(aux, left[i])
        i += 1
      elseif left[i][1] < right[j][1]
        push!(aux, right[j])
        j += 1
      else
        if left[i][2] <= right[j][2]
          push!(aux, left[i])
          i += 1
        else
          push!(aux, right[j])
          j += 1
        end # if 2
      end # if 1
    end # while fusion
    if i = length(left)
      for l in j:length(right)
        push!(aux,right[l])
      end
    else
      for l in i:length(left)
        push!(left[l])
      end
    end
    Population = aux
  end # if > 1
end # rank function


function genetic(visitors, rooms, hoursNumber)
Population = initialPopulation(visitors, rooms, hoursNumber)


end # genetic function
