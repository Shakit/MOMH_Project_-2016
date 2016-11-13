visitors
rooms
hoursNumber

type Individual
	meetings
	indstrialistSchedule
	researcherSchedule
	roomSchedule
	f
	g
end

#PRE Constraints respected for the appointment
#PRE: the meeting was not appointed
function appointment!(individual::Individual, industrialist::Int, researcher::Int, room::Int, timeSlot::Int)
	individual.meetings[industrialist][researcher] = [room,timeSlot]
	individual.indstrialistSchedule[industrialist][timeSlot] = [researcher,room]
	individual.researcherSchedule[researcher][timeSlot] = [industrialist,room]
	individual.roomSchedule[room][timeSlot] = [industrialist,researcher]
	individual.f = individual.f + visitors[industrialist][researcher]
	if timeSlot > 1
		industrialistRoom = individual.indstrialistSchedule[industrialist][timeSlot-1][1]
		researcherRoom = researcher.ResearcherSchedule[researcher][timeSlot-1][1]
		if industrialistRoom > 0
			individual.g = individual.g + rooms[industrialistRoom][room]
		end
		if researcherRoom > 0
			individual.g = individual.g + rooms[researcherRoom][room]
		end
	end
	if timeSlot < hoursNumber
		industrialistRoom = individual.indstrialistSchedule[industrialist][timeSlot+1][1]
		researcherRoom = researcher.ResearcherSchedule[researcher][timeSlot+1][1]
		if industrialistRoom > 0
			individual.g = individual.g + rooms[industrialistRoom][room]
		end
		if researcherRoom > 0
			individual.g = individual.g + rooms[researcherRoom][room]
		end
	end
end

function remove(individual::Individual, industrialist::Int, researcher::Int, room::Int, timeSlot::Int)
	individual.f = individual.f - visitors[industrialist][researcher]
	if timeSlot > 1
		industrialistRoom = individual.indstrialistSchedule[industrialist][timeSlot-1][1]
		researcherRoom = researcher.ResearcherSchedule[researcher][timeSlot-1][1]
		if industrialistRoom > 0
			individual.g = individual.g - rooms[industrialistRoom][room]
		end
		if researcherRoom > 0
			individual.g = individual.g - rooms[researcherRoom][room]
		end
	end
	if timeSlot < hoursNumber
		industrialistRoom = individual.indstrialistSchedule[industrialist][timeSlot+1][1]
		researcherRoom = researcher.ResearcherSchedule[researcher][timeSlot+1][1]
		if industrialistRoom > 0
			individual.g = individual.g - rooms[industrialistRoom][room]
		end
		if researcherRoom > 0
			individual.g = individual.g - rooms[researcherRoom][room]
		end
	end
	individual.meetings[industrialist][researcher] = [0,0]
	individual.indstrialistSchedule[industrialist][timeSlot] = [0,0]
	individual.researcherSchedule[researcher][timeSlot] =[0,0]
	individual.roomSchedule[room][timeSlot] = [0,0]
end

function crossoverMeetingScheduleIntersection(father::Individual, mother::Individual)
	choice=ones(::Int, hoursNumber)
	for h in 1:hoursNumber
		choice[h]=rand(1:2)
	end
	child = Individual(father)
	for i in 1:visitors[2]
		for r in 1:visitors[3]
			hour = father.meetings[i][r][2]
			if hour == mother.meetings[i][r][2]
				if choice[hour] == 1
					appointment!(child, i, r, father.meetings[i][r][1], hour)
				else
					appointment!(child, i, r, mother.meetings[i][r][1], hour)
				end
			end
		end
	end
	grasp!(child)
	return child
end

function crossoverindustrialistScheduleIntersection(father::Individual, mother::Individual)
	child = Individual(father)
	choice=ones(::Int, hoursNumber)
	for h in 1:hoursNumber
		choice[h]=rand(1:2)
	end
	for i in 1:visitors[2]
		for h in 1:hoursNumber
			room = father.indstrialistSchedule[i][h][2]
			if room == mother.indstrialistSchedule[i][h][2]
				if choice[h] == 1
					r = father.indstrialistSchedule[i][h][1]
					if child.meetings[i][r][1]==0
						appointment!(child, i, r, room, h)
					end
				else
					r = mother.indstrialistSchedule[i][h][1]
					if child.meetings[i][r][1]==0
						appointment!(child, i, r, room, h)
					end
				end
			else

			end
		end
	end

	graps!(child)
	return child
end

function crossoverResearcherScheduleIntersection(father::Individual, mother::Individual)
	child = Individual(father)
	choice=ones(::Int, hoursNumber)
	for h in 1:hoursNumber
		choice[h]=rand(1:2)
	end
	for r in 1:visitors[3]
		for h in 1:hoursNumber
			room = father.researcherSchedule[r][h][2]
			if room == mother.researcherSchedule[r][h][2]
				if choice[h] == 1
					i = father.researcherSchedule[r][h][1]
					if child.meetings[i][r][1]==0
						appointment!(child, i, r, room, h)
					end
				else
					i = mother.researcherSchedule[r][h][1]
					if child.meetings[i][r][1]==0
						appointment!(child, i, r, room, h)
					end
				end
			else

			end
		end
	end

	graps!(child)
	return child
