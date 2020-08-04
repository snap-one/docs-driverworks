-- Copyright 2020 Wirepath Home Systems, LLC. All rights reserved.

common_lib = require ('common.common_lib')
common_url = require ('common.common_url')
common_timer = require ('common.common_timer')
common_handlers = require ('common.common_handlers')

OAuth = require ('oauth.auth_code_grant')
Link = require ('link.make_short_link')

REDIRECT_URI_PROD = 'https://apps.control4.com/'
REDIRECT_URI_DEV = 'https://apps.control4dev.com/'

function OnDriverLateInit ()
	for property, _ in pairs (Properties) do
		OnPropertyChanged (property)
	end

	if (PersistData.APIAuthSetup) then
		CreateAPIOAuthHandler (PersistData.APIAuthSetup)

		local refreshToken = C4:PersistGetValue ('API Refresh Token', true)

		if (refreshToken) then

			local _callback = function ()
				print ('Token refreshed automatically on startup')
			end

			local contextInfo = {
				from_startup = true,
				callback = _callback,
			}
			APIAuth:RefreshToken (contextInfo, refreshToken)
		end
	end
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

	if (not (authForOAuth and authEndpoint and tokenEndpoint and clientId and clientSecret)) then
		print ('missing info')
		return
	end

	local tParams = {
		AUTHORIZATION = authForOAuth,

		REDIRECT_URI = redirectURI,

		AUTH_ENDPOINT_URI = authEndpoint,
		TOKEN_ENDPOINT_URI = tokenEndpoint,

		API_CLIENT_ID = clientId,
		API_SECRET = clientSecret,

		SCOPES = scope,

		REDIRECT_DURATION = 5 * 60,
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

	APIAuth.notifyHandler.ActivationTimeOut = function (contextInfo)
		UpdateAuthLink ('', contextInfo)
	end

	APIAuth.notifyHandler.LinkCodeReceived = function (contextInfo, link)
		if (authForLink) then
			local _linkCallback = function (link)
				UpdateAuthLink (link, contextInfo)
			end
			MakeShortLink (link, _linkCallback, authForLink)
		else
			UpdateAuthLink (link, contextInfo)
		end
	end

	APIAuth.notifyHandler.LinkCodeConfirmed = function (contextInfo)
	end

	APIAuth.notifyHandler.LinkCodeWaiting = function (contextInfo)
	end

	APIAuth.notifyHandler.LinkCodeError = function (contextInfo)
		UpdateAuthLink ('', contextInfo)
	end

	APIAuth.notifyHandler.LinkCodeDenied = function (contextInfo, err, err_description, err_uri)
		UpdateAuthLink ('', contextInfo)
	end

	APIAuth.notifyHandler.LinkCodeExpired = function (contextInfo)
		UpdateAuthLink ('', contextInfo)
	end

	APIAuth.notifyHandler.AccessTokenGranted = function (contextInfo, accessToken, refreshToken)
		print ('Access Token received, accessToken:' .. tostring (accessToken ~= nil) .. ', refreshToken:' .. tostring (refreshToken ~= nil))

		UpdateAuthLink ('', contextInfo)

		if (accessToken) then
			HEADERS = HEADERS or {}
			HEADERS ['Authorization'] = 'Bearer ' .. accessToken
		end

		if (refreshToken) then
			C4:PersistSetValue ('API Refresh Token', refreshToken, true)
		else
			C4:PersistDeleteValue ('API Refresh Token')
		end

		if (contextInfo.callback) then
			if (type (contextInfo.callback) == 'function') then
				pcall (contextInfo.callback)
			end
		end
	end

	APIAuth.notifyHandler.AccessTokenDenied = function (contextInfo, err, err_description, err_uri)
		print ('Access Token denied', err, err_description, err_uri)

		HEADERS = HEADERS or {}
		HEADERS ['Authorization'] = nil

		C4:PersistDeleteValue ('API Refresh Token')
	end
end

function UpdateAuthLink (link, context)
	UpdateProperty ('Authentication URL', link)
end
