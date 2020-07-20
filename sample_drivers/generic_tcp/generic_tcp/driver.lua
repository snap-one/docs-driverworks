function Print (data)
	if (type (data) == 'table') then
		for k, v in pairs (data) do print (k, v) end
	elseif (type (data) ~= 'nil') then
		print (type (data), data)
	else
		print ('nil value')
	end
end

function OnDriverLateInit ()
	for property, _ in pairs (Properties) do
		OnPropertyChanged (property)
	end
end

function OnPropertyChanged (strProperty)
	local value = Properties [strProperty]
	if (value == nil) then
		value = ''
	end
	
	if (strProperty == 'Server Address') then
		SERVER_ADDRESS = value

	elseif (strProperty == 'Server Port') then
		SERVER_PORT = tonumber (value)

	elseif (strProperty == 'Connection Type') then
		CONNECTION_TYPE = value

	elseif (strProperty == 'Use SSL') then
		USE_SSL = (value == 'Yes')

	elseif (strProperty == 'Open Connection') then
		if (value == 'Open') then
			OpenConnection ()

		elseif (value == 'Close') then
			CloseConnection ()
		end

	elseif (strProperty == 'Send Data') then
		SendData (value)
	end
end

function ExecuteCommand (strCommand, tParams)
	tParams = tParams or {}

	local output = {'--- ExecuteCommand', strCommand, '----PARAMS----'}
	for k,v in pairs (tParams) do table.insert (output, tostring (k) .. ' = ' .. tostring (v)) end
	table.insert (output, '---')
	output = table.concat (output, '\r\n')
	dbg (output)

	if (strCommand == 'LUA_ACTION') then
		if (tParams.ACTION) then
			strCommand = tParams.ACTION
			tParams.ACTION = nil
		end
	end

	if (strCommand == 'Send Data') then
		SendData (tParams.DATA)
	end
end

function OpenConnection ()
	if (USE_SSL) then
		print ('Creating SSL binding to ' .. SERVER_ADDRESS)
		C4:CreateNetworkConnection (6001, SERVER_ADDRESS, 'SSL')
	else
		print ('Creating standard binding to ' .. SERVER_ADDRESS)
		C4:CreateNetworkConnection (6001, SERVER_ADDRESS)
	end
end

function CloseConnection ()
	C4:NetDisconnect (6001, SERVER_PORT)
end

function SendData (data)
	data = string.gsub (data, '\\r', '\r')
	data = string.gsub (data, '\\n', '\n')
	if (CONNECTED) then
		C4:SendToNetwork (6001, SERVER_PORT, data)
		print (' >>> ', data)
	end
end

function OnNetworkBindingChanged (idBinding, bIsBound)
	print (idBinding, bIsBound)
	if (idBinding == 6001) then
		if (bIsBound) then
			print ('Opening connection to ' .. SERVER_PORT .. ' of type ' .. CONNECTION_TYPE)
			if (CONNECTION_TYPE == 'TCP') then
				C4:NetConnect (6001, SERVER_PORT)
			else
				C4:NetConnect (6001, SERVER_PORT, CONNECTION_TYPE)
			end
		end
	end
end

function OnConnectionStatusChanged (idBinding, nPort, strStatus)
	print (idBinding, nPort, strStatus)
	if (idBinding == 6001) then
		if (nPort == SERVER_PORT) then
			CONNECTED = (strStatus == 'ONLINE')
			if (CONNECTED) then
				C4:UpdateProperty ('Open Connection', 'Open')
			else
				C4:UpdateProperty ('Open Connection', 'Close')
			end
		end
	end
end

function ReceivedFromNetwork (idBinding, nPort, strData)
	print (' <<< ', idBinding, nPort, strData)
	if (idBinding == 6001) then
		if (nPort == SERVER_PORT) then
			C4:UpdateProperty ('Server Response', strData)
			
		end
	end
end


