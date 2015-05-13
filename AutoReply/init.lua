count = {} --To keep track of poke count.
haspoked = {} --To index individual users.
poketime = {} --To save poke times.
maxpokes = 2 --Max number of pokes minus 1 (In this case 3;3-1=2).
maxtime = 180 --Interval in seconds in which the pokes will be accounted for.
recmsg = "Received your poke! Please don't poke me again, I'll respond whenever I can." --Message to be sent on poke receival.
kickmsg = "Don't abuse pokes!" --Message to be sent with kick.
function onClientPokeEvent(serverConnectionHandlerID, pokerID, pokerName, message, ffIgnored)
	if (pokerID ~= haspoked[pokerID]) then --Checks if there's a "record" of the poker
			haspoked[pokerID] = pokerID --Creates a record
			count[pokerID] = 1 --Sets his poke count to one
			poketime[pokerID] = os.time() --Records the time of first poke
			ts3.requestSendPrivateTextMsg(serverConnectionHandlerID, recmsg, pokerID) --Send message back.
	elseif(pokerID == haspoked[pokerID])then --If there is a record already
		  if (count[pokerID] >= maxpokes and os.difftime(poketime[pokerID],os.time()) <= maxtime) then --If the poker has poked over -maxpokes- times under maxtime interval.
			  ts3.requestClientKickFromServer(serverConnectionHandlerID,pokerID, kickmsg) --Kick poker with message.
			  poketime[pokerID] = os.time() --Reset timer.
			else
				if(os.difftime(poketime[pokerID],os.time()) > maxtime) then --If the interval between pokes is greater than maxtime.
					poketime[pokerID] = os.time --Reset timer.
				end
				ts3.requestSendPrivateTextMsg(serverConnectionHandlerID, recmsg, pokerID) --Sends message.
				count[pokerID] = count[pokerID]+1 --Increments poke count for the user.
	  	end
	end
end