--Copyright 2019 Control4 Corporation. All rights reserved.

--MERGE
function OnDriverInit ()
	PASSTHROUGH_PROXY = 5001		-- set this to the proxy ID that should handle all passthrough commands from minidrivers
	SWITCHER_PROXY = 5999			-- set this to the proxy ID of the SET_INPUT capable device that has the RF_MINI_APP connections (may be the same as PASSTHROUGH_PROXY)
	USES_DEDICATED_SWITCHER = true	-- set this to false if the driver did not need the dedicated avswitch proxy (e.g. this is a TV/receiver)
	MINIAPP_BINDING_START = 3101	-- set this to the first binding ID in the XML for the RF_MINI_APP connections
	MINIAPP_BINDING_END = 3125		-- set this to the last binding ID in the XML for the RF_MINI_APP connections
	MINIAPP_TYPE = 'UM_ROKU'		-- set this to your unique name as defined in the minidriver SERVICE_IDS table
end

--MERGE
function OnDriverLateInit ()
	if (USES_DEDICATED_SWITCHER) then
		HideProxyInAllRooms (SWITCHER_PROXY)
	end
	RegisterRooms ()
end

--MERGE
function OnSystemEvent (event)
	local eventname = string.match (event, '.-name="(.-)"')
	if (eventname == 'OnPIP') then
		RegisterRooms ()
	end
end

--MERGE
function OnWatchedVariableChanged (idDevice, idVariable, strValue)
	if (RoomIDs and RoomIDs [idDevice]) then
		local roomId = tonumber (idDevice)
		if (idVariable == 1000) then
			local deviceId = tonumber (strValue) or 0
			RoomIDSources [roomId] = deviceId
		end
	end
end

--MERGE
function ReceivedFromProxy (idBinding, strCommand, tParams)
	if (idBinding == nil or strCommand == nil) then
		return	-- this shouldn't happen, but is a good defensive programming practice
	end

	if (tParams == nil) then
		tParams = {}	-- this often happens, especially with basic transport commands.  This protects against nil table referencing.
	end

	-- this test should be included before any other logic tests the value of idBinding; it is required for passthrough mode to work
	if (idBinding == SWITCHER_PROXY and strCommand == 'PASSTHROUGH') then
		idBinding = PASSTHROUGH_PROXY
		strCommand = tParams.PASSTHROUGH_COMMAND
	end

	if (idBinding == SWITCHER_PROXY) then
		if (strCommand == 'SET_INPUT') then
			local input = tonumber (tParams.INPUT)
			if (input >= MINIAPP_BINDING_START and input <= MINIAPP_BINDING_END) then
				-- Get the device ID of the proxy handling the miniapp switch on this driver
				local proxyDeviceId, _ = next (C4:GetBoundConsumerDevices (C4:GetDeviceID (), idBinding))

				-- Get the device ID of the minidriver proxy connected to the requested input on this driver
				local appProxyId = C4:GetBoundProviderDevice (proxyDeviceId, input)

				-- Get the device ID of the minidriver protocol connected to the minidriver proxy
				local appDeviceId = C4:GetBoundProviderDevice (appProxyId, 5001)

				-- get the details for the app for this kind of universal-minidriver-compatible type
				local appId = GetRelevantUniversalAppId (appDeviceId, MINIAPP_TYPE)
				local appName = GetRelevantUniversalAppId (appDeviceId, 'APP_NAME')

				-- there is now enough information to launch the application using the protocol for this device

				-- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
				-- =-=-=-=-=-=-=-= YOUR DEVICE-SPECIFIC APP LAUNCHING CODE GOES HERE... -=-=-=-=-=-=-=
				-- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

				-- there is now enough information to launch the application using the protocol for this device

				if ((Properties ['Passthrough Mode'] or 'On') ~= 'On') then
					local passthroughProxyDeviceId, _ = next (C4:GetBoundConsumerDevices (C4:GetDeviceID (), PASSTHROUGH_PROXY))
					local _timer = function (timer)
						print ('Looking for ' .. appProxyId)
						for roomId, deviceId in pairs (RoomIDSources) do
							if (deviceId == appProxyId) then
								C4:SendToDevice (roomId, 'SELECT_VIDEO_DEVICE', {deviceid = passthroughProxyDeviceId})
							end
						end
					end
					C4:SetTimer (500, _timer)
				end
			end
		end
	end
end

--COPY
function GetRelevantUniversalAppId (deviceId, source)
	local vars = C4:GetDeviceVariables (deviceId)
	for _, var in pairs (vars) do
		if (var.name == source) then
			return (var.value)
		end
	end
	if (source ~= 'APP_ID') then
		-- try getting pre-universal minidriver app ID to launch.
		return (GetRelevantUniversalAppId (deviceId, 'APP_ID'))
	end
end

--COPY
function HideProxyInAllRooms (idBinding)
	idBinding = idBinding or 0
	if (idBinding == 0) then return end -- silently fail if no binding passed in

	-- Get Bound Proxy's Device ID / Name.
	local id, name = next (C4:GetBoundConsumerDevices (C4:GetDeviceID (), idBinding))

	dbg ('Hiding ' .. name .. ' in all rooms')

	-- Send hide command to all rooms, for 'ALL' Navigator groups.
	for roomId, roomName in pairs (C4:GetDevicesByC4iName ('roomdevice.c4i') or {}) do
		dbg ('Hiding ' .. name .. ' in ' .. roomName)
		C4:SendToDevice (roomId, 'SET_DEVICE_HIDDEN_STATE', {PROXY_GROUP = 'ALL', DEVICE_ID = id, IS_HIDDEN = true})
	end
end

--COPY
function RegisterRooms ()
	RoomIDs = C4:GetDevicesByC4iName ('roomdevice.c4i')
	RoomIDSources = {}
	for roomId, _ in pairs (RoomIDs) do
		RoomIDSources [roomId] = tonumber (C4:GetDeviceVariable (roomId, 1000)) or 0
		C4:UnregisterVariableListener (roomId, 1000)
		C4:RegisterVariableListener (roomId, 1000)
	end
end