end

function crossoverRandomScheduleUnion(father::Individual, mother::Individual)
	child = Individual(father)

	for h in 1:hoursNumber
		for s in 1:rooms[2]
			i1 = father.roomSchedule[s][h][1]
			r1 = father.roomSchedule[s][h][2]
			i2 = mother.roomSchedule[s][h][1]
			r2 = mother.roomSchedule[s][h][2]
			if i1 > 0 && i2 == 0 && child.meetings[i1,r1] == 0
				appointment!(child, i1, r1, s, h)
			elseif i1 == 0 && i2 > 0 && child.meetings[i2,r2] == 0
				appointment!(child, i2, r2, s, h)
			elseif i1 > 0 && i2 > 0
				if child.meetings[i2,r2] == 0
					if child.meetings[i1,r1] == 0
						choice = rand(1:2)
						if choice == 1
							appointment!(child, i1, r1, s, h)
						else
							appointment!(child, i2, r2, s, h)
						end # choice == 1
					else
							appointment!(child, i2, r2, s, h)
					end # child.meetings[i1,father.roomSchedule[s][h][2]] == 0
				elseif child.meetings[i1,r1] == 0
					appointment!(child, i1, r1, s, h)
				end # child.meetings[i2,mother.roomSchedule[s][h][2]] == 0
			end	# i1 > 0 && i2 == 0 && child.meetings[i1,father.roomSchedule[s][h][2]] == 0
		end # s in 1:rooms[2]
	end # h in 1:hoursNumber
end # crossoverRandomScheduleUnion function

	graps!(child)
	return child
end

