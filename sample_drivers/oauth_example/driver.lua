-- Copyright 2022 Snap One, LLC. All rights reserved.

require ('drivers-common-public.global.handlers')
require ('drivers-common-public.global.lib')
require ('drivers-common-public.global.make_short_link')
require ('drivers-common-public.global.url')
require ('drivers-common-public.global.timer')

OAuth = require ('drivers-common-public.module.auth_code_grant')

REDIRECT_URI_PROD = 'https://apps.control4drivers.com/'
REDIRECT_URI_DEV = 'https://apps.control4driversdev.com/'

function OnDriverLateInit ()
	for property, _ in pairs (Properties) do
		OnPropertyChanged (property)
	end

	local _timer = function (timer)
		if (PersistData.APIAuthSetup) then
			CreateAPIOAuthHandler (PersistData.APIAuthSetup)
		end
	end

	SetTimer (nil, 6 * ONE_SECOND, _timer)
end

function OPC.Debug_Mode (value)
	CancelTimer ('DEBUGPRINT')
	DEBUGPRINT = (value == 'On')

	if (DEBUGPRINT) then
		local _timer = function (timer)
			C4:UpdateProperty ('Debug Mode', 'Off')
			OnPropertyChanged ('Debug Mode')
		end
		SetTimer ('DEBUGPRINT', 36000000, _timer)
	end
end

function EC.SetupOAuth (tParams)

	for k,v in pairs (tParams) do
		if (v == '') then
			tParams [k] = nil
		end
	end

	local authForOAuth = tParams ['C4 OAuth API Key']
	local authForLink = tParams ['C4 Link API Key']

	local authEndpoint = tParams ['Authorization Endpoint']
	local tokenEndpoint = tParams ['Token Endpoint']

	local clientId = tParams ['Client ID']
	local clientSecret = tParams ['Client Secret']

	local scope = tParams ['Scope']

	local sendBasicAuth = (tParams ['Send Authorization In'] == 'Header')

	local redirectURI = (tParams ['Choose C4 OAuth Redirect Server'] == 'Production' and REDIRECT_URI_PROD) or REDIRECT_URI_DEV

	if (tParams ['Choose C4 OAuth Redirect Server'] == 'Production') then
		IN_PRODUCTION = true	-- required for choosing correct short code link server
	end

	if (not (authForOAuth and authEndpoint and tokenEndpoint and clientId and clientSecret)) then
		print ('missing info')
		return
	end

	local tParams = {
		NAME = 'OAuth Demonstrator',
		AUTHORIZATION = authForOAuth,

		SHORT_LINK_AUTHORIZATION = authForLink,
		LINK_CHANGE_CALLBACK = UpdateAPIAuthLink,

		API_CLIENT_ID = clientId,
		API_SECRET = clientSecret,

		AUTH_ENDPOINT_URI = authEndpoint,
		TOKEN_ENDPOINT_URI = tokenEndpoint,

		SCOPES = scope,

		REDIRECT_URI = redirectURI,
		REDIRECT_DURATION = 5 * 60,

		USE_BASIC_AUTH_HEADER = sendBasicAuth,
	}

	PersistData.APIAuthSetup = tParams
	CreateAPIOAuthHandler (tParams)

	local _callback = function ()
		print ('Token retrieved and stored on action')
	end

	local contextInfo = {
		from_action = true,
		callback = _callback,
	}

	APIAuth:MakeState (contextInfo, nil, nil)
end

function CreateAPIOAuthHandler (tParams)

	APIAuth = OAuth:new (tParams)

	APIAuth.notifyHandler.AccessTokenGranted = function (contextInfo, accessToken, refreshToken)
		if (accessToken) then
			HEADERS = HEADERS or {}
			HEADERS ['Authorization'] = 'Bearer ' .. accessToken
		end

		if (contextInfo.callback) then
			if (type (contextInfo.callback) == 'function') then
				pcall (contextInfo.callback)
			end
		end
	end

	APIAuth.notifyHandler.AccessTokenDenied = function (contextInfo, err, err_description, err_uri)
		HEADERS = HEADERS or {}
		HEADERS ['Authorization'] = nil
	end
end

function UpdateAPIAuthLink (link, context)
	UpdateProperty ('Authentication URL', link)
end
