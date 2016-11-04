#=================================================================#
# xmlreader.jl
# author : Guillaume LEGRU
# date : 25 of October 2016
#
# An reader for the instances of the 2016 MOMH project.
#
#=================================================================#

#=================================================================#
# visitorXmlReader function
# args : file_name::String
# out : (preferenceMatrix, industrialNumber, researcherNumber)::(Array{Array{Any,1},1}, Int, Int)
function visitorXmlReader(file_name)
  @assert (typeof(file_name) == String)

  # XML tags variables
  isInHeader = false
  isInComment = false
  isInVisitorList = false
  isInIndustrialList = false
  isInResearcherList = false
  isInIndustrial = false
  isInResearcher = false
  isInPreferenceList = false

  # flags variable to create the preference matrix
  isResearcherNumberKnown = false
  isIndustrialNumberKnown = false
  isPreferencesMatrixCreated = false
  currentId = 0
  currentPreferedId = 0

  # returned variables
  industrialNumber = 0
  researcherNumber = 0
  preferenceMatrix = []

  visitor_file = open(file_name)

  for line in eachline(visitor_file)
    # ignoring the header
    if contains(line, "<?xml") || isInHeader
      if !contains(line, "?>")
        isInHeader = true
      else
        isInHeader = false
      end
      continue
    end

    # ignoring comments
    if contains(line, "<!--") || isInComment
      if !contains(line, "-->")
        isInComment = true
      else
        isInComment = false
      end
      continue
    end

    # acknowledge the <visitor_list> tag
    if !isInVisitorList && contains(line, "<visitor_list>")
      isInVisitorList = true
      continue
    end

    # in the visitor_list
    if isInVisitorList
      # acknowledge the </visitor_list> closing tag
      if contains(line, "</visitor_list>")
        isInVisitorList = false
        continue
      end

      # acknowledge the number of industrials
      if !isIndustrialNumberKnown && contains(line, "<industrial_list_size>") && contains(line, "</industrial_list_size>")
        industrialNumber = parse(Int, match(r"[0-9]+", line).match)
        isIndustrialNumberKnown = true
        continue
      end

      # acknowledge the number of researcher
      if !isResearcherNumberKnown && contains(line, "<researcher_list_size>") && contains(line, "</researcher_list_size>")
        researcherNumber = parse(Int, match(r"[0-9]+", line).match)
        isResearcherNumberKnown = true
        continue
      end

      # preference matrix creation (only once then locked)
      if !isPreferencesMatrixCreated && isResearcherNumberKnown && isIndustrialNumberKnown
        for i in 1:industrialNumber
          push!(preferenceMatrix, [])
          for j in 1:researcherNumber
            push!(preferenceMatrix[i], 0)
          end
        end
        isPreferencesMatrixCreated = true
      end

      # acknowledge the <industrial_list> tag
      if !isInIndustrialList && contains(line, "<industrial_list>")
        isInIndustrialList = true
        continue
      end

      # acknowledge the <researcher_list> tag
      if !isInResearcherList && contains(line, "<researcher_list>")
        isInResearcherList = true
        continue
      end

      # in the industrial_list
      if isInIndustrialList
        # acknowledge the </industrial_list> closing tag
        if contains(line, "</industrial_list>")
          isInIndustrialList = false
          continue
        end

        #acknowledge a <industrial> tag
        if !isInIndustrial && contains(line, "<industrial>")
          isInIndustrial = true
          continue
        end

        if isInIndustrial
          #acknowledge the </industrial> closing tag
          if contains(line, "</industrial>")
            isInIndustrial = false
            continue
          end

          # acknowledge the current ID
          if contains(line, "<id>") && !isInPreferenceList
            currentId = parse(Int, match(r"[0-9]+",line).match)
            continue
          end

          # acknowledge the current name (it is ignored, actually)
          if contains(line, "<name>") && !isInPreferenceList
            continue
          end

          # acknowledge the <preference_list> tag
          if !isInPreferenceList && contains(line, "<preference_list>")
            isInPreferenceList = true
            continue
          end

          if isInPreferenceList
            # acknowledge the </preference_list> exit tag
            if contains(line, "</preference_list>")
              isInPreferenceList = false
            end

            if !isInResearcher && contains(line, "<researcher>")
              isInResearcher = true
              continue
            end

            if isInResearcher
              #acknowledge the </researcher> closing tag
              if contains(line, "</researcher>")
                isInResearcher = false
                continue
              end

              # acknowledge teh current id in the preference list
              if contains(line, "<id>")
                currentPreferedId = parse(Int, match(r"[0-9]+",line).match)
                continue
              end

              #acknowledge tha name, ignored
              if contains(line, "name")
                continue
              end

              # acknowledge the preference matrix value and stores it
              if contains(line, "<preference_value>")
                @assert (currentId > 0 && currentId <= industrialNumber)
                @assert (currentPreferedId > 0 && currentPreferedId <= researcherNumber)
                preferenceMatrix[currentId][currentPreferedId] += parse(Int, match(r"[0-9]+",line).match)
              end
            end # isInResearcher
          end # isInPreferenceList
        end # isInIndustrial
      end # isInIndustrialList

      # in the researcher_list
      if isInResearcherList
        # acknowledge the </industrial_list> closing tag
        if contains(line, "</researcher_list>")
          isInResearcherList = false
          continue
        end

        #acknowledge a <researcher> tag
        if !isInResearcher && contains(line, "<researcher>")
          isInResearcher = true
          continue
        end

        if isInResearcher
          #acknowledge the </researcher> closing tag
          if contains(line, "</researcher>")
            isInResearcher = false
            continue
          end

          # acknowledge the current ID
          if contains(line, "<id>") && !isInPreferenceList
            currentId = parse(Int, match(r"[0-9]+",line).match)
            continue
          end

          # acknowledge the current name (it is ignored, actually)
          if contains(line, "<name>") && !isInPreferenceList
            continue
          end

          # acknowledge the <preference_list> tag
          if !isInPreferenceList && contains(line, "<preference_list>")
            isInPreferenceList = true
            continue
          end

          if isInPreferenceList
            # acknowledge the </preference_list> exit tag
            if contains(line, "</preference_list>")
              isInPreferenceList = false
            end

            if !isInIndustrial && contains(line, "<industrial>")
              isInIndustrial = true
              continue
            end

            if isInIndustrial
              # acknowledge the </industrial> closing tag
              if contains(line, "</industrial>")
                isInIndustrial = false
                continue
              end

              # acknowledge the current id in the preference list
              if contains(line, "<id>")
                currentPreferedId = parse(Int, match(r"[0-9]+",line).match)
                continue
              end

              # acknowledge tha name, ignored
              if contains(line, "name")
                continue
              end

              # acknowledge the preference matrix value and stores it
              if contains(line, "<preference_value>")
                @assert (currentId > 0 && currentId <= researcherNumber)
                @assert (currentPreferedId > 0 && currentPreferedId <= industrialNumber)
                preferenceMatrix[currentId][currentPreferedId] += parse(Int, match(r"[0-9]+",line).match)
              end
            end # isInIndustrial
          end # isInPreferenceList
        end # isInResearcher
      end # isInResearcherList
    end # isInVisitorList
  end # file reading
  close(visitor_file)

  return preferenceMatrix, industrialNumber, researcherNumber
