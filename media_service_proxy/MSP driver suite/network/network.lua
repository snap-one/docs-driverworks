--	Copyright 2015 Control4 Corporation. All rights reserved.
do	--Globals
	Bindings = {}
	ReverseBindings = {}
	Devices = {}
	ToPlay = {}
end

function ExecuteCommand (strCommand, tParams)
	if (strCommand == 'LUA_ACTION' and tParams and tParams.ACTION) then
		if (tParams.ACTION == 'NextPlayer') then	--this iterates with every selection of the action over the list of players connected to this network
			local found, selectnext, selectfirst
			if (not PrimaryDevice) then
				selectfirst = true
			end
			for i = 3101, 3132 do
				if ((selectnext or selectfirst) and Bindings [i]) then
					PrimaryDevice = Bindings [i]
					PersistData.PrimaryDevice = PrimaryDevice
					found = true
					break
				elseif (PrimaryDevice and Bindings [i] == PrimaryDevice) then
					selectnext = true
				end
			end

			if ((selectnext and not found) or (PrimaryDevice and not (Devices[PrimaryDevice]))) then
				PrimaryDevice = nil
				PersistData.PrimaryDevice = PrimaryDevice
				ExecuteCommand ('LUA_ACTION', {ACTION = 'NextPlayer'})
				return
			end

			local name
			if (PrimaryDevice and Devices [PrimaryDevice]) then
				name = Devices [PrimaryDevice].NAME
			end

			C4:UpdateProperty ('Primary Player', name or 'No Players connected')
			Timer.GetSettings = AddTimer (Timer.GetSettings, 1, 'SECONDS')
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

	AVAILABLE = {}					--table that is initialized to contain the binding IDs of this driver
	for i = 3001, 3032 do
		table.insert (AVAILABLE, i)
	end
	for i = 3101, 3132 do
		table.insert (AVAILABLE, i)
	end
	for i = 3201, 3232 do
		table.insert (AVAILABLE, i)
	end
	for i = 4001, 4032 do
		table.insert (AVAILABLE, i)
	end

	CheckBindings ()

	for k,v in pairs(Properties) do
		OnPropertyChanged(k)
	end
end

function OnTimerExpired (idTimer)
	if (idTimer == Timer.CheckSettings) then
		CheckSettings ()

	elseif (idTimer == Timer.PushSettings) then
		PushSettings ()

	elseif (idTimer == Timer.GetSettings) then
		GetSettings ()

	elseif (idTimer == Timer.CheckBindings) then
		CheckBindings ()
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
		Timer.CheckBindings = AddTimer (Timer.CheckBindings, 1, 'SECONDS')

	elseif (strCommand == 'SET_INPUT') then
		local input = tonumber (tParams.INPUT)
		local output = tonumber (tParams.OUTPUT)
		C4:SendToProxy (5001, 'INPUT_OUTPUT_CHANGED', {INPUT = input, OUTPUT = output})
		if (ToPlay [input]) then
			local target = Bindings [output]
			C4:SendToDevice (target, 'TO_PLAY', ToPlay [input])
			if (input > 3200 and input < 4000) then
				ToPlay [input] = nil --only zero out this info if it's from a service driver; if it's the line in or msp zone out, we want to keep that info as it's static
			end
		end

	elseif (strCommand == 'SETTINGS') then
		local ms_proxy = tonumber (tParams.MS_PROXY or '')
		local amp_proxy = tonumber (tParams.AMP_PROXY or '')

		if (ms_proxy and amp_proxy and tParams.UUID) then
			local amp_binding, ms_binding
			for binding, device in pairs (Bindings) do
				if (device == ms_proxy) then ms_binding = binding
				elseif (device == amp_proxy) then amp_binding = binding
				end
			end

			ToPlay [ms_binding] = {uri = 'x-rincon:' .. tParams.UUID, class = 'object.item.audioItem'} --this is the line where we handle grouping; this is essentially the command that the "slave" player will receive to select the "master" player in line 120 above.

			Devices [ms_proxy] = {}
			Devices [amp_proxy] = {}
			for k, v in pairs (tParams) do
				Devices [ms_proxy] [k] = v
				Devices [amp_proxy] [k] = v
			end

			Devices [ms_proxy].TYPE = 'MS'
			Devices [amp_proxy].TYPE = 'AMP'

			if (ms_proxy == PrimaryDevice) then
				C4:UpdateProperty ('Primary Player', Devices [PrimaryDevice].NAME or 'No Players connected')
			end
		end

		Timer.CheckSettings = AddTimer (CheckSettings, 1, 'SECONDS', false)

	elseif (strCommand == 'LINE_IN_DEVICE') then
		local deviceID = tonumber (tParams.deviceID)
		local source_zp_device = tonumber (tParams.source_zp_device)
		local source_device = tonumber (tParams.source_device)
		local binding = ReverseBindings [tonumber (deviceID)]
		if (binding) then
			if (source_zp_device and Devices [source_zp_device]) then
				Devices [source_zp_device].LINE_IN_DEVICE = source_device
				ToPlay [binding] = {uri = Devices [source_zp_device].UUID}

				local line_in_devices_list = {}
				for deviceID, info in pairs (Devices) do
					if (info.TYPE == 'MS') then
						line_in_devices_list [info.UUID] = info.LINE_IN_DEVICE
					end
				end

				for binding, target in pairs (Bindings) do
					if (binding > 3100 and binding < 3200) then 				--this is a media service proxy
						C4:SendToDevice (target, 'LINE_IN_DEVICES', line_in_devices_list)
					end
				end

			else
				ToPlay [binding] = nil
			end
		end
	elseif (strCommand == 'TO_PLAY') then
		local binding = ReverseBindings [tonumber (tParams.DEVICEID or 0)]
		if (binding) then
			ToPlay [binding] = tParams
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

