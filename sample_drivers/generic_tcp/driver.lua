-- Copyright 2024 Snap One, LLC. All rights reserved.

require ('drivers-common-public.global.handlers')
require ('drivers-common-public.global.lib')
require ('drivers-common-public.global.timer')

do
	DEFAULT_NETBINDING = 6001
end

function OnDriverLateInit ()
	for property, _ in pairs (Properties) do
		OnPropertyChanged (property)
	end
end

function OPC.Server_Address (value)
	SERVER_ADDRESS = value
end

function OPC.Server_Port (value)
	SERVER_PORT = tonumber (value)
end

function OPC.Connection_Type (value)
	CONNECTION_TYPE = value
end

function OPC.Use_SSL (value)
	USE_SSL = (value == 'Yes')
end

function OPC.Open_Connection (value)
	if (value == 'Open') then
		OpenConnection ()
	elseif (value == 'Close') then
		CloseConnection ()
	end
end

function OPC.Send_Data (value)
	SendData (value)
end

function EC.Send_Data (tParams)
	SendData (tParams.DATA)
end

function OpenConnection ()
	if (USE_SSL) then
		print ('Creating SSL binding to ' .. SERVER_ADDRESS)
		C4:CreateNetworkConnection (DEFAULT_NETBINDING, SERVER_ADDRESS, 'SSL')
	else
		print ('Creating standard binding to ' .. SERVER_ADDRESS)
		C4:CreateNetworkConnection (DEFAULT_NETBINDING, SERVER_ADDRESS)
	end

	OCS [DEFAULT_NETBINDING] = function (idBinding, nPort, strStatus)
		if (nPort == SERVER_PORT) then
			CONNECTED = (strStatus == 'ONLINE')
			if (CONNECTED) then
				C4:UpdateProperty ('Open Connection', 'Open')
			else
				C4:UpdateProperty ('Open Connection', 'Close')
			end
		end
	end

	RFN [DEFAULT_NETBINDING] = function (idBinding, nPort, strData)
		print (' <<< ', idBinding, nPort, strData)
		if (idBinding == DEFAULT_NETBINDING) then
			if (nPort == SERVER_PORT) then
				C4:UpdateProperty ('Server Response', strData)
			end
		end
	end

	print ('Opening connection to ' .. SERVER_PORT .. ' of type ' .. CONNECTION_TYPE)
	C4:NetConnect (DEFAULT_NETBINDING, SERVER_PORT, CONNECTION_TYPE)
end

function CloseConnection ()
	C4:NetDisconnect (DEFAULT_NETBINDING, SERVER_PORT)
end

function SendData (data)
	data = string.gsub (data, '\\r', '\r')
	data = string.gsub (data, '\\n', '\n')
	if (CONNECTED) then
		C4:SendToNetwork (DEFAULT_NETBINDING, SERVER_PORT, data)
		print (' >>> ', data)
	end
end
