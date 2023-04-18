-- Copyright 2023 Snap One, LLC. All rights reserved.

JSON = require ('drivers-common-public.module.json')

require ('drivers-common-public.global.lib')
require ('drivers-common-public.global.timer')
require ('drivers-common-public.global.handlers')

pcall (require, 'production.production')

do
	PROXY_BINDING = 5001
	IDC_BINDING = 1

	UserVariables = {
		{name = 'DEVICE_ID',		varType = 'NUMBER',		hidden = true},		--1001
		{name = 'PROXY_ID',			varType = 'NUMBER',		hidden = true},		--1002
		{name = 'DRIVER_VERSION',	varType = 'STRING',		hidden = true},		--1003
		{name = 'API_DEVICE_ID',	varType = 'STRING',		hidden = true},		--1004
	}
end

function EC.AddClient (tParams)
	local clientInfo = Deserialize (tParams.clientInfo)

	local id = clientInfo.id
	local clientName = clientInfo.name

	C4:RenameDevice (PROXY_ID, clientName)

	UpdateProperty ('ID', id)
	OnPropertyChanged ('ID')
end

function EC.UPDATE_DEVICE (tParams)
	print ('Received UPDATE_DEVICE as command:')
	Print (tParams)
end

function OnBindingChanged (idBinding, strClass, bStatus)
	if (DEBUGPRINT) then
		local output = {'--- OnBindingChanged: ' .. idBinding, strClass, tostring (bStatus)}
		output = table.concat (output, '\r\n')
		print (output)
		C4:DebugLog (output)
	end

	if (idBinding == IDC_BINDING) then
		IDC_CONTROLLER = C4:GetBoundProviderDevice (DEVICE_ID, IDC_BINDING)
	end
end

function OnDriverLateInit ()
	PersistData = PersistData or {}

	KillAllTimers ()

	DEVICE_ID = C4:GetDeviceID ()
	PROXY_ID = C4:GetProxyDevices ()

	for _, var in ipairs (UserVariables or {}) do
		local default = var.default
		if (default == nil) then
			if (var.varType == 'STRING') then default = ''
			elseif (var.varType == 'BOOL') then default = '0'
			elseif (var.varType == 'NUMBER') then default = 0
			end
		end
		local readOnly = (var.readOnly ~= nil and var.readOnly) or true
		local hidden = (var.hidden ~= nil and var.hidden) or false
		C4:AddVariable (var.name, default, var.varType, readOnly, hidden)
	end

	C4:SetVariable ('DEVICE_ID', DEVICE_ID)
	C4:SetVariable ('PROXY_ID', PROXY_ID)

	C4:SetVariable ('DRIVER_VERSION', C4:GetDriverConfigInfo ('version'))

	C4:SetVariable ('API_DEVICE_ID', PersistData.API_DEVICE_ID or '')

	IDC_CONTROLLER = C4:GetBoundProviderDevice (DEVICE_ID, IDC_BINDING)

	if (PersistData.API_DEVICE_ID) then
		C4:SendToProxy (IDC_BINDING, 'RESYNC_DATA', {deviceId = PersistData.API_DEVICE_ID})
	end

	for property, _ in pairs (Properties) do
		OnPropertyChanged (property)
	end
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

function OPC.ID (value)
	PersistData.API_DEVICE_ID = value
	C4:SetVariable ('API_DEVICE_ID', PersistData.API_DEVICE_ID)
	C4:SendToProxy (IDC_BINDING, 'RESYNC_DATA', {deviceId = PersistData.API_DEVICE_ID})
end

function OPC.Send_Command_Using (value)
	SEND_COMMAND = value
end

-- RFP by strCommand

function SendToIDCAsProxy (payload)
	C4:SendToProxy (IDC_BINDING, 'API_COMMAND', {deviceId = PersistData.API_DEVICE_ID, payload = Serialize (payload)})
end

function SendToIDCAsDevice (payload)
	C4:SendToDevice (IDC_CONTROLLER, 'API_COMMAND', {deviceId = PersistData.API_DEVICE_ID, payload = Serialize (payload)})
end

function RFP.UPDATE_DEVICE  (idBinding, strCommand, tParams, args)
	print ('Received UPDATE_DEVICE as proxy:')
	Print (tParams)
end

RFP [5001] = function (idBinding, strCommand, tParams, args)
	local payload = {
		strCommand = strCommand,
		tParams = tParams,
	}

	local r = math.random (0, 1)
	if (SEND_COMMAND == 'DeviceId' or (SEND_COMMAND == 'Random' and r == 0)) then
		SendToIDCAsDevice (payload)
	elseif (SEND_COMMAND == 'Binding' or (SEND_COMMAND == 'Random' and r == 1)) then
		SendToIDCAsProxy (payload)
	end

end
