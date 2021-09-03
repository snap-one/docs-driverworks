-- Copyright 2021 Snap One, LLC. All rights reserved.

require ('drivers-common-public.global.lib')
require ('drivers-common-public.global.timer')
require ('drivers-common-public.global.handlers')

do	--Globals
	IDC_BINDING = 1

	Settings = Settings or {}

	UserVariables = {
		{name = 'DEVICE_ID',		varType = 'NUMBER',		hidden = true},		--1001
		{name = 'PROXY_ID',			varType = 'NUMBER',		hidden = true},		--1002
		{name = 'DRIVER_VERSION',	varType = 'STRING',		hidden = true},		--1003
		{name = 'API_DEVICE_ID',	varType = 'STRING',		hidden = true},		--1004
	}

	UV = {}

	for i, tab in ipairs (UserVariables) do
		UserVariables [i + 1000] = tab
		UV [tab.name] = i + 1000
	end
end

function EC.AddClientDevices (tParams)
	local apiClients = {}
	for k, v in pairs (tParams) do
		if (v ~= '') then
			local device = {
				id = v,
				name = 'Client ' .. v .. ' - AutoAdded',
				type = 'Media Player Client',
			}
			table.insert (apiClients, device)
		end
	end
	AddClientDrivers (apiClients)
end

function EC.API_COMMAND (tParams)
	local deviceId = tParams.deviceId
	local payload = Deserialize (tParams.payload)

	print ('Received API_COMMAND as device command:')
	print (deviceId)
	Print (payload)
end

function EC.Send_Command_To_Client (tParams)
	local id = tParams.ID
	local command = tParams.Command
	local commandType = tParams.Type

	for _, settings in pairs (Settings) do
		if (settings [UV.API_DEVICE_ID] == id) then
			local deviceId = settings [UV.DEVICE_ID]
			local proxyId = settings [UV.PROXY_ID]

			if (commandType == 'Proxy') then
				C4:SendToDevice (proxyId, 'UPDATE_DEVICE', {command = command})
			elseif (commandType == 'Device') then
				C4:SendToDevice (deviceId, 'UPDATE_DEVICE', {command = command})
			end
		end
	end
end

function EC.Send_Command_To_All_Clients (tParams)
	local command = tParams.Command
	C4:SendToProxy (IDC_BINDING, 'UPDATE_DEVICE', {command = command})
end

function OnBindingChanged (idBinding, strClass, bStatus)
	if (DEBUGPRINT) then
		local output = {'--- OnBindingChanged: ' .. idBinding, strClass, tostring (bStatus)}
		output = table.concat (output, '\r\n')
		print (output)
		C4:DebugLog (output)
	end

	SetTimer ('CheckBindings', ONE_SECOND)
end

function OnDriverDestroyed ()
	for deviceId, _ in pairs (Settings or {}) do
		for name, idVariable in pairs (UV) do
			C4:UnregisterVariableListener (deviceId, idVariable)
		end
	end
end

function OnDriverLateInit ()
	PersistData = PersistData or {}

	KillAllTimers ()

	DEVICE_ID = C4:GetDeviceID ()

	for property, _ in pairs (Properties) do
		OnPropertyChanged (property)
	end

	SetTimer ('CheckBindings', 5000)
end

function OPC.Debug_Mode (value)
	CancelTimer ('DEBUGPRINT')
	DEBUGPRINT = (value == 'On')

	if (DEBUGPRINT) then
		local _timer = function (timer)
			C4:UpdateProperty ('Debug Mode', 'Off')
			OnPropertyChanged ('Debug Mode')
		end
		SetTimer ('DEBUGPRINT', 36000000, _timer)
	end
end

function OPC.Driver_Version (value)
	local version = C4:GetDriverConfigInfo ('version')
	C4:UpdateProperty ('Driver Version', version)
end

function OnWatchedVariableChanged (idDevice, idVariable, strValue)
	if (DEBUGPRINT) then
		local output = {'--- OnWatchedVariableChanged: ' .. idDevice, idVariable, strValue}
		output = table.concat (output, '\r\n')
		print (output)
		C4:DebugLog (output)
	end

	if (Settings and Settings [idDevice]) then
		if (UserVariables [idVariable].varType == 'NUMBER') then
			Settings [idDevice] [idVariable] = tonumber (strValue)

		elseif (UserVariables [idVariable].varType == 'BOOL') then
			Settings [idDevice] [idVariable] = ((strValue == '1' or string.lower (strValue) == 'true') and true) or false

		else
			Settings [idDevice] [idVariable] = strValue
		end
	end
end

function RFP.API_COMMAND (idBinding, strCommand, tParams, args)
	local deviceId = tParams.deviceId
	local payload = Deserialize (tParams.payload)

	print ('Received API_COMMAND as proxy command:')
	print (deviceId)
	Print (payload)
end

function CheckBindings ()
	Settings = {}
	for deviceId, _ in pairs (C4:GetBoundConsumerDevices (DEVICE_ID, 1) or {}) do
		local proxy = C4:GetBoundProviderDevice (deviceId, 5001)
		GetSettings (proxy)
	end
end

