#=================================================================#
# xmlreader.jl
# author : Guillaume LEGRU
# date : 25 of October 2016
#
# An reader for the instances of the 2016 MOMH project.
#
#=================================================================#

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

# problem actual data
industrialNumber = 0
researcherNumber = 0
preferenceMatrix = []

visitor_file = open(ARGS[1])

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
            industrialNumber = identity(match(r"[0-9]+", line).match)
            @assert isdigit(industrialNumber)
            isIndustrialNumberKnown = true
            continue
        end

        # acknowledge the number of researcher
        if !isResearcherNumberKnown && contains(line, "<researcher_list_size>") && contains(line, "</researcher_list_size>")
            researcherNumber = identity(match(r"[0-9]+", line).match)
            @assert isdigit(researcherNumber)
            isResearcherNumberKnown = true
            continue
        end

        # preference matrix creation (only once then locked)
        if !isPreferencesMatrixCreated && isResearcherNumberKnown && isIndustrialNumberKnown
            for i in 1:Int64(industrialNumber)
                push!(preferenceMatrix, [])
                for j in 1:Int64(researcherNumber)
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
                    currentId = Int64(identity(match(r"[0-9]+",line).match))
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
                            currentPreferedId = Int64(identity(match(r"[0-9]+",line).match))
                            continue
                        end

                        #acknowledge tha name, ignored
                        if contains(line, "name")
                            continue
                        end

                        # acknowledge the preference matrix value and stores it
                        if contains(line, "<preference_value>")
                            @assert (currentId > 0)
                            @assert (currentPreferedId > 0)
                            preferenceMatrix[currentId][currentPreferedId] += Int64(identity(match(r"[0-9]+",line).match))
                        end
                    end # isInResearcher
                end # isInPreferenceList
            end # isInIndustrial
        end # isInIndustrialList

        # in the industrial_list
        if isInResearcherList
            # acknowledge the </industrial_list> closing tag
            if contains(line, "</researcher_list>")
                isInResearcherList = false
                continue
            end

            #acknowledge a <researcher> tag
            if !isInResearcher && contains(line, "<researcher>")
                isInIndustrial = true
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
                    currentId = Int64(identity(match(r"[0-9]+",line).match))
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
                            currentPreferedId = Int64(identity(match(r"[0-9]+",line).match))
                            continue
                        end

                        # acknowledge tha name, ignored
                        if contains(line, "name")
                            continue
                        end

                        # acknowledge the preference matrix value and stores it
                        if contains(line, "<preference_value>")
                            @assert (currentId > 0)
                            @assert (currentPreferedId > 0)
                            preferenceMatrix[currentId][currentPreferedId] += Int64(identity(match(r"[0-9]+",line).match))
                        end
                    end # isInIndustrial
                end # isInPreferenceList
            end # isInResearcher
        end # isInResearcherList
    end # isInVisitorList
end # file reading

preferenceMatrix

close(visitor_file)