end # function visitorXmlReader

#=================================================================#
# roomXmlReader function
# args : file_name::String
# out : (preferenceMatrix, industrialNumber, researcherNumber)::(Array{Array{Any,1},1}, Int, Int)
function roomXmlReader(file_name)
  @assert (typeof(file_name) == String)

  # XML tags variables
  isInHeader = false
  isInComment = false
  isInRoomList = false
  isInDepartureRoom = false
  isInArrivalRoom = false
  isInDistancesList = false

  # flags variable to create the preference matrix
  isRoomNumberKnown = false
  isDistancesMatrixCreated = false
  currentDepartureRoom = 0
  currentArrivalRoom = 0

  # returned variables
  roomNumber = 0
  distancesMatrix = []

  room_file = open(file_name)

  for line in eachline(room_file)
    # ignoring the header
    if contains(line, "<?xml") || isInHeader
      if !contains(line, "?>")
        isInHeader = true
      else
        isInHeader = false
      end
      continue
    end

    # ignoring comments
    if contains(line, "<!--") || isInComment
      if !contains(line, "-->")
        isInComment = true
      else
        isInComment = false
      end
      continue
    end

    # acknowledge the <room_list> tag
    if !isInRoomList && contains(line, "<room_list>")
      isInRoomList = true
      continue
    end

    if isInRoomList
      # acknowledge the </room_list> closing tag
      if contains(line, "</room_list>")
        isInRoomList = false
        continue
      end

      #acknowledge the number of room
      if contains(line, "<room_number>")
        roomNumber = parse(Int, match(r"[0-9]+",line).match)
        isRoomNumberKnown = true
        continue
      end

      # create the distance matrix then lock
      if !isDistancesMatrixCreated && isRoomNumberKnown
        for i in 1:roomNumber
          push!(distancesMatrix, [])
          for j in 1:roomNumber
            push!(distancesMatrix[i], 0)
          end
        end
        isDistancesMatrixCreated = true
      end

      #acknowledge a first <room> tag
      if !isInDepartureRoom && contains(line, "<room>")
        isInDepartureRoom = true
        continue
      end

      if isInDepartureRoom
        # acknowledge the </room> closing tag
        if contains(line, "</room>") && !isInDistancesList
          isInDepartureRoom = false
          continue
        end

        # acknowledge the id of the departure room
        if contains(line, "<id>") && !isInDistancesList
          currentDepartureRoom = parse(Int, match(r"[0-9]+",line).match)
          continue
        end

        if !isInDistancesList && contains(line, "<distances_list>")
          isInDistancesList = true
          continue
        end

        if isInDistancesList
          if contains(line, "</distances_list>")
            isInDistancesList = false
            continue
          end
          #acknowledge a second <room> tag
          if !isInArrivalRoom && contains(line, "<room>")
            isInArrivalRoom = true
            continue
          end

          if isInArrivalRoom
            # acknowledge the </room> closing tag
            if contains(line, "</room>")
              isInArrivalRoom = false
              continue
            end

            # acknowledge the id of the arrival room
            if contains(line, "<id>")
              currentArrivalRoom = parse(Int, match(r"[0-9]+",line).match)
              continue
            end

            # fills the distance matrix
            # Notice that it is filled when the value in the matrix is 0, because the matrix is supposed to be symetric
            if contains(line, "<distance>")
              @assert (currentDepartureRoom  > 0 && currentDepartureRoom <= roomNumber)
              @assert (currentArrivalRoom > 0 && currentArrivalRoom <= roomNumber)
              if distancesMatrix[currentDepartureRoom][currentArrivalRoom] == 0
                distancesMatrix[currentDepartureRoom][currentArrivalRoom] = parse(Int, match(r"[0-9]+",line).match)
              end
              continue
            end
          end # arrival room
        end #distances_list
      end # departure room
    end # room_list
  end # file reading

  return distancesMatrix, roomNumber

end # function roomXmlReader
