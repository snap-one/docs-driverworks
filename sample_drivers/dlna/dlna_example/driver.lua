--Copyright 2019 Control4 Corporation. All rights reserved.

do	--Globals
	Timer = Timer or {}
end

function OnDriverDestroyed ()
	DlnaStopDiscovery ()
	KillAllTimers ()
end

function OnDriverLateInit ()
	KillAllTimers ()			-- run here in case of driver update to stop timers from running but being out of scope
	if (C4.AllowExecute) then C4:AllowExecute (true) end

	C4:urlSetTimeout (20)

	if (not PersistData) then PersistData = {} end

	DlnaLocations = {}
	DlnaDevices = {}

	for property, _ in pairs (Properties) do
		OnPropertyChanged (property)
	end

	-- UPNP server
	if (CALLBACK == nil) then
		SetCallbackServer ()
	end

	C4:CreateNetworkConnection (6999, '239.255.255.250')
	DlnaSendDiscoveryPacket ()		-- listen for servers coming online
end

function OnPropertyChanged (strProperty)
	local value = Properties [strProperty]
	if (value == nil) then
		print ('OnPropertyChanged, nil value for Property: ', strProperty)
		return
	end

	if (strProperty == 'Driver Version') then
		C4:UpdateProperty ('Driver Version', C4:GetDriverConfigInfo ('version'))

	elseif (strProperty == 'Device Selector') then
		if (value ~= '') then
			for uuid, device in pairs (DlnaDevices or {}) do
				if (value == device.friendlyName) then
					if (CURRENT_DEVICE ~= uuid) then
						CURRENT_DEVICE = uuid
						PersistData.CURRENT_DEVICE = CURRENT_DEVICE
						C4:UpdateProperty ('Device Selector', '')
						C4:UpdateProperty ('Selected Device', device.friendlyName)

						-- XXX this is where we would trigger setting up of the device, connecting to the control protocol, etc
					end
				end
			end
		end
	end
end

-----------------------------------------------
-- url Functions
-----------------------------------------------
GlobalTicketHandlers = GlobalTicketHandlers or {}

