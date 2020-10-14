-- Copyright 2020 Wirepath Home Systems, LLC. All rights reserved.

JSON = require ('drivers-common-public.module.json')

require ('drivers-common-public.global.lib')
require ('drivers-common-public.global.timer')
require ('drivers-common-public.global.handlers')

WebSocket = require ('drivers-common-public.module.websocket')


function OPC.WebSocket_URL (value)
	if (DemoSocket) then
		DemoSocket:delete ()
	end
	DemoSocket = WebSocket:new (value)

	local pm = function (self, data)
		print ('Message Received: ' .. data)
		C4:UpdateProperty ('Message Received', data)
	end

	DemoSocket:SetProcessMessageFunction (pm)

	local est = function (self)
		print ('ws connection established')
	end

	DemoSocket:SetEstablishedFunction (est)

	local closed = function (self)
		print ('ws connection closed by remote host')
	end

	DemoSocket:SetClosedByRemoteFunction (closed)

	DemoSocket:Start ()
end

function OPC.Message_To_Send (value)
	if (DemoSocket and value ~= '') then
		C4:UpdateProperty ('Message To Send', '')
		DemoSocket:Send (value)
	end
end
