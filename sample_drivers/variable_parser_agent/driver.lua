-- Copyright 2021 Wirepath Home Systems, LLC. All rights reserved.

require ('drivers-common-public.global.lib')
require ('drivers-common-public.global.handlers')

function OnDriverLateInit (reason)
	WATCHED_VARS = PersistGetValue ('WATCHED_VARS') or {}

	UpdateVariableList ()
end

function GetVariableList (currentValue, callbackWhenDone, search, filter)
end

function EC.DeleteWatchedVar ()
end

function UpdateVariableList ()
	-- retrieve list of watched variables, keyed by driver ID/variable ID
	-- add empty string at top
	-- add "Add New" at bottom

	local names = {[1] = ''}

	for uuid, device in pairs (DlnaDevices or {}) do
		table.insert (names, device.friendlyName)
	end

	table.insert (names, 'Add New')
	names = table.concat (names, ',')

	C4:UpdatePropertyList ('Watched Variable List', names)

	C4:SetPropertyAttribs ('Device ID', 1)
	C4:SetPropertyAttribs ('Selected Device Name', 1)
	C4:SetPropertyAttribs ('Variable Selector', 1)
	C4:SetPropertyAttribs ('Pattern', 1)
	C4:SetPropertyAttribs ('Save Changes', 1)
end

function OPC.Watched_Variable_List (value)
	if (value == '') then
		return
	end

	local deviceId = ''
	local name = ''
	local variable = ''
	local pattern = ''

	-- set globs nil

	if (value ~= 'Add New') then
		-- get properties from table
	end

	C4:UpdateProperty ('Device ID', deviceId)
	C4:UpdateProperty ('Selected Device Name', name)
	C4:UpdateProperty ('Variable Selector', variable)
	C4:UpdateProperty ('Pattern', pattern)
	C4:UpdateProperty ('Save Changes', 'No')

	C4:SetPropertyAttribs ('Device ID', 0)
	C4:SetPropertyAttribs ('Selected Device Name', 0)
	C4:SetPropertyAttribs ('Variable Selector', 0)
	C4:SetPropertyAttribs ('Pattern', 0)
	C4:SetPropertyAttribs ('Save Changes', 0)
end

function OPC.Save_Changes (value)
	if (value == 'Yes') then
		PersistSetValue ('WATCHED_VARS', WATCHED_VARS)
	elseif (value == 'No') then
	end
	UpdateVariableList ()
	-- zero, hide all props
end

function OPC.Device_ID (value)
	local deviceId = tonumber (value)

	local displayName = C4:GetDeviceDisplayName (deviceId or -1)

	if (deviceId == 100001) then
		displayName = 'Variables Agent'
	end

	if (displayName == nil) then
		C4:UpdateProperty ('Selected Device Name', 'Device Not Found - please check device ID')
		C4:UpdatePropertyList ('Variable Selector', '')
		C4:UpdateProperty ('Variable Selector', '')
		return
	end

	C4:UpdateProperty ('Selected Device Name', displayName)

	local vars = C4:GetDeviceVariables (deviceId) or {}

	local list = {}

	for id, var in pairs (vars) do
		local item = string.gsub (var.name, ',', '') .. ' [' .. id .. ']'
		table.insert (list, item)
		if (tonumber (id) == THIS_WATCHED_VAR) then
			selected = item
		end
	end

	table.sort (list)
	list = table.concat (list, ',')

	C4:UpdatePropertyList ('Variable Selector', list)
end

function OPC.Variable_Selector (value)
	local variableId = string.match (value, '.+%[(%d+)%]')
	variableId = tonumber (variableId)

	Unregister ()

	WATCH.VAR = variableId

	if (variableId) then
		C4:RegisterVariableListener (WATCH.DEVICE, WATCH.VAR)
	end
end
