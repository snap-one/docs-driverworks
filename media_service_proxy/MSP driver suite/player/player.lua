--	Copyright 2015 Control4 Corporation. All rights reserved.
function OnDriverLateInit ()
	KillAllTimers ()
	if (C4.AllowExecute) then C4:AllowExecute (true) end

	C4:urlSetTimeout (20)

	DEVICEID, AMP_DEVICEID = C4:GetProxyDevices ()
	if (not PersistData) then PersistData = {} end

	CURRENT_DEVICE = PersistData.CURRENT_DEVICE

	RoomIDs = C4:GetDevicesByC4iName ('roomdevice.c4i')
	RoomIDSources = {}
	for roomID, _ in pairs (RoomIDs) do
		RoomIDSources [roomID] = tonumber (C4:GetDeviceVariable (roomID, 1000)) or 0
	end
	for roomID, roomName in pairs (RoomIDs) do
		C4:RegisterVariableListener (roomID, 1000)
	end

	for k, _ in pairs (Properties) do
		OnPropertyChanged (k)
	end
end

function OnPropertyChanged (strProperty)
	if (strProperty == 'Auto Power Rooms') then
		AUTO_ON_ROOMS = value
		if (value == '') then
			C4:SetPropertyAttribs ('Override Source Selection', 1)
			C4:UpdateProperty ('Override Source Selection', 'Disabled')
			OnPropertyChanged ('Override Source Selection')
		else
			C4:SetPropertyAttribs ('Override Source Selection', 0)
		end
		SendSettingsToNetwork ()

	elseif (strProperty == 'Override Source Selection') then
		OVERRIDEROOM = (value == 'Enabled')
		SendSettingsToNetwork ()

	end
end

function OnTimerExpired (idTimer)
	for roomID, timer in pairs (AutoOnTimer) do
		if (idTimer == timer) then
			C4:SendToDevice (roomID, 'SELECT_AUDIO_DEVICE', {deviceid = DEVICEID})
			return
		end
	end
end

function OnWatchedVariableChanged (idDevice, idVariable, strValue)
	if (RoomIDs [idDevice]) then
		local roomID = tonumber (idDevice)
		if (idVariable == 1000) then
			local deviceID = tonumber (strValue) or 0
			RoomIDSources [roomID] = deviceID
			if (deviceID == DEVICE_TO_OVERRIDE) then
				AutoOnTimer [roomID] = AddTimer (AutoOnTimer [roomID], 250, 'MILLISECONDS')
				DEVICE_TO_OVERRIDE = nil
			elseif (deviceID == AMP_DEVICEID) then
				AutoOnTimer [roomID] = AddTimer (AutoOnTimer [roomID], 250, 'MILLISECONDS')
			end
		end
	end
end

function ReceivedFromProxy (idBinding, strCommand, tParams)

	strCommand = strCommand or ''
	tParams = tParams or {}
	local args = {}
	if (tParams.ARGS) then
		local parsedArgs = C4:ParseXml(tParams.ARGS)
		for _, v in pairs(parsedArgs.ChildNodes) do
			args[v.Attributes.name] = v.Value
		end
		tParams.ARGS = nil
	end

	dbg (idBinding, strCommand)
	if (DEBUGPRINT) then Print (tParams) end
	if (DEBUGPRINT) then Print (args) end

	if (strCommand == 'GET_SETTINGS') then
		Dlna.BeginDiscovery (SONOS_DEVICE)
		SendSettingsToNetwork ()

	elseif (strCommand == 'SONOS_DEVICES') then
		print ('Sonos information received')
		SonosDevices = {}
		SonosUUIDs = {}
		for uuid, deviceID in pairs (tParams) do
			SonosDevices [uuid] = tonumber (deviceID)
			SonosUUIDs [tonumber (deviceID)] = uuid
		end

	elseif (strCommand == 'AUTO_ON_ROOMS') then
		AutoOnRoomsByUUID = {}
		for uuid, roomList in pairs (tParams) do
			AutoOnRoomsByUUID [uuid] = {}
			for id in string.gfind (roomList, '%d+') do
				id = tonumber (id)
				AutoOnRoomsByUUID [uuid] [id] = true
			end
		end

	elseif (strCommand == 'OVERRIDE_ROOMS') then
		OverrideRoomsByUUID = {}
		for uuid, override in pairs (tParams) do
			OverrideRoomsByUUID [uuid] = (string.lower (override) == 'true')
		end

	elseif (strCommand == 'LINE_IN_DEVICES') then
		SonosLineInDevices = {}
		for uuid, deviceID in pairs (tParams) do
			SonosLineInDevices [uuid] = tonumber (deviceID)
		end

	elseif (strCommand == 'TO_PLAY') then
		if (tParams and tParams.uri) then
			DEVICE_TO_OVERRIDE = tonumber (tParams.DEVICEID)

			-- tParams contains all the information that was present in the selected item in the music service driver
		end
	end
