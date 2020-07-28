-- Copyright 2020 Control4 Corporation. All rights reserved.

common_ssdp = require ('common.common_ssdp')

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

	for property, _ in pairs (Properties) do
		OnPropertyChanged (property)
	end
end

function OPC.Driver_Version (value)
	C4:UpdateProperty ('Driver Version', C4:GetDriverConfigInfo ('version'))
end

function OPC.Search_Target (value)
	if (Discovery) then
		Discovery:delete ()
	end

	Discovery = SSDP:new (value)

	local _processXML = function (ssdp, uuid, data)
		print ('XML device data received for: ' .. uuid)
	end

	Discovery:SetProcessXMLFunction (_processXML)

	local _updateDevices = function (ssdp, devices)
		print ('devices updated, count: ', #devices)
		DiscoveredDevices = devices
		UpdateServerList ()
	end

	Discovery:SetUpdateDevicesFunction (_updateDevices)
end

function OPC.Device_Selector (value)
	if (value ~= '') then
		for uuid, device in pairs (DiscoveredDevices or {}) do
			if (value == device.friendlyName) then
				C4:UpdateProperty ('Device Selector', '')
				C4:UpdateProperty ('Selected Device', device.friendlyName)

				-- XXX this is where we would trigger setting up of the device, connecting to the control protocol, etc
			end
		end
	end
end

function UpdateServerList ()
	local names = {[1] = ''}

	for uuid, device in pairs (DiscoveredDevices or {}) do
		table.insert (names, device.friendlyName)
	end
	table.sort (names)
	names = table.concat (names, ',')

	C4:UpdatePropertyList ('Device Selector', names)
end

