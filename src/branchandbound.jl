
# Create the next node by fixing at 1 the first unfixed variable
function son1(visitors, rooms, hoursNumber, node)
  find = false
  nbFixed = node[4]
  son = []
  k = 0
  I = visitor[2]
  R = visitor[3]
  H = hoursNumber
  S = rooms[2]
  hk = 0
  ik = 0
  rk = 0
  sk = 0
  firstObjectiv = node[2]
  seconObjectiv = node[3]
  time = 0
  for j in 1:length(node[1])
    hj = cld(j,I*R*S)
    ij = cld(j - hj*I*R*S, R*S)
    rj = cld(j - (hj*I + ij)*R, S)
    sj = j - ((hj*I + ij)*R + rj)*S
    if find
      if hj == hk
        if ij == ik | rj == rk | sj == sk
          push!(son, 0)
          nbFixed = nbFixed + 1
        end
      elseif ij == ik
        if rj == rk
          push!(son, 0)
          nbFixed = nbFixed + 1
        end
      else
        push!(son, node[1][j])
      end
    else !find
      if node[1][j] < 0
        find = true
        push!(son,1)
        nbFixed = nbFixed + 1

        k = j
        hk = cld(k,I*R*S)
        ik = cld(k - hk*I*R*S, R*S)
        rk = cld(k - (hk*I + ik)*R, S)
        sk = k - ((hk*I + ik)*R + rk)*S
        firstObjectiv = firstObjectiv + visitors[1][ik][rk]
        for m in 1:length(meeting)
          hm = cld(meeting[m],I*R*S)
          im = cld(meeting[m] - hm*I*R*S, R*S)
          rm = cld(meeting[m] - (hm*I + im)*R, S)
          sm = meeting[m] - ((hm*I + im)*R + rm)*S
          if ik == im | rk == rm
            seconObjectiv = seconObjectiv + rooms[1][sm][sk]
          end
        end

      elseif time < hj
        time = hj
        meeting = []
      else
        push!(son, node[1][j])
      end
      if node[1][j] == 1
        push!(meeting,j)
      end
  end
return son, firstObjectiv, seconObjectiv, nbFixed
end

function son0(node)
  nbFixed = node[4]
  k = 1
  son = []
  firstObjectiv = node[2]
  seconObjectiv = node[3]
  for k in 1:length(node[1])
    push!(son, node[1][k])
    if node[1][k] < 0
      push!(son,0)
      nbFixed = nbFixed + 1
    end
  end
  return son, firstObjectiv, seconObjectiv, nbFixed
end

function clone(node)
  f = node[2]
  g = node[3]
  nb_fixed = node[4]
  clone = []
  for i in 1:length(node[1])
    push!(clone, node[1][k])
  end
  return clone, f, g, nb_fixed
end







function branchAndBound(visitors, rooms, hoursNumber, upperBoundFirstObjectiv)
  # compute a majoran of the distance traveled
  maxDistanceTravelable = 0
  for s in 1:rooms[2]
    for t in 1:rooms[2]
      if maxDistanceTravelable < rooms[1][s]
        maxDistanceTravelable = rooms[1][s]
      end
    end
  end
  maxDistanceTravelable = maxDistanceTravelable*rooms[2]*(hoursNumber-1)
  #initialize all the variables
  solutionFound = true
  𝜺 = 0
  allFixed = visitors[2]*visitors[3]*rooms[2]*hoursNumber
  openNodes = []
  closednode = []
  solutions = []
  Efficients = []
  #create the first node
  node0 = []
  push!(node0, fill(-1,allFixed))
  push!(node0, 0)
  push!(node0, 0)
  push!(node0, 0)
  push!(openNodes, node0)

#use branch and bound with 𝜺-constrain method
  while solutionFound # & 𝜺 < upperBoundFirstObjectiv
      solutionFound = false
      lowerBoundFirstObjectiv = 𝜺
      upperBoundSecondObjectiv = maxDistanceTravelable
      #search the optimal solution priority first for the second objectiv
      #with the first objectiv constrain to be greater than 𝜺
      while length(openNodes) > 0
        #search the best node to start the exploration
        indexBestSecondObjectiv = 1
        bestSecondObjectiv = openNodes[1][3]
        for i in 2:length(openNodes)
          if bestSecondObjectiv > openNodes[1][3]
            bestSecondObjectiv = openNodes[1][3]
            indexBestSecondObjectiv = i
          end
        end
        #create two nodes from the previously chosen
        child1 = son1(visitors, rooms, hoursNumber, open_nodes[index_best])
        child0 = son0(openNodes[indexBestSecondObjectiv])
        #as develop the chosen node is remove from the list of open nodes
        pop!(openNodes,indexBestSecondObjectiv)
        if child1[4] < allFixed
          if child1[3] <= upperBoundSecondObjectiv
            push!(openNodes, child1)
          else
            push!(closednode, child1)
          end
        else #end of a branch
          if child1[3] <= upperBoundSecondObjectiv & child1[2]>𝜺
            solutionFound = true
            solution = clone(child1)
            if child1[3] < upperBoundSecondObjectiv
              lowerBoundFirstObjectiv = child1[2]
            elseif lowerBoundFirstObjectiv < child1[2]
              lowerBoundFirstObjectiv = child1[2]
            end
            upperBoundSecondObjectiv = child1[3]
          end
        end
        if child0[4] < allFixed
          push!(openNodes, child1)
        else #end of a branch
          if child0[2]>lowerBoundFirstObjectiv
            solution = clone(child1)
            lowerBoundFirstObjectiv = child0[2]
            solutionFound = true
          end
        end
      end
      𝜺 = lowerBoundFirstObjectiv
      for i in 1:length(closednode)
        push!(openNodes,closednode[i])
        pop!(closednode,closednode[i])
      end
      push!(Efficients, solution)
  end
  return Efficients
end