# #return the distance
# #beforeAfter: int=-1 if we look the change with the precedent hour, +1 if we look the change with the succeed hour
# #PRE: not room1=room2=0
# function exchangeI(beforeAfter, visitors, rooms, hoursNumber, timeSlot, room1, room2, indexi)
# 	if beforeAfter+timeSlot > 0 && beforeAfter+timeSlot < hoursNumber
# 		indexRoom = IndstrialistSchedule[indexi][timeSlot+beforeAfter][1]
# 	end
# 	if 	indexRoom > 0
# 		if room1 == 0
# 			return rooms[1][indexRoom][room2]
# 		elseif room2=0
# 			return -rooms[1][indexRoom][room2]
# 		else
# 			return -rooms[1][indexRoom][room1] + rooms[1][indexRoom][room2]
# 		end
# 	else
# 		return 0
# 	end
# else
# 	return 0
# end
# end
#
# #return the distance
# #beforeAfter: int=-1 if we look the change with the precedent hour, +1 if we look the change with the succeed hour
# function exchangeR(beforeAfter, visitors, rooms, hoursNumber, timeSlot, room1, room2, indexr)
# 	if beforeAfter + timeSlot > 0 && beforeAfter + timeSlot < hoursNumber
# 		indexRoom = ResearcherSchedule[indexr][timeSlot+beforeAfter][1]
# 	end
# 	if 	indexRoom > 0
# 		if room1 == 0
# 			return rooms[1][indexRoom][room2]
# 		elseif room2 = 0
# 			return -rooms[1][indexRoom][room2]
# 		else
# 			return -rooms[1][indexRoom][room1] + rooms[1][indexRoom][room2]
# 		end
# 	else
# 		return 0
# 	end
# else
# 	return 0
# end
# end
#
# function roomExchange!(visitors, rooms, timeSlot, room1, room2)
# 	#pre-requis: les rendez vous fixé aux lieux room1 et room2 eu temps timeSlot existent
# 	RDV = RoomSchedule[room1][timeSlot]
# 	indexi1 = RDV[1]
# 	indexr1 = RDV[2]
# 	RDV = RoomSchedule[room2][timeSlot]
# 	indexi2 = RDV[1]
# 	indexr2 = RDV[2]
#
# 	x[indexi1][indexr1][room1][timeSlot] = 0
# 	x[indexi2][indexr2][room2][timeSlot] = 0
# 	x[indexi1][indexr1][room2][timeSlot]=1
# 	x[indexi2][indexr2][room1][timeSlot]=1
#
# 	secondObjectiv = g
# 	secondObjectiv=secondObjectiv + exchangeI(-1,visitors,rooms,hoursNumber,timeSlot,room1,room2,indexi1)
# 	secondObjectiv=secondObjectiv + exchangeI(-1,visitors,rooms,hoursNumber,timeSlot,room2,room1,indexi2)
# 	secondObjectiv=secondObjectiv + exchangeR(-1,visitors,rooms,hoursNumber,timeSlot,room1,room2,indexr1)
# 	secondObjectiv=secondObjectiv + exchangeR(-1,visitors,rooms,hoursNumber,timeSlot,room2,room1,indexr2)
# 	secondObjectiv=secondObjectiv + exchangeI(1,visitors,rooms,hoursNumber,timeSlot,room1,room2,indexi1)
# 	secondObjectiv=secondObjectiv + exchangeI(1,visitors,rooms,hoursNumber,timeSlot,room2,room1,indexi2)
# 	secondObjectiv=secondObjectiv + exchangeR(1,visitors,rooms,hoursNumber,timeSlot,room1,room2,indexr1)
# 	secondObjectiv=secondObjectiv + exchangeR(1,visitors,rooms,hoursNumber,timeSlot,room2,room1,indexr2)
# 	g = secondObjectiv
# end
#
# function swapMeeting!(visitors, rooms, hoursNumber, room1, room2, timeSlot) #Cross two meetings
# 	#pre-requis: les rendez vous fixé aux lieux room1 et room2 eu temps timeSlot existent
# 	RDV=RoomSchedule[room1][timeSlot]
# 	indexi1 = RDV[1]
# 	indexr1 = RDV[2]
# 	RDV=RoomSchedule[room2][timeSlot]
# 	indexi2 = RDV[1]
# 	indexr2 = RDV[2]
# 	secondObjectiv=g
#
# 	if meetings[indexi1][indexr2][1] == 0 && meetings[indexi2][indexr1][1] == 0
# 		f = f - visitors[1][indexi1][indexr1] - visitors[1][indexi2][indexr2] + visitors[1][indexi1][indexr2] + visitors[1][indexi2][indexr1]
# 		g1 = secondObjectiv+exchangeI(-1,visitors,rooms,hoursNumber,timeSlot,room1,room2,indexi1)
# 		g1 = g1 + exchangeI(1,visitors,rooms,hoursNumber,timeSlot,room1,room2,indexi1)
# 		g1 = secondObjectiv+exchangeI(-1,visitors,rooms,hoursNumber,timeSlot,room1,room2,indexi2)
# 		g1 = g1 + exchangeI(1,visitors,rooms,hoursNumber,timeSlot,room1,room2,indexi2)
# 		g2 = secondObjectiv+exchangeR(-1,visitors,rooms,hoursNumber,timeSlot,room1,room2,indexr1)
# 		g2 = g2 + exchangeR(1,visitors,rooms,hoursNumber,timeSlot,room1,room2,indexr1)
# 		g2 = secondObjectiv+exchangeR(-1,visitors,rooms,hoursNumber,timeSlot,room1,room2,indexr2)
# 		g2 = g2 + exchangeR(1,visitors,rooms,hoursNumber,timeSlot,room1,room2,indexr2)
# 		if g1 < g2
# 			x[indexi1][indexr1][room1][timeSlot]=0
# 			x[indexi2][indexr1][room1][timeSlot]=1
# 			x[indexi1][indexr2][room2][timeSlot]=1
# 			x[indexi2][indexr2][room2][timeSlot]=0
# 			g = g1
# 		else
# 			x[indexi1][indexr1][room1][timeSlot]=0
# 			x[indexi2][indexr2][room2][timeSlot]=0
# 			x[indexi1][indexr2][room1][timeSlot]=1
# 			x[indexi2][indexr1][room2][timeSlot]=1
# 			g = g2
# 		end
# 	end
# end
#
# function delayMeeting(visitors, rooms, hoursNumber, room, timeSlot1, timeSlot2)
# RDV = RoomSchedule[room][timeSlot1]
# indexi = RDV[1]
# indexr = RDV[2]
# if IndstrialistSchedule[indexi][timeSlot2] == 0 && ResearcherSchedule[indexr][timeSlot2] == 0
# 	available = false
# 	s = 1
# 	while !available && s <= rooms[2]
# 		if RoomSchedule[s][timeSlot2][1] == 0
# 			available = true
# 			indexs = s
# 		end
# 		s = s+1
# 	end
# 	if available
#
# 		x[indexi][indexr][room][timeSlot1]=0
# 		x[indexi][indexr][indexs][timeSlot2]=1
#
# 		secondObjectiv = g
# 		secondObjectiv = secondObjectiv + exchangeI(-1, visitors, rooms, hoursNumber, timeSlot1, room, 0, indexi)
# 		secondObjectiv = secondObjectiv + exchangeI(-1, visitors, rooms, hoursNumber, timeSlot2, 0, indexs, indexi)
# 		secondObjectiv = secondObjectiv + exchangeR(-1, visitors, rooms, hoursNumber, timeSlot1, room, 0, indexr)
# 		secondObjectiv = secondObjectiv + exchangeR(-1, visitors, rooms, hoursNumber, timeSlot2, 0, indexs, indexr)
# 		secondObjectiv = secondObjectiv + exchangeI(1, visitors, rooms, hoursNumber, timeSlot1, room, 0, indexi)
# 		secondObjectiv = secondObjectiv + exchangeI(1, visitors, rooms, hoursNumber, timeSlot2, 0, indexs, indexi)
# 		secondObjectiv = secondObjectiv + exchangeR(1, visitors, rooms, hoursNumber, timeSlot1, room, 0, indexr)
# 		secondObjectiv = secondObjectiv + exchangeR(1, visitors, rooms, hoursNumber, timeSlot2, 0, indexs, indexr)
# 		g = secondObjectiv
# 	end
# end