function ReceivedAsync (ticketId, strData, responseCode, tHeaders, strError)
	for k, info in pairs (GlobalTicketHandlers) do
		if (info.TICKET == ticketId) then
			table.remove (GlobalTicketHandlers, k)

			if (ETag) then
				local url = info.URL
				local hit = false
				local tag = tHeaders.ETag
				for k, v in pairs (ETag) do
					if (v.url == url) then
						hit = k
					end
				end

				if (responseCode == 200 and strError == nil) then
					if (strData == nil and tonumber (tHeaders ['Content-Length']) == 0) then strData = '' end

					if (hit) then
						table.remove (ETag, hit)
					end
					if (tag and info.METHOD ~= 'DELETE') then
						table.insert (ETag, 1, {url = url, strData = strData, tHeaders = tHeaders, tag = tag})
					end

				elseif (tag and responseCode == 304 and strError == nil) then
					if (hit) then
						strData = ETag [hit].strData
						tHeaders = ETag [hit].tHeaders
						table.remove (ETag, hit)
						table.insert (ETag, 1, {url = url, strData = strData, tHeaders = tHeaders, tag = tag})
						responseCode = 200
					end
				end

				while (#ETag > MAX_CACHE) do
					table.remove (ETag, #ETag)
				end
			end

			local data, js, len

			for k, v in pairs (tHeaders) do
				if (string.upper (k) == 'CONTENT-TYPE') then
					if (string.find (v, 'application/json')) then
						js = true
					end
				end
				if (string.upper (k) == 'CONTENT-LENGTH') then
					len = tonumber (v) or 0
				end
			end

			if (js) then
				data = JSON:decode (strData)
				if (data == nil and len ~= 0) then
					print ('ERROR parsing json data: ')
					strError = 'Error parsing response'
				end
			else
				data = strData
			end

			if (info.CALLBACK) then
				info.CALLBACK (strError, responseCode, tHeaders, data, info.CONTEXT, info.URL)
			else
				print (responseCode, info.URL)
				Print (data)
			end
			return
		end
	end
end

function urlDo (method, url, data, headers, callback, context)
	local info = {}
	if (type (callback) == 'function') then
		info.CALLBACK = callback
	end
	info.CONTEXT = context
	info.URL = url
	info.METHOD = method

	data = data or ''

	headers = headers or {}

	for _, etag in pairs (ETag or {}) do
		if (etag.url == url) then
			headers ['If-None-Match'] = etag.tag
		end
	end

	if (method == 'GET') then
		info.TICKET = C4:urlGet (url, headers, false)
	elseif (method == 'POST') then
		info.TICKET = C4:urlPost (url, data, headers, false)
	elseif (method == 'PUT') then
		info.TICKET = C4:urlPut (url, data, headers, false)
	elseif (method == 'DELETE') then
		info.TICKET = C4:urlDelete (url, headers, false)
	else
		info.TICKET = C4:urlCustom (url, method, data, headers, false)
	end

	if (info.TICKET and info.TICKET ~= 0) then
		table.insert (GlobalTicketHandlers, info)
	else
		print ('C4.Curl error: ' .. info.METHOD .. ' ' .. url)
		if (callback) then
			callback ('No ticket', nil, nil, '', context, url)
		end
	end
end

function urlGet (url, headers, callback, context)
	urlDo ('GET', url, data, headers, callback, context)
end

function urlPost (url, data, headers, callback, context)
	urlDo ('POST', url, data, headers, callback, context)
end

function urlPut (url, data, headers, callback, context)
	urlDo ('PUT', url, data, headers, callback, context)
end

function urlDelete (url, headers, callback, context)
	urlDo ('DELETE', url, data, headers, callback, context)
end

function urlCustom (url, method, data, headers, callback, context)
	urlDo (method, url, data, headers, callback, context)
end

-----------------------------------------------
-- useful functions
-----------------------------------------------
function KillAllTimers ()
	for k,v in pairs (Timer or {}) do
		if (type (timer) == 'userdata') then
			timer:Cancel ()
			Timer [k] = nil
		end
	end
end

function Print (data)
	if (type (data) == 'table') then
		local p = {}
		for k, v in pairs (data) do
			table.insert (p, tostring  (k) .. '	:-:	' .. tostring  (v))
		end
		print (table.concat (p, '\r\n'))
	elseif (type (data) ~= 'nil') then
		print (type (data), data)
	else
		print ('nil value')
	end
end

function XMLDecode (s)
	if (s == nil) then return end

	s = string.gsub (s, '%<%!%[CDATA%[(.-)%]%]%>', function (a) return (a) end)
	s = string.gsub (s, '&quot;'	, '"')
	s = string.gsub (s, '&lt;'	, '<')
	s = string.gsub (s, '&gt;'	, '>')
	s = string.gsub (s, '&apos;'	, '\'')
	s = string.gsub (s, '&#x(.-);', function (a) return string.char (tonumber (a, 16) % 256) end )
	s = string.gsub (s, '&#(.-);', function (a) return string.char (tonumber (a) % 256) end )
	s = string.gsub (s, '&amp;'	, '&')

	return s
end

function XMLEncode (s)
	if (s == nil) then return end

	s = string.gsub (s, '&',  '&amp;')
	s = string.gsub (s, '"',  '&quot;')
	s = string.gsub (s, '<',  '&lt;')
	s = string.gsub (s, '>',  '&gt;')
	s = string.gsub (s, '\'', '&apos;')

	return s
end

function XMLTag (strName, tParams, tagSubTables, xmlEncodeElements)
	local retXML = {}
	if (type (strName) == 'table' and tParams == nil) then
		tParams = strName
		strName = nil
	end
	if (strName) then
		table.insert (retXML, '<')
		table.insert (retXML, tostring (strName))
		table.insert (retXML, '>')
	end
	if (type (tParams) == 'table') then
		for k, v in pairs (tParams) do
			if (v == nil) then v = '' end
			if (type (v) == 'table') then
				if (tagSubTables == true) then
					table.insert (retXML, XMLTag (k, v))
				end
			else
				if (v == nil) then v = '' end
				table.insert (retXML, '<')
				table.insert (retXML, tostring (k))
				table.insert (retXML, '>')
				if (xmlEncodeElements ~= false) then
					table.insert (retXML, XMLEncode (tostring (v)))
				else
					table.insert (retXML, tostring (v))
				end
				table.insert (retXML, '</')
				table.insert (retXML, tostring (k))
				table.insert (retXML, '>')
			end
		end
	elseif (tParams) then
		if (xmlEncodeElements ~= false) then
			table.insert (retXML, XMLEncode (tostring (tParams)))
		else
			table.insert (retXML, tostring (tParams))
		end
	end

	if (strName) then
		table.insert (retXML, '</')
		table.insert (retXML, tostring (strName))
		table.insert (retXML, '>')
	end
	return (table.concat (retXML))
end

-----------------------------------------------
-----------------------------------------------
-- UPNP functions
-----------------------------------------------
-----------------------------------------------
do -- static service values
	AVTRANSPORT_SERVICE = 'urn:upnp-org:serviceId:AVTransport'

	UPNPEvent = {}

	UPNPEvent [AVTRANSPORT_SERVICE] = {}
end

function SetCallbackServer ()
	local serverport = math.random (49152, 65535)
	local ip = C4:GetControllerNetworkAddress ()
	if (ip and ip ~= '') then
		C4:CreateServer (serverport)
		CALLBACK = 'http://' .. ip .. ':' .. serverport .. '/notify/'
	else
		CALLBACK = nil
		if (Timer.SetCallbackServer) then Timer.SetCallbackServer = Timer.SetCallbackServer:Cancel () end
		Timer.SetCallbackServer = C4:SetTimer (15 * 1000, function (timer)
															if (CALLBACK == nil) then SetCallbackServer () end
														end)
	end
end

function UPNPInvoke (serviceId, actionName, actionData, callback, context)
	if (not CURRENT_DEVICE) then print ('Invoke Error: Device not set') return end
	local serviceURN = UPNPServices [CURRENT_DEVICE][serviceId].serviceType
	local controlURL = UPNPServices [CURRENT_DEVICE][serviceId].controlURL

	local args
	if (type (actionData) == 'table') then
		args = XMLTag (nil, actionData)
	elseif (type (actionData) == 'string') then
		args = actionData
	end

	local content = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">' ..
					'<s:Body><u:' .. actionName .. ' xmlns:u="' .. serviceURN .. '">' .. args .. '</u:' .. actionName .. '></s:Body></s:Envelope>'

	local headers = {['Content-Type'] = 'text/xml; charset="utf-8"', SOAPACTION = '"' .. serviceURN .. '#' .. actionName.. '"'}

	urlPost (controlURL, content, headers, callback, context)
end

-----------------------------------------------
-- Discovery functions
-----------------------------------------------
function OnConnectionStatusChanged (idBinding, nPort, strStatus)
	if (idBinding == 6999) then
		DlnaSSDPServerOnline = (strStatus == 'ONLINE')
		if (DlnaSSDPServerOnline) then
			print ('SSDP discovery socket online')
			DlnaSendDiscoveryPacket ()
		else
			print ('SSDP discovery socket offline')
			if (PersistData and PersistData.CURRENT_DEVICE and not (CURRENT_DEVICE and DlnaDevices [PersistData.CURRENT_DEVICE])) then
				-- if device has been selected but is not currently found
				if (Timer.DlnaRescan) then Timer.DlnaRescan = Timer.DlnaRescan:Cancel () end
				Timer.DlnaRescan = C4:SetTimer (math.random (20, 40) * 1000, function (timer) DlnaSendDiscoveryPacket () end)
			end
		end
	end
end

function ReceivedFromNetwork (idBinding, nPort, strData)
	if (idBinding == 6999) then
		DlnaParseSSDPResponse (strData)
	end
end

function DlnaOpenDiscoveryConnection ()
	DlnaStopDiscovery ()

	if (Timer.DlnaCloseConnection) then Timer.DlnaCloseConnection = Timer.DlnaCloseConnection:Cancel () end
	Timer.DlnaCloseConnection = C4:SetTimer (10 * 1000, function (timer)
															C4:NetDisconnect (6999, 1900, 'UDP')
															Timer.DlnaCloseConnection = Timer.DlnaCloseConnection:Cancel ()
														end)

	C4:NetConnect (6999, 1900, 'UDP')
end

function DlnaSendDiscoveryPacket ()
	if (Timer.DlnaRescan) then Timer.DlnaRescan = Timer.DlnaRescan:Cancel () end
	Timer.DlnaRescan = C4:SetTimer (math.random (180, 300) * 1000, function (timer) DlnaSendDiscoveryPacket () end)
	-- XXX this timer period is set for Sonos.  It should be no more than half (and ideally less than a third) of the interval expiry time from the SSDP packet to avoid
	-- invalid offline calls

	if (DlnaSSDPServerOnline) then

		local content = 'M-SEARCH * HTTP/1.1\r\n' ..
						'HOST: 239.255.255.250:1900\r\n' ..
						'MAN: "ssdp:discover"\r\n' ..
						'MX: 5\r\n' ..
						'ST: ' .. 'ssdp:all' .. '\r\n\r\n' -- XXX you should change ssdp:all to whichever is the tightest search pattern for your UPNP device you can use

		C4:SendToNetwork (6999, 1900, content)
		C4:SendToNetwork (6999, 1900, content)
		C4:SendToNetwork (6999, 1900, content)
		C4:SendToNetwork (6999, 1900, content)
		C4:SendToNetwork (6999, 1900, content)
	else
		DlnaOpenDiscoveryConnection ()
	end
end

function DlnaStopDiscovery ()
	for location, timer in pairs (DlnaLocations or {}) do
		DlnaLocations [location] = timer:Cancel ()
	end
	DlnaLocations = {}
	C4:NetDisconnect (6999, 1900)
end

function DlnaParseSSDPResponse (data)
	if (string.find (data, 'M-SEARCH')) then return end
	if (string.find (data, 'c4:')) then return end

	local headers = {}
	for line in string.gmatch (data, '(.-)\r\n') do
		local k, v = string.match (line, '%s*(.-)%s*[:/*]%s*(.+)')
		if (k and v) then
			k = string.upper (k)
			headers [k] = v
		end
	end

	-- XXX you can change YOUR SEARCH TYPE HERE to whatever your correct value is and uncomment this line to not parse unnecessary SSDP responses
	-- if (not (headers.ST and headers.ST == 'YOUR SEARCH TYPE HERE')) then return end

	local alive, byebye

	if (headers.HTTP and headers.HTTP == '1.1 200 OK') then
		alive = true

	elseif (headers.NOTIFY and headers.NTS and headers.NTS == 'ssdp:alive') then -- we can't currently receive these
		alive = true

	elseif (headers.NOTIFY and headers.NTS and headers.NTS == 'ssdp:byebye') then -- we can't currently receive these
		byebye = true
	end

	if (alive) then
		local interval
		if (headers ['CACHE-CONTROL']) then
			interval = string.match (headers ['CACHE-CONTROL'], 'max-age = (%d+)')
		end
		interval = tonumber (interval) or 1800

		if (headers.LOCATION) then
			local location = headers.LOCATION

			local server, path = string.match (location, 'http://(.-)(/.*)')
			local ip, port = string.match (server, '(.-):(.+)')
			if (not port) then ip = server port = 80 end

			DlnaDevices = DlnaDevices or {}

			local uuid = string.match (headers.USN, 'uuid:(.-):')
			if (not uuid) then return end
			DlnaDevices [uuid] = DlnaDevices [uuid] or {}

			for k, v in pairs (headers) do
				DlnaDevices [uuid] [k] = v
			end

			DlnaDevices [uuid].ip = ip
			DlnaDevices [uuid].port = port

			if (DlnaLocations [location]) then
				DlnaLocations [location]:Cancel ()
			else
				urlGet (location, nil, DlnaParseXML, {uuid = uuid})
			end

			DlnaLocations [location] = C4:SetTimer (interval * 1005, function (timer)
																		DlnaLocations [location] = nil
																		for uuid, device in pairs (DlnaDevices or {}) do
																			if (device.LOCATION == location) then
																				DlnaDeviceOffline (uuid)
																			end
																		end
																	end)
		end

	elseif (byebye) then
		if (headers.USN) then
			local uuid = string.match (headers.USN, 'uuid:(.+)')
			DlnaDeviceOffline (uuid)
		end
	end
end

function DlnaDeviceOffline (uuid)
	-- if a device doesn't respond to an M-SEARCH within it's interval, it'll "go offline"
	-- we can't continuously listen for bye-bye messages.
	local location = DlnaDevices [uuid].LOCATION
	local timer = DlnaLocations [location]
	if (timer) then
		DlnaLocations [location] = timer:Cancel ()
	end

	DlnaDevices [uuid] = nil
	if (Timer.UpdateServerList) then Timer.UpdateServerList:Cancel () end
	Timer.UpdateServerList = C4:SetTimer (1000, function (timer) UpdateServerList () end)

	if (uuid == CURRENT_DEVICE) then
		-- XXX may want to implement a counter here if device doesn't reliably respond to most M-SEARCH messages
		CURRENT_DEVICE = nil
	end

	if (CURRENT_DEVICE == nil) then
		if (Timer.DlnaRescan) then Timer.DlnaRescan:Cancel () end
		Timer.DlnaRescan = C4:SetTimer (math.random (5, 10) * 1000, function (timer) DlnaSendDiscoveryPacket () end)
	end
end

function DlnaParseXML (strError, responseCode, tHeaders, data, context, url)
	if (strError == nil and responseCode == 200) then
		local friendlyName = XMLDecode (string.match (data, '<friendlyName>(.-)</friendlyName>'))
		local uuid = string.match (data, '<UDN>uuid:(.-)</UDN>')

		-- UPNP functions require this

		local server, path = string.match (url, 'http://(.-)(/.*)')

		local URLBase = string.match (data, '<URLBase>(.-)</URLBase>') or string.match (path, '(.*/)')

		UPNPServices = UPNPServices or {}
		UPNPServices [uuid] = UPNPServices [uuid] or {}

		for service in string.gfind (data, '<service>(.-)</service>') do
			local serviceId = string.match (service, '<serviceId>(.-)</serviceId>')
			local serviceType = string.match (service, '<serviceType>(.-)</serviceType>')
			local controlURL = string.match (service, '<controlURL>(.-)</controlURL>')
			local eventSubURL = string.match (service, '<eventSubURL>(.-)</eventSubURL>')
			local SCPDURL = string.match (service, '<SCPDURL>(.-)</SCPDURL>')

			if (string.sub (controlURL, 1, 1) ~= '/') then controlURL = URLBase .. controlURL end
			if (string.sub (eventSubURL, 1, 1) ~= '/') then eventSubURL = URLBase .. eventSubURL end
			if (string.sub (SCPDURL, 1, 1) ~= '/') then SCPDURL = URLBase .. SCPDURL end

			controlURL = 'http://' .. server .. controlURL
			eventSubURL = 'http://' .. server .. eventSubURL
			SCPDURL = 'http://' .. server .. SCPDURL

			UPNPServices [uuid][serviceId] = {serviceType = serviceType, controlURL = controlURL, eventSubURL = eventSubURL, SCPDURL = SCPDURL}
		end

		DlnaDevices [uuid].friendlyName = friendlyName
		if (Timer.UpdateServerList) then Timer.UpdateServerList:Cancel () end
		Timer.UpdateServerList = C4:SetTimer (1000, function (timer) UpdateServerList () end)

		if (CURRENT_DEVICE == nil and PersistData.CURRENT_DEVICE == uuid) then
			-- this happens on startup of C4 when we've previously selected this device and this is the first time being discovered
			-- this also happens if a device was offline for a period of time and is being rediscovered after going offline
			-- XXX note that we cannot generically detect a device rebooting and coming back online on the same IP address within it's timeout
			-- XXX you will need to either see if there is an SSDP response value that you can parse to detect this (uptime counter or similar)
			-- XXX or resubscribe to the device on EVERY SSDP response for CURRENT_DEVICE in the DlnaParseSSDPResponse function
			C4:UpdateProperty ('Device Selector', friendlyName)
			OnPropertyChanged ('Device Selector')
		end
	end
end

function UpdateServerList ()
	local names = {[1] = ''}

	for uuid, device in pairs (DlnaDevices or {}) do
		table.insert (names, device.friendlyName)
	end
	table.sort (names)
	names = table.concat (names, ',')

	C4:UpdatePropertyList ('Device Selector', names)
end
-----------------------------------------------
--UPNP server functions
-----------------------------------------------
function OnServerConnectionStatusChanged (nHandle, nPort, strStatus)
	if (strStatus == 'ONLINE') then
		if (not ServerBuffer) then ServerBuffer = {} end
		ServerBuffer [nHandle] = ''
	elseif (strStatus == 'OFFLINE') then
		C4:ServerCloseClient (nHandle)
		ServerBuffer [nHandle] = nil
	end
end

function OnServerDataIn (nHandle, strData)
	if (ServerBuffer and ServerBuffer [nHandle]) then
		ServerBuffer [nHandle] = ServerBuffer [nHandle] .. strData
		local content, headers = ProcessHTTP (nHandle, true)
		if (headers and content) then
			if (headers.NOTIFY) then
				C4:ServerSend (nHandle, 'HTTP/1.1 200 OK\r\n\r\n')
				local deviceUuid, serviceId = string.match (headers.NOTIFY, '/notify/(.-)/(.-) HTTP/')
				for property in string.gfind (content, '<e:property>(.-)</e:property>') do
					local variable, data = string.match (property, '<(.-)>(.-)</.->')
					data = XMLDecode (data)
					if (UPNPEvent and UPNPEvent [serviceId] and UPNPEvent [serviceId] [variable]) then
						UPNPEvent [serviceId] [variable] (data)
					else
						print (serviceId, variable, data)
					end
				end
			end
			if (not (headers.CONNECTION and headers.CONNECTION == 'Keep-Alive')) then
				C4:ServerCloseClient (nHandle)
			end
		end
	end
end

function ProcessHTTP (idBinding, isServer)

	local Buffer = Buffer
	if (isServer) then Buffer = ServerBuffer end

	local i, _, HTTP_Header, HTTP_Content = string.find (Buffer [idBinding], '(.-\r\n)\r\n(.*)')

	if (i == nil) then	-- no <cr><lf><cr><lf> received yet
		return
	end

	local rcvHeaders = {}

	string.gsub (HTTP_Header, '([^%s:]+):?%s?([^\r\n]*)\r\n', function (a, b) rcvHeaders [string.upper (a)] = b return '' end)

	if (rcvHeaders ['CONTENT-LENGTH'] and HTTP_Content:len() < tonumber (rcvHeaders ['CONTENT-LENGTH'])) then	-- Packet not complete yet, still waiting for content to arrive
		return
	end

	if (rcvHeaders ['TRANSFER-ENCODING'] and string.find (rcvHeaders ['TRANSFER-ENCODING'], 'chunked')) then	--what about a stream? Do we need to deal with that?
		local result = ''
		local lastChunk = false

		while (not lastChunk) do
			local _, chunkStart, chunkLen = string.find (HTTP_Content, '^%W-(%x+).-\r\n')	--allow for chunk extensions between HEX and crlf
			if (not chunkLen) then return end --waiting for more HTTP chunks	--waiting for more to come in?
			chunkLen = tonumber (chunkLen, 16)

			if (chunkLen == 0 or chunkLen == nil) then
				lastChunk = true
			else
				result = result .. string.sub (HTTP_Content, chunkStart + 1, chunkStart + chunkLen)

				HTTP_Content = string.sub (HTTP_Content, chunkStart + chunkLen + 1)
			end
		end

		HTTP_Content = result
	end

	Buffer [idBinding] = ''

	if (HTTP_Content == nil) then HTTP_Content = '' end

	return HTTP_Content, rcvHeaders
end

-----------------------------------------------
--UPNP subscribe
-----------------------------------------------
function UPNPServiceSubscribe (serviceId)
	if (not CALLBACK) then print ('Callback server not initialized, waiting') return end
	if (not CURRENT_DEVICE) then print ('Subscribe Error: Device not set') return end

	local sId, path
	for id, info in pairs (Subscriptions or {}) do
		if (info and info.deviceUuid == CURRENT_DEVICE and info.serviceId == serviceId) then
			sId = id
			path = info.path
			break
		end
	end

	local device = DlnaDevices [CURRENT_DEVICE]
	local service = UPNPServices [CURRENT_DEVICE][serviceId]

	if (sId and path) then
		if (Subscriptions [sId].TIMER) then Subscriptions [sId].TIMER = Subscriptions [sId].TIMER:Cancel () end
	else
		path = service.eventSubURL
	end

	if (sId) then
		print ('Resubscribing ', device.friendlyName, serviceId)
	else
		print ('Subscribing ', device.friendlyName, serviceId)
	end

	if (not path) then print ('service not found') return end

	local headers = {TIMEOUT = 'Second-3600'}
	if (sId) then
		headers.SID = sId
	else
		headers.CALLBACK = '<' .. CALLBACK .. CURRENT_DEVICE .. '/' .. serviceId .. '>'
		headers.NT = 'upnp:event'
	end

	urlCustom (path, 'SUBSCRIBE', '', headers, UPNPServiceSubscribeResponse, {deviceUuid = CURRENT_DEVICE, serviceId = serviceId, path = path, sId = sId})
end

function UPNPServiceSubscribeResponse (strError, responseCode, tHeaders, data, context, url)
	if (strError == nil and responseCode == 200) then
		local timeout = 3600
		if (tHeaders and tHeaders.SID) then
			local sId = tHeaders.SID

			if (not Subscriptions) then Subscriptions = {} end
			Subscriptions [sId] = context

			timeout = tonumber (string.sub ((tHeaders.TIMEOUT or ''), 8)) or timeout

			local deviceName = DlnaDevices [CURRENT_DEVICE].friendlyName
			if (context.sId) then
				print ('Resubscribed ', deviceName, context.serviceId, timeout)
			else
				print ('Subscribed ', deviceName, context.serviceId, timeout)
			end

			if (Subscriptions [sId].TIMER) then Subscriptions [sId].TIMER = Subscriptions [sId].TIMER:Cancel () end
			Subscriptions [sId].TIMER = C4:SetTimer ((timeout - 10) * 1000, function (timer)
																				UPNPServiceSubscribe (context.serviceId)
																		end)
		end

	elseif (strError == nil and responseCode == 412) then
		if (context.sId and Subscriptions [context.sId]) then
			if (Subscriptions [context.sId].TIMER) then Subscriptions [context.sId].TIMER = Subscriptions [context.sId].TIMER:Cancel () end
			Subscriptions [context.sId] = nil
		end

		local sub
		repeat
			sub = 'EVSUB' .. math.random (1000000, 9999999)
		until (not Subscriptions [sub])
		Subscriptions [sub] = context

		if (Subscriptions [sub].TIMER) then Subscriptions [sub].TIMER = Subscriptions [sub].TIMER:Cancel () end
		Subscriptions [sub].TIMER = C4:SetTimer (5 * 1000, function (timer)
																Subscriptions [sub] = nil
																UPNPServiceSubscribe (context.serviceId)
																	end)

	else
		print ('Error subscribing:' .. strError or '')
		if (context.sId and Subscriptions [context.sId]) then
			if (Subscriptions [context.sId].TIMER) then Subscriptions [context.sId].TIMER = Subscriptions [context.sId].TIMER:Cancel () end
			Subscriptions [context.sId] = nil
		end
	end
end

function UPNPServiceUnsubscribe (serviceId)
	if (not CURRENT_DEVICE) then print ('Unsubscribe Error: Device not set') return end
	local device = DlnaDevices [CURRENT_DEVICE]
	local service = UPNPServices [CURRENT_DEVICE][serviceId]

	local sId, path
	for id, info in pairs (Subscriptions or {}) do
		if (info and info.deviceUuid == CURRENT_DEVICE and info.serviceId == serviceId) then
			sId = id
			path = info.path
			break
		end
	end

	print ('Unsubscribing ', device.friendlyName, serviceId)

	if (not path) then print ('Service not subscribed, cannot unsubscribe') return end

	if (Subscriptions [sId].TIMER) then Subscriptions [sId].TIMER = Subscriptions [sId].TIMER:Cancel () end
	Subscriptions [sId] = nil

	urlCustom (path, 'UNSUBSCRIBE', '', {SID = sId}, UPNPServiceUnsubscribeResponse, {deviceUuid = CURRENT_DEVICE, serviceId = serviceId, path = path, sId = sId})
end

function UPNPServiceUnsubscribeResponse (strError, responseCode, tHeaders, data, context, url)
	if (strError == nil and responseCode == 200) then
		local deviceName = DlnaDevices [CURRENT_DEVICE].friendlyName
		print ('Unsubscribed ', deviceName, context.serviceId)
	end
end