function CheckBindings ()
	for _, binding in pairs (AVAILABLE) do
		local target = 0
		if (binding > 4000) then
			local consumer = C4:GetBoundConsumerDevices (DEVICEID, binding)
			for device, _ in pairs (consumer or {}) do
				if (target ~= 0) then
					print ('Too many connections on binding ' .. binding)
				end
				target = device
			end
		else
			target = C4:GetBoundProviderDevice (DEVICEID, binding)
		end

		target = tonumber (target)

		local old_device = Bindings [binding]

		if (target ~= 0) then --if something is connected to this binding now
			Bindings [binding] = target
			ReverseBindings [target] = binding

			if ((binding > 3100 and binding < 3200) or (binding > 4000)) then 		--this is a msp driver (zoneplayer or service)
				Timer.GetSettings = AddTimer (Timer.GetSettings, 1, 'SECONDS')
			end

		else
			Bindings [binding] = nil
			ToPlay [binding] = nil
			for t, b in pairs (ReverseBindings) do
				if (b == binding) then
					ReverseBindings [t] = nil
				end
			end
			if (PrimaryDevice and old_device == PrimaryDevice) then
				PrimaryDevice = nil
				PersistData.PrimaryDevice = PrimaryDevice
			end
			if (old_device) then
				Devices [old_device] = nil
			end
		end
	end
	Timer.CheckSettings = AddTimer (Timer.CheckSettings, 2, 'SECONDS')
end

function CheckSettings ()
	if (not (PrimaryDevice and Devices [PrimaryDevice])) then		-- if we don't already have a selected device, get one
		ExecuteCommand ('LUA_ACTION', {ACTION = 'NextPlayer'})
	end
	Timer.PushSettings = AddTimer (Timer.PushSettings, 2, 'SECONDS')
end

function GetSettings ()
	for i = 3101, 3132 do
		if (Bindings [i]) then
			C4:SendToDevice (Bindings [i], 'GET_SETTINGS', {}) --connect to the MSP proxy
		end
	end
	for i = 4001, 4032 do
		if (Bindings [i]) then
			C4:SendToDevice (Bindings [i], 'GET_SETTINGS', {}) --connect to the AMP proxy
		end
	end
end

function PushSettings ()

	local settings

	if (PrimaryDevice and Devices and Devices [PrimaryDevice]) then
		settings = {}
		for k, v in pairs (Devices [PrimaryDevice]) do
			settings [k] = v
		end
		settings.TYPE = nil
		settings.BINDING = nil
		settings.DEVICE = PrimaryDevice
		settings.NET_DEVICE = DEVICEID
	else
		C4:UpdateProperty ('Primary Player', 'No Players connected')
	end

	local devices_list = {}
	local auto_on_list = {}
	local override_list = {}
	local device_names_list = {}
	local line_in_devices_list = {}
	for deviceID, info in pairs (Devices) do
		if (info.TYPE == 'MS') then
			devices_list [info.UUID] = deviceID
			device_names_list [tostring (deviceID)] = info.NAME
			auto_on_list [info.UUID] = info.AUTO_ON_ROOMS
			override_list [info.UUID] = info.OVERRIDEROOM
			line_in_devices_list [info.UUID] = info.LINE_IN_DEVICE
		end
	end

	for binding, target in pairs (Bindings) do
		if (binding > 3100 and binding < 3200) then 				--this is a media service proxy
			C4:SendToDevice (target, 'XXYYZZ_DEVICES', devices_list)
			C4:SendToDevice (target, 'AUTO_ON_ROOMS', auto_on_list)
			C4:SendToDevice (target, 'OVERRIDE_ROOMS', override_list)
			C4:SendToDevice (target, 'LINE_IN_DEVICES', line_in_devices_list)

		elseif (binding > 3000 and binding < 3100) then 			--this is a global line in
			C4:SendToDevice (target, 'XXYYZZ_DEVICES', device_names_list)

		elseif (binding > 3200 and binding < 3300) then 			--this is a music service
			if (settings) then
				C4:SendToDevice (target, 'SETTINGS', settings)
			end
		end
	end
end

