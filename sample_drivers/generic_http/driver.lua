-- Copyright 2021 Snap One, LLC. All rights reserved.

require ('drivers-common-public.global.lib')
require ('drivers-common-public.global.timer')
require ('drivers-common-public.global.url')

JSON = require ('drivers-common-public.module.json')

function OnDriverLateInit ()
	if (not (Variables and Variables.HTTP_RESPONSE_DATA)) then
		C4:AddVariable ('HTTP_RESPONSE_DATA', '', 'STRING', true, false)
		C4:SetVariable ('HTTP_RESPONSE_DATA', '')
	end

	if (not (Variables and Variables.HTTP_RESPONSE_CODE)) then
		C4:AddVariable ('HTTP_RESPONSE_CODE', 0, 'NUMBER', true, false)
		C4:SetVariable ('HTTP_RESPONSE_CODE', 0)
	end

	if (not (Variables and Variables.HTTP_ERROR)) then
		C4:AddVariable ('HTTP_ERROR', '', 'STRING', true, false)
		C4:SetVariable ('HTTP_ERROR', '')
	end

	Presets = {}

	DEFAULT_URL_OPTIONS = DEFAULT_URL_OPTIONS or {
	}

	for property, _ in pairs (Properties) do
		OnPropertyChanged (property)
	end
end

function OnPropertyChanged (strProperty)
	local value = Properties [strProperty]
	if (value == nil) then
		value = ''
	end

	local presetNum = tonumber (string.match (strProperty, ('Preset URL (%d)')))

	if (strProperty == 'Debug Mode') then
		if (value == 'On') then
			dbg = print
		else
			dbg = function () end
		end

	elseif (strProperty == 'URL Timeout') then
		C4:urlSetTimeout (tonumber (value))

	elseif (strProperty == 'SSL Verify Peer') then
		DEFAULT_URL_OPTIONS.ssl_verify_peer = (value == 'True')

	elseif (strProperty == 'SSL Verify Host') then
		DEFAULT_URL_OPTIONS.ssl_verify_host = (value == 'True')

	elseif (presetNum) then
		Presets [presetNum] = value
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

	local preset = tonumber (tParams.PRESET)

	local url = (preset and Presets [preset]) or tParams.URL

	local headers = {
		['X-C4-DEMO-TIME'] = os.time (),
		['X-C4-SUPER-SECRET-API-KEY'] = 'hunter2',
	}

	if (url and url ~= '') then
		if (string.find (strCommand, 'GET')) then
			dbg ('Sending GET to ' .. url)
			urlGet (url, data, CheckResponse, contextInfo, DEFAULT_URL_OPTIONS)

		elseif (string.find (strCommand, 'POST')) then
			local data = tParams.DATA or ''
			dbg ('Sending POST to ' .. url .. ' with data:/r/n' .. data)
			urlPost (url, data, headers, CheckResponse, contextInfo, DEFAULT_URL_OPTIONS)
		end
	end
end

function CheckResponse (strError, responseCode, tHeaders, data, context, url)
	local output = {'---URL response---'}
	if (strError) then
		table.insert (output, strError)
	else
		table.insert (output, 'Response Code: ' .. tostring (responseCode))
		if (type (data) == 'string') then
			table.insert (output, 'Returned data: ' .. (data or ''))
			C4:SetVariable ('HTTP_RESPONSE_DATA', data)
		elseif (type (data) == 'table') then
			table.insert (output, 'Returned data (**JSON, parsed and re-encoded**): ' .. JSON:encode_pretty(data))
			C4:SetVariable ('HTTP_RESPONSE_DATA', JSON:encode_pretty(data))
		end
	end
	output = table.concat (output, '\r\n')
	dbg (output)

	if (strError) then
		C4:SetVariable ('HTTP_ERROR', strError)
		C4:SetVariable ('HTTP_RESPONSE_DATA', '')
		C4:SetVariable ('HTTP_RESPONSE_CODE', 0)
		C4:FireEvent ('Error')
	else
		C4:SetVariable ('HTTP_ERROR', '')
		C4:SetVariable ('HTTP_RESPONSE_CODE', responseCode)
		C4:FireEvent ('Success')
	end
end

function SendMultipart (url, filename, filedata)

	local boundary = GetRandomString (20)

	local headers = {
		['Content-Type'] = 'multipart/form-data; boundary=' .. boundary
	}

	local body = {
		'--' .. boundary,
		'Content-Disposition: form-data; name="file"; filename="' .. filename .. '"',
		'Content-Type: image/jpeg',
		'',
		filedata,
		'--' .. boundary .. '--',
	}

	body = table.concat (body, '\r\n')

	urlPost (url, body, headers)
end
