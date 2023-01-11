------------------------------------------------------------------
-- functions copied from drivers-common-public/global/handlers.lua
-- metrics have been removed for sample drivers
-- These function handlers are taken from the handlers.lua file referenced above
-- They allow the use of individual functions for each possible command received, rather than needing a large if/else block
------------------------------------------------------------------

do	--Globals
	EC = EC or {}
	OPC = OPC or {}
	RFP = RFP or {}
end

function HandlerDebug (init, tParams, args)
	if (not DEBUGPRINT) then
		return
	end

	if (type (init) ~= 'table') then
		return
	end

	local output = init

	if (type (tParams) == 'table' and next (tParams) ~= nil) then
		table.insert (output, '----PARAMS----')
		for k, v in pairs (tParams) do
			local line = tostring (k) .. ' = ' .. tostring (v)
			table.insert (output, line)
		end
	end

	if (type (args) == 'table' and next (args) ~= nil) then
		table.insert (output, '----ARGS----')
		for k, v in pairs (args) do
			local line = tostring (k) .. ' = ' .. tostring (v)
			table.insert (output, line)
		end
	end

	local t, ms
	if (C4.GetTime) then
		t = C4:GetTime ()
		ms = '.' .. tostring (t % 1000)
		t = math.floor (t / 1000)
	else
		t = os.time ()
		ms = ''
	end
	local s = os.date ('%x %X') .. ms

	table.insert (output, 1, '-->  ' .. s)
	table.insert (output, '<--')
	output = table.concat (output, '\r\n')
	print (output)
	C4:DebugLog (output)
end

--[[
ExecuteCommand is called whenever:
- a programming Device Specific Action is triggered on this driver as a result of an Event firing
- a Composer Action is selected
- a command is sent to the Protocol Driver ID from elsewhere in the project

--]]
function ExecuteCommand (strCommand, tParams)
	tParams = tParams or {}
	local init = {
		'ExecuteCommand: ' .. strCommand,
	}
	HandlerDebug (init, tParams)

	if (strCommand == 'LUA_ACTION') then
		if (tParams.ACTION) then
			strCommand = tParams.ACTION
			tParams.ACTION = nil
		end
	end

	strCommand = string.gsub (strCommand, '%s+', '_')

	local success, ret

	if (EC and EC [strCommand] and type (EC [strCommand]) == 'function') then
		success, ret = pcall (EC [strCommand], tParams)
	end

	if (success == true) then
		return (ret)
	elseif (success == false) then
		print ('ExecuteCommand error: ', ret, strCommand)
	end
end

--[[
OnPropertyChanged is called whenever:
- Composer is used to change a property (don't forget to press "Set" in Composer!)
--]]
function OnPropertyChanged (strProperty)
	local value = Properties [strProperty]
	if (type (value) ~= 'string') then
		value = ''
	end

	local init = {
		'OnPropertyChanged: ' .. strProperty,
		value,
	}
	HandlerDebug (init)

	strProperty = string.gsub (strProperty, '%s+', '_')

	local success, ret

	if (OPC and OPC [strProperty] and type (OPC [strProperty]) == 'function') then
		success, ret = pcall (OPC [strProperty], value)
	end

	if (success == true) then
		return (ret)
	elseif (success == false) then
		print ('OnPropertyChanged error: ', ret, strProperty, value)
	end
end

--[[
ReceivedFromProxy is called whenever:
- A user interface is used to control this driver
- A programming Action is triggered on the proxy as a result of an Event firing
- a command is sent to the Proxy Driver ID from elsewhere in the project
--]]
function ReceivedFromProxy (idBinding, strCommand, tParams)
	strCommand = strCommand or ''
	tParams = tParams or {}
	local args = {}
	if (tParams.ARGS) then
		local parsedArgs = C4:ParseXml (tParams.ARGS)
		for _, v in pairs (parsedArgs.ChildNodes) do
			args [v.Attributes.name] = v.Value
		end
		tParams.ARGS = nil
	end

	local init = {
		'ReceivedFromProxy: ' .. idBinding,
		strCommand,
	}
	HandlerDebug (init, tParams, args)

	local success, ret

	if (RFP and RFP [strCommand] and type (RFP [strCommand]) == 'function') then
		success, ret = pcall (RFP [strCommand], idBinding, strCommand, tParams, args)

	elseif (RFP and RFP [idBinding] and type (RFP [idBinding]) == 'function') then
		success, ret = pcall (RFP [idBinding], idBinding, strCommand, tParams, args)
	end

	if (success == true) then
		return (ret)
	elseif (success == false) then
		print ('ReceivedFromProxy error: ', ret, idBinding, strCommand)
	end
end

------------------------------------------------------------------

--[[
OnDriverLateInit is called whenever:
- The driver is added to the project (driverInitType == 'DIT_ADDING'
- The main controller (running Director) starts up or Director is restarted (driverInitType == 'DIT_STARTUP')
- The driver is updated in the project (driverInitType == 'DIT_UPDATING')

This is where driver initialization should be done
--]]
function OnDriverLateInit (driverInitType)
	DEBUGPRINT = true -- set this to true by default so we get output to look at
end
