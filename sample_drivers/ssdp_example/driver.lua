-- Copyright 2020 Control4 Corporation. All rights reserved.

SSDP = require ('drivers-common-public.module.ssdp')

function OnDriverDestroyed ()
	KillAllTimers ()

	if (Discovery) then
		Discovery:StopDiscovery ()
	end
end

function OnDriverLateInit ()
	KillAllTimers ()

	if (C4.AllowExecute) then C4:AllowExecute (not (PRODUCTION_LUA_VER)) end

	C4:urlSetTimeout (10)

	PersistData = PersistData or {}


	for property, _ in pairs (Properties) do
		OnPropertyChanged (property)
	end
end

function OPC.Driver_Version (value)
	UpdateProperty ('Driver Version', C4:GetDriverConfigInfo ('version'))
end

function OPC.Search_Target (value)
	if (Discovery) then
		Discovery:delete ()
	end

	Discovery = SSDP:new (value)
	Discovery.CurrentDeviceUUID = PersistData.CurrentDeviceUUID

	local _processXML = function (ssdp, uuid, data)
		print ('XML device data received for: ' .. uuid)
	end

	Discovery:SetProcessXMLFunction (_processXML)

	local _updateDevices = function (ssdp, devices)
		print ('devices updated')
		DiscoveredDevices = devices
		UpdateServerList ()
	end

	Discovery:SetUpdateDevicesFunction (_updateDevices)

	Discovery:StartDiscovery ()
end

function OPC.Device_Selector (value)
	if (value ~= '') then
		for uuid, device in pairs (DiscoveredDevices or {}) do
			if (value == device.friendlyName) then
				-- TODO this will trigger on every SSDP discovery that finds your device

				UpdateProperty ('Selected Device', device.friendlyName)

				PersistData.CurrentDeviceUUID = uuid
				Discovery.CurrentDeviceUUID = uuid

				print ('starting up device connection to ' .. device.friendlyName)

				-- TODO rest of your driver triggered here
			end
		end
	end
	UpdateProperty ('Device Selector', '')
end

function UpdateServerList ()
	local names = {[1] = ''}

	local foundCurrentUUID

	for uuid, device in pairs (DiscoveredDevices or {}) do
		table.insert (names, device.friendlyName)

		if (uuid == PersistData.CurrentDeviceUUID) then
			foundCurrentUUID = device.friendlyName
		end
	end

	table.sort (names)
	names = table.concat (names, ',')

	C4:UpdatePropertyList ('Device Selector', names)

	if (foundCurrentUUID) then
		UpdateProperty ('Device Selector', foundCurrentUUID)
		OnPropertyChanged ('Device Selector')
	end
end

