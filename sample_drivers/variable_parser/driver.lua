function CancelTimer (timerId)
	if (type (timerId) == 'userdata' and timerId.Cancel) then
		timerId:Cancel ()

	elseif (type (timerId) == 'string') then
		if (Timer [timerId]) then
			if (Timer [timerId].Cancel) then
				Timer [timerId] = Timer [timerId]:Cancel ()
			else
				Timer [timerId] = nil
			end
		end
	end
	return nil
end

function SetTimer (timerId, delay, timerFunction, repeating)
	if (timerId) then
		CancelTimer (timerId)
	end

	if (timerFunction == nil) then
		if (type (_G [timerId]) == 'function') then
			timerFunction = function (timer)
				_G [timerId] ()
			end
		else
			timerFunction = function (timer)
			end
		end
	end

	local _timer = function (timer)
		timerFunction (timer)
		if (repeating ~= true) then
			CancelTimer (timerId)
		end
	end

	local timer = C4:SetTimer (delay, _timer, (repeating == true))

	if (type (timerId) == 'string') then
		if (timerId and timer) then
			Timer [timerId] = timer
		end
	end
	return timer
end

function XMLDecode (s)
	if (s == nil) then return end
	s = tostring (s)

	s = string.gsub (s, '%<%!%[CDATA%[(.-)%]%]%>', function (a) return (a) end)

	s = string.gsub (s, '&quot;'	, '"')
	s = string.gsub (s, '&lt;'	, '<')
	s = string.gsub (s, '&gt;'	, '>')
	s = string.gsub (s, '&apos;'	, '\'')
	s = string.gsub (s, '&#x(.-);', function (a) return string.char (tonumber (a, 16) % 256) end )
	s = string.gsub (s, '&#(.-);',	function (a) return string.char (tonumber (a) % 256) end )
	s = string.gsub (s, '&amp;'	, '&')

	return s
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

function ExecuteCommand (strCommand, tParams)
	tParams = tParams or {}
	local output = {'--- ExecuteCommand', strCommand, '----PARAMS----'}
	for k,v in pairs (tParams) do table.insert (output, tostring (k) .. ' = ' .. tostring (v)) end
	table.insert (output, '---')
	output = table.concat (output, '\r\n')
	print (output)

	if (strCommand == 'LUA_ACTION') then
		if (tParams.ACTION) then
			strCommand = tParams.ACTION
			tParams.ACTION = nil
		end
	end

	if (strCommand == 'GetVariable') then
		if (WATCH.DEVICE and WATCH.VAR) then
			local strValue = C4:GetDeviceVariable (WATCH.DEVICE, WATCH.VAR)
			OnWatchedVariableChanged (WATCH.DEVICE, WATCH.VAR, strValue)
		end
	end
end

function OnDriverLateInit ()
	C4:AddVariable ('STRING', '', 'STRING', true, false)
	C4:SetVariable ('STRING', '')

	C4:AddVariable ('NUMBER', 0, 'NUMBER', true, false)
	C4:SetVariable ('NUMBER', 0)

	C4:AddVariable ('BOOL', '1', 'BOOL', true, false)
	C4:SetVariable ('BOOL', '1')

	PersistData = PersistData or {}
	WATCH = PersistData.WATCH or {}
	PersistData.WATCH = WATCH

	for property, _ in pairs (Properties) do
		OnPropertyChanged (property)
	end
end

