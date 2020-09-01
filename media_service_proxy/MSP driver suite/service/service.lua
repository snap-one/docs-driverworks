--	Copyright 2015 Control4 Corporation. All rights reserved.
function OnDriverLateInit ()
	if (C4.AllowExecute) then C4:AllowExecute (true) end

	C4:urlSetTimeout (20)

	DEVICEID = C4:GetProxyDevices ()

	RoomIDs = C4:GetDevicesByC4iName ('roomdevice.c4i')
	RoomIDSources = {}
	for roomID, _ in pairs (RoomIDs) do
		RoomIDSources [roomID] = tonumber (C4:GetDeviceVariable (roomID, 1000)) or 0
	end
	for roomID, roomName in pairs (RoomIDs) do
		C4:RegisterVariableListener (roomID, 1000)
	end

	for k,v in pairs(Properties) do
		OnPropertyChanged(k)
	end
end

function OnWatchedVariableChanged (idDevice, idVariable, strValue)
	if (RoomIDs [idDevice]) then
		if (idVariable == 1000) then
			RoomIDSources [idDevice] = tonumber (strValue or 0)
		end
	end
end

function Navigator:Create (navId)
	function n:PlayCommand (idBinding, seq, args) -- asssume this is your play command from the service driver that should trigger something to play
		args.DEVICEID = DEVICEID

		local current_source = RoomIDSources [n._room]

		local current_netdevice = C4:GetBoundConsumerDevices (current_source, 4003) or {} -- this checks to see if the currently selected source in the room is (a) a PLAYER and (b) connected to the same network driver

		if (current_netdevice [NET_DEVICE]) then	--we tell the current player in the room directly what to play
			C4:SendToDevice (current_source, 'TO_PLAY', args)
		else 										--we tell the network driver what to play and then tell Director to select *this* device in the room
			C4:SendToDevice (NET_DEVICE, 'TO_PLAY', args)
			C4:SendToDevice (n._room, 'SELECT_AUDIO_DEVICE', {deviceid = DEVICEID})
		end
		return {}
	end
end