function GetSettings (idDevice)
	Settings [idDevice] = {}
	for name, idVariable in pairs (UV) do
		local strValue = C4:GetDeviceVariable (idDevice, idVariable)

		if (UserVariables [idVariable].varType == 'NUMBER') then
			Settings [idDevice] [idVariable] = tonumber (strValue)

		elseif (UserVariables [idVariable].varType == 'BOOL') then
			Settings [idDevice] [idVariable] = ((strValue == '1' or string.lower (strValue) == 'true') and true) or false

		else
			Settings [idDevice] [idVariable] = strValue
		end

		C4:UnregisterVariableListener (idDevice, idVariable)
		C4:RegisterVariableListener (idDevice, idVariable)
	end
end

function GetCommandList (currentValue, callbackWhenDone, search, filter)
	local list = {
		'BACK',
		'CANCEL',
		'CLOSED_CAPTIONED',
		'CONTROL4',
		'CUSTOM_1',
		'CUSTOM_2',
		'CUSTOM_3',
		'DASH',
		'DOWN',
		'EJECT',
		'ENTER',
		'EXIT',
		'FUNCTION',
		'GUIDE',
		'INFO',
		'LEFT',
		'MENU',
		'MUTE_OFF',
		'MUTE_ON',
		'MUTE_TOGGLE',
		'NUMBER_0',
		'NUMBER_1',
		'NUMBER_2',
		'NUMBER_3',
		'NUMBER_4',
		'NUMBER_5',
		'NUMBER_6',
		'NUMBER_7',
		'NUMBER_8',
		'NUMBER_9',
		'OPEN_CLOSE',
		'ORDER',
		'PAUSE',
		'PIP',
		'PLAY',
		'PLAYPAUSE',
		'POUND',
		'POWER',
		'PROGRAM_A',
		'PROGRAM_B',
		'PROGRAM_C',
		'PROGRAM_D',
		'PVR',
		'RECALL',
		'RECORD',
		'RIGHT',
		'ROOM_OFF',
		'SKIP_FWD',
		'SKIP_REV',
		'STAR',
		'START_CH_DOWN',
		'START_CH_UP',
		'START_PAGE_DOWN',
		'START_PAGE_UP',
		'START_SCAN_FWD',
		'START_SCAN_REV',
		'START_VOL_DOWN',
		'START_VOL_UP',
		'STOP',
		'STOP_CH_DOWN',
		'STOP_CH_UP',
		'STOP_PAGE_DOWN',
		'STOP_PAGE_UP',
		'STOP_SCAN_FWD',
		'STOP_SCAN_REV',
		'STOP_VOL_DOWN',
		'STOP_VOL_UP',
		'UP',
	}

	return list
end

function AddClientDrivers (apiClients)
	if (not (VersionCheck ('3.2.0'))) then
		print ('Add Driver functionality requires C4 OS 3.2.0 or later')
		return
	end

	if (Timer.AddClientsFlag) then return end

	SetTimer ('AddClientsFlag', 30 * ONE_SECOND)

	ConfiguredClientDrivers = {}
	UnconfiguredClientDrivers = {}

	for deviceId, _ in pairs (C4:GetDevicesByC4iName ('idc_client.c4z') or {}) do
		local apiDeviceId = C4:GetDeviceVariable (deviceId, UV.API_DEVICE_ID)
		if (apiDeviceId and apiDeviceId ~= '') then
			ConfiguredClientDrivers [apiDeviceId] = deviceId
		else
			table.insert (UnconfiguredClientDrivers, deviceId)
		end
	end

	print ('Adding client drivers')

	local devicesToAdd = {}

	for _, client in pairs (apiClients) do
		local apiDeviceId = client.id
		if (apiDeviceId) then
			if (ConfiguredClientDrivers [apiDeviceId] == nil) then
				table.insert (devicesToAdd, client)
			end
		end
	end

	AddNextClient (devicesToAdd)
end

function AddNextClient (devicesToAdd)

	local client = table.remove (devicesToAdd)

	if (client) then
		local id = client.id
		local deviceType = client.type
		local deviceName = client.name

		local _addNextDevice = function (timer)
			AddNextClient (devicesToAdd)
		end

		if (ConfiguredClientDrivers [id]) then
			SetTimer (nil, 100, _addNextDevice)

		else
			local _onAdded = function (deviceId, tParams)
				if (deviceId == 0) then
					print ('Could not install driver!')
				else
					C4:Bind (DEVICE_ID, 1, deviceId, 1, 'IDC')

					local _setupClient = function (timer)
						local contextInfo = {
							clientInfo = Serialize (client),
						}
						C4:SendToDevice (deviceId, 'AddClient', contextInfo)
					end
					SetTimer (nil, 10 * ONE_SECOND, _setupClient)
				end
				SetTimer (nil, 5 * ONE_SECOND, _addNextDevice)
			end

			local unconfiguredClient = table.remove (UnconfiguredClientDrivers)

			if (unconfiguredClient) then
				C4:RenameDevice (unconfiguredClient, deviceName)
				_onAdded (unconfiguredClient, {})

			else
				C4:AddDevice ('idc_client.c4z', C4:RoomGetId (), deviceName, _onAdded)
			end
		end
		return
	end

	CancelTimer ('AddClientsFlag')
	ConfiguredClientDrivers = nil
	UnconfiguredClientDrivers = nil
	print ('All client drivers added')
end

