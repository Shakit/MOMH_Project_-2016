#=================================================================#
# xmlreader.jl
# author : Guillaume LEGRU
# date : 25 of October 2016
#
# An reader for the instances of the 2016 MOMH project.
#
#=================================================================#

# variables
isInHeader = false
isInComment = false
isInVisitorList = false
isInIndustrialList = false
isInResearcherList = false
isInIndustrial = false
isInResearcher = false

isResearcherNumberKnown = false
isIndustrialNumberKnown = false
isPreferencesMatrixCreated = false

industrialNumber = 0
researcherNumber = 0
preferenceMatrix = []



visitor_file = open(ARGS[1])

for line in eachline(visitor_file)
  # passing the header
  if contains(line, "<?xml") || isInHeader
    if !contains(line, "?>")
      isInHeader = true
    else
      isInHeader = false
    end
    continue
  end

  # passing comments
  if contains(line, "<!--") || isInComment
    if !contains(line, "-->")
      isInComment = true
    else
      isInComment = false
    end
    continue
  end

  # acknowledging the <visitor_list> tag
  if !isInVisitorList && contains(line, "<visitor_list>")
    isInVisitorList = true
    continue
  end

  # in the visitor_list
  if isInVisitorList
    # acknowledging the </visitor_list> tag
    if contains(line, "</visitor_list>")
      isInVisitorList = false
      continue
    end

    # acknowledging the number of industrials
    if !isIndustrialNumberKnown && contains(line, "<industrial_list_size>") && contains(line, "</industrial_list_size>")
      industrialNumber = identity(match(r"[0-9]+", line).match)
      @assert isdigit(industrialNumber)
      isIndustrialNumberKnown = true
    end

    # acknowledging the number of researcher
    if !isResearcherNumberKnown && contains(line, "<researcher_list_size>") && contains(line, "</researcher_list_size>")
      researcherNumber = identity(match(r"[0-9]+", line).match)
      @assert isdigit(researcherNumber)
      isResearcherNumberKnown = true
    end

    if !isPreferencesMatrixCreated && isResearcherNumberKnown && isIndustrialNumberKnown
      for i in 1:Int64(industrialNumber)
        push!(preferenceMatrix, [])
        for j in 1:Int64(researcherNumber)
          push!(preferenceMatrix[i], 0)
        end
      end
      isPreferencesMatrixCreated = true
    end

    # acknowledging the industrial_list tag
    if !isInIndustrialList && contains(line, "<industrial_list>")
      isInIndustrialList = true
      continue
    end

    # acknowledging the researcher_list tag
    if !isInResearcherList && contains(line, "<researcher_list>")
      isInResearcherList = true
      continue
    end


  end # isInVisitorList
end # file reading

println(length(preferenceMatrix))

close(visitor_file)
