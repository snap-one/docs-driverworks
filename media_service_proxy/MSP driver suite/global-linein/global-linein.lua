--	Copyright 2015 Control4 Corporation. All rights reserved.
function ExecuteCommand (strCommand, tParams)
	if (strCommand == 'LUA_ACTION' and tParams and tParams.ACTION) then
		if (tParams.ACTION == 'NextPlayer') then	--this iterates with every selection of the action over the list of players received from the network
			local exists, name
			for _, device in ipairs (Devices) do
				exists = true
				if (PrimaryDevice == nil) then
					PrimaryDevice = device.deviceID
					PersistData.PrimaryDevice = PrimaryDevice
					name = device.name
					break
				elseif (device.deviceID == PrimaryDevice) then
					PrimaryDevice = nil
					PersistData.PrimaryDevice = nil
				end
			end

			if (PrimaryDevice == nil) then
				if (exists) then
					ExecuteCommand ('LUA_ACTION', {ACTION = 'NextPlayer'})
					return
				end
			end

			C4:UpdateProperty ('Connected Player', name or 'No Player connected')
			Timer.PushSettings = AddTimer (Timer.PushSettings, 5, 'SECONDS')

		end
	end
end

function OnDriverLateInit ()
	KillAllTimers ()
	if (C4.AllowExecute) then C4:AllowExecute (true) end

	C4:urlSetTimeout (20)

	DEVICEID = C4:GetProxyDevices ()

	if (not PersistData) then PersistData = {} end

	PrimaryDevice = PersistData.PrimaryDevice
	PersistData.PrimaryDevice = PrimaryDevice

	Timer.PushSettings = AddTimer (Timer.PushSettings, 5, 'SECONDS')

	for k,v in pairs(Properties) do
		OnPropertyChanged(k)
	end
end


function OnTimerExpired (idTimer)
	if (idTimer == Timer.PushSettings) then -- collects information about the device this line in device is connected to in C4 and then pushes it back to the network
		local target = 0
		local consumer = C4:GetBoundConsumerDevices (DEVICEID, 4001)
		for device, _ in pairs (consumer or {}) do
			if (target ~= 0) then
				print ('Connected to too many networks')
			end
			target = device
		end

		local source = C4:GetBoundProviderDevice (DEVICEID, 3001)

		if (target ~= 0) then
			C4:SendToDevice (target, 'LINE_IN_DEVICE', {source_zp_device = PrimaryDevice, deviceID = DEVICEID, source_device = source})
		else
			print ('Not connected to any networks')
		end
	end
end

function ReceivedFromProxy (idBinding, strCommand, tParams)
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

	if (strCommand == 'BINDING_CHANGE_ACTION') then
		Timer.PushSettings = AddTimer (Timer.PushSettings, 5, 'SECONDS')

	elseif (strCommand == 'XXYYZZ_DEVICES') then -- this is where the network populates the list of all connected players
		Devices = {}
		for deviceID, name in pairs (tParams) do
			table.insert (Devices, {deviceID = deviceID, name = name})
		end
		if (PrimaryDevice) then
			local found
			for _, device in pairs (Devices) do
				if (device.deviceID == PrimaryDevice) then
					found = true
					break
				end
			end
			if (found) then
				print ('Selected Player found on system')
				Timer.PushSettings = AddTimer (Timer.PushSettings, 5, 'SECONDS')
			else
				print ('Selected Player not found on system')
			end
		end
		if (not PrimaryDevice) then
			ExecuteCommand ('LUA_ACTION', {ACTION = 'NextPlayer'})
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