function OnPropertyChanged (strProperty)
	local value = Properties [strProperty]
	if (value == nil) then
		value = ''
	end

	local output = {'--- OnPropertyChanged', strProperty, value}
	output = table.concat (output, '\r\n')
	print (output)

	if (strProperty == 'Device With Variable') then
		local deviceId = tonumber (value)

		local displayName = C4:GetDeviceDisplayName (deviceId or -1)

		if (deviceId == 100001) then
			displayName = 'Variables Agent'
		end

		if (displayName == nil) then
			C4:UpdateProperty ('Selected Device Name', 'Device Not Found - please check device ID')
			C4:UpdatePropertyList ('Variable Selector', '')
			C4:UpdateProperty ('Variable Selector', '')

			Unregister ()

			WATCH.DEVICE = nil
			return
		end

		C4:UpdateProperty ('Device With Variable', tostring (deviceId))

		if (WATCH.DEVICE ~= deviceId) then
			Unregister ()
			WATCH.DEVICE = deviceId
		end

		C4:UpdateProperty ('Selected Device Name', displayName)
		local vars = C4:GetDeviceVariables (deviceId) or {}

		local list = {}

		local selected

		for id, var in pairs (vars) do
			local item = string.gsub (var.name, ',', '') .. ' [' .. id .. ']'
			table.insert (list, item)
			if (tonumber (id) == WATCH.VAR) then
				selected = item
			end
		end

		table.sort (list)
		list = table.concat (list, ',')

		C4:UpdatePropertyList ('Variable Selector', list)

		if (selected) then
			C4:UpdateProperty ('Variable Selector', selected)
			OnPropertyChanged ('Variable Selector')
		end

	elseif (strProperty == 'Variable Selector') then
		local variableId = string.match (value, '.+%[(%d+)%]')
		variableId = tonumber (variableId)

		Unregister ()

		WATCH.VAR = variableId

		if (variableId) then
			C4:RegisterVariableListener (WATCH.DEVICE, WATCH.VAR)
		end

	elseif (strProperty == 'Pattern') then
		if (value == '') then
			PATTERN = nil
		else
			local status, result = pcall (string.find, '', value)
			if (not status) then
				print ('Error with pattern - please check again')
				PATTERN = nil
			else
				print ('Pattern accepted')
				PATTERN = value
			end
		end

		local captures = 0

		local captureCheck = PATTERN or ''

		captureCheck = string.gsub (captureCheck, '%%%(', '') or ''
		captureCheck = string.gsub (captureCheck, '%%%)', '') or ''

		for _, _ in string.gfind (captureCheck, '%b()') do
			captures = captures + 1
		end

		for i = 1, captures do
			C4:AddVariable ('Pattern Capture ' .. tostring (i), '', 'STRING', true, false)
		end

		if (WATCH.DEVICE and WATCH.VAR) then
			local strValue = C4:GetDeviceVariable (WATCH.DEVICE, WATCH.VAR)
			OnWatchedVariableChanged (WATCH.DEVICE, WATCH.VAR, strValue)
		end
	end
end

function OnWatchedVariableChanged (idDevice, idVariable, strValue)
	if (idDevice == WATCH.DEVICE and idVariable == WATCH.VAR) then
		print ('Variable Changed: ' .. strValue)
		print ('Firing Event: Variable Changed')
		C4:FireEvent ('Variable Changed')

		local s = tostring (strValue) or ''
		local n = string.match (strValue, '%d+') or ''
		local test = string.upper (tostring (strValue))
		local b = ((test == '1' or test == 'TRUE') and '1') or '0'

		C4:SetVariable ('STRING', s)
		C4:SetVariable ('NUMBER', n)
		C4:SetVariable ('BOOL', b)

		print ('Setting Variable: STRING: ' .. s)
		print ('Setting Variable: NUMBER: ' .. n)
		print ('Setting Variable: BOOL: ' .. b)

		if (PATTERN) then
			local result = {string.find (strValue, PATTERN)}
			if (result [1] and result [2]) then
				table.remove (result, 1)
				table.remove (result, 1)

				for i = 1, #result do
					C4:SetVariable ('Pattern Capture ' .. tostring (i), result [i] or '')
					print ('Setting Variable: Pattern Capture ' .. tostring (i) .. ': ' .. result [i] or '')
				end

				print ('Firing Event: Pattern Found')
				C4:FireEvent ('Pattern Found')
			end
		end
	end
end

function Unregister ()
	if (WATCH.DEVICE and WATCH.VAR) then
		C4:UnregisterVariableListener (WATCH.DEVICE, WATCH.VAR)
		WATCH.VAR = nil
	end
end