end

function AddTimer (timer, count, units, recur)
	local newTimer
	if (recur == nil) then recur = false end
	if (timer and timer ~= 0) then KillTimer (timer) end

	newTimer = C4:AddTimer (count, units, recur)
	return newTimer
end

function KillAllTimers ()

	for k,v in pairs (Timer or {}) do
		if (type (v) == 'number') then
			Timer [k] = KillTimer (Timer [k])
		end
	end

	for _, thisQ in pairs (Qs or {}) do
		if (thisQ.ConnectingTimer and thisQ.ConnectingTimer ~= 0) then thisQ.ConnectingTimer = KillTimer (thisQ.ConnectingTimer) end
		if (thisQ.ConnectedTimer and thisQ.ConnectedTimer ~= 0) then thisQ.ConnectedTimer = KillTimer (thisQ.ConnectedTimer) end
	end
end

function KillTimer (timer)
	if (timer and type (timer) == 'number') then
		return (C4:KillTimer (timer))
	else
		return (0)
	end
end

function Print (data)
	if (type (data) == 'table') then
		for k, v in pairs (data) do print (k, v) end
	elseif (type (data) ~= 'nil') then
		print (type (data), data)
	else
		print ('nil value')
	end
end

function SendToNetwork (strCommand, tParams)
	if (NETWORK_DEVICEID) then
		C4:SendToDevice (NETWORK_DEVICEID, strCommand, tParams)
	end
end

function SendSettingsToNetwork ()
	local amp_network = C4:GetBoundProviderDevice (AMP_DEVICEID, 3002)
	local zone_networks = C4:GetBoundConsumerDevices (DEVICEID, 4003)
	local zone_network = 0
	for device, _ in pairs (zone_networks or {}) do
		if (zone_network ~= 0) then
			Helper.DriverInfo ('Too many connections on RF_XXYYZZNET_ZONE Network Audio binding')
		end
		zone_network = tonumber (device)
	end

	NETWORK_DEVICEID = nil
	if (amp_network == 0 and zone_network == 0) then
		Helper.DriverInfo ('Error - Network not connected')
	elseif (amp_network == 0) then
		Helper.DriverInfo ('Error - Amp not connected to Network')
	elseif (zone_network == 0) then
		Helper.DriverInfo ('Error - Player not connected to Network')
	elseif (zone_network ~= amp_network) then
		Helper.DriverInfo ('Error - Amp and Player connected to different Networks')
	else
		NETWORK_DEVICEID = tonumber (zone_network)

		local settings = {} --this table builds up the settings that you need for connecting to this physical device from the service drivers and also for the auto power/override lists

		settings.IP = IP
		settings.PORT = PORT
		settings.SERIAL = SERIAL
		settings.NAME = ZONENAME
		settings.MS_PROXY = DEVICEID
		settings.AMP_PROXY = AMP_DEVICEID
		settings.UUID = CURRENT_DEVICE
		settings.HOUSEHOLD_ID = HOUSEHOLD_ID
		settings.AUTO_ON_ROOMS = AUTO_ON_ROOMS
		settings.OVERRIDEROOM = OVERRIDEROOM
		settings.MODEL = MODEL
		settings.VERSION = VERSION

		SendToNetwork ('SETTINGS', settings)
	end
end

