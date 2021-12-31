--Copyright 2021 Snap One, LLC. All rights reserved.

require ('drivers-common-public.global.lib')
require ('drivers-common-public.global.handlers')
require ('drivers-common-public.global.timer')

do

	ROOM_CURRENT_AUDIO_PATH = 1007
	DM_ID = 100002

	--[[
	<devices>
	<device>
		<id>100002</id>
		<provider_binding_id>4000</provider_binding_id>
		<consumer_binding_id>0</consumer_binding_id>
	</device>
	<device>
		<id>14</id>
		<provider_binding_id>7000</provider_binding_id>
		<consumer_binding_id>3003</consumer_binding_id>
	</device>
	</devices>
	]]

	AUDIO_CONTROLLERS = {
		'control4_ea1.c4i', -- controller is first proxy
		'control4_ea3.c4i', -- controller is first proxy
		'control4_ea5.c4i', -- controller is first proxy
		'control4_hc800.c4i', -- no proxy, so just device ID
		'control4_tr1.c4i', -- controller is first proxy
	}

	AUDIO_OUTPUTS = {
		['control4_ea1.c4i'] = {
			['HDMI'] = {
				[7000] = true, -- HDMI Audio Out Room Endpoint
				[4072] = true, -- HDMI
			},
		},
		['control4_ea3.c4i'] = {
			['STEREO'] = {
				[7000] = true, -- Analog Audio Out Room Endpoint
				[4000] = true, -- Analog
			},
			['DIGITAL_COAX'] = {
				[7001] = true, -- Digital Audio Out Room Endpoint
				[4001] = true, -- Digital Coax
			},
			['HDMI'] = {
				[7002] = true, -- HDMI Audio Out Room Endpoint
				[4072] = true, -- HDMI
			},
		},
		['control4_ea5.c4i'] = {
			['STEREO-1'] = {
				[7000] = true, -- Analog Audio Out 1 Room Endpoint
				[4000] = true, -- Analog 1
			},
			['STEREO-2'] = {
				[7001] = true, -- Analog Audio Out 2 Room Endpoint
				[4001] = true, -- Analog 2
			},
			['DIGITAL_COAX-1'] = {
				[7002] = true, -- Digital 1 Audio Out Room Endpoint
				[4002] = true, -- Digital 1 Coax
			},
			['DIGITAL_COAX-2'] = {
				[7003] = true, -- Digital 2 Audio Out Room Endpoint
				[4003] = true, -- Digital 2 Coax
			},
			['HDMI'] = {
				[7072] = true, -- HDMI Audio Out Room Endpoint
				[4070] = true, -- HDMI
			},
		},
		['control4_hc800.c4i'] = {
			['STEREO-1'] = {
				[7000] = true, -- Analog Audio Out 1 Room Endpoint
				[4000] = true, -- Analog 1
			},
			['STEREO-2'] = {
				[7001] = true, -- Analog Audio Out 2 Room Endpoint
				[4001] = true, -- Analog 2
			},
			['DIGITAL_COAX'] = {
				[7002] = true, -- Digital Audio Out Room Endpoint
				[4002] = true, -- Digital Coax
			},
			['HDMI'] = {
				[7003] = true, -- HDMI Audio Out Room Endpoint
				[4073] = true, -- HDMI
			},
		},
		['control4_tr1.c4i'] = {
			['OUTPUT'] = {
				[7000] = true, -- Room Endpoint
				[4000] = true, -- Analog
			},
		},
	}
end

function OnDriverLateInit (reason)
	C4:RegisterSystemEvent (C4SystemEvents.OnPIP, 0)
	RegisterRooms ()
	RegisterControllers ()
end

function OSE.OnPIP (event)
	RegisterRooms ()
	RegisterControllers ()
end

function RegisterControllers ()
	AudioControllers = {}
	for _, filename in ipairs (AUDIO_CONTROLLERS) do
		AudioControllers [filename] = {}
		local devices = C4:GetDevicesByC4iName (filename)
		for deviceId, deviceName in pairs (devices) do
			local proxyId = deviceId
			if (filename ~= 'control4_hc800.c4i') then
				proxyId = C4:GetProxyDevicesById (deviceId)
			end
			AudioControllers [filename] [proxyId] = deviceName
			AudioControllers [proxyId] = filename
		end
	end
end

function RegisterRooms ()
	local rooms = C4:GetDevicesByC4iName ('roomdevice.c4i')

	for roomId, roomName in pairs (rooms) do
		RegisterVariableListener (roomId, ROOM_CURRENT_AUDIO_PATH, TrackCurrentAudioPath)
	end
end

function TrackCurrentAudioPath (idDevice, idVariable, strValue)
	ParseCurrentAudioPath (idDevice, idVariable, strValue)

	local roomId = idDevice
	local roomName = C4:GetDeviceDisplayName (roomId)

	if (not (RoomAudioPaths [roomId] and next (RoomAudioPaths [roomId]))) then
		print ('nothing on in ' .. roomName)
		return
	end

	local path = RoomAudioPaths [roomId]
	local rootDevice = path [1].id

	if (rootDevice ~= DM_ID) then
		print ('Not C4 Digital Media on in ' .. roomName)
		return
	end

	local sourceController = path [2]
	local proxyId = sourceController.id
	local controllerType = AudioControllers [proxyId]

	if (not controllerType) then
		print ('Unknown controller type on in ' .. roomName)
	end

	local controllerTypeName = AudioControllers [controllerType] [proxyId]
	local controllerName = C4:GetDeviceDisplayName (proxyId)

	if (not controllerName) then
		print ('Unknown name for controller on in ' .. roomName)
	end

	if (not AUDIO_OUTPUTS [controllerType]) then
		print ('No known outputs for this controller type in ' .. roomName)
		return
	end

	local outputBinding = sourceController.provider

	for outputName, bindings in pairs (AUDIO_OUTPUTS [controllerType]) do
		print (outputBinding)
		Print (bindings)

		if (bindings [outputBinding]) then
			print ('Digital Media playing on ' .. controllerName .. ' (' .. controllerTypeName .. '), output ' .. outputName .. ' in room ' .. roomName)
			return
		end
	end

	print ('Unknown output for ' .. controllerName .. ' (' .. controllerTypeName .. ') on in room ' .. roomName)
end

function ParseCurrentAudioPath (idDevice, idVariable, strValue)
	if (idVariable ~= ROOM_CURRENT_AUDIO_PATH) then
		print ('Called TrackCurrentAudioPath but not for ROOM_CURRENT_AUDIO_PATH')
		return
	end

	local roomId = idDevice
	local audioPath = strValue

	local devices = {}
	for device in string.gmatch (audioPath, '<device>(.-)</device>') do
		local id = XMLCapture (device, 'id')
		local provider = XMLCapture (device, 'provider_binding_id')
		local consumer = XMLCapture (device, 'consumer_binding_id')

		id = tonumber (id)
		provider = tonumber (provider)
		consumer = tonumber (consumer)

		if (id and provider and consumer) then
			local info = {
				id = id,
				provider = provider,
				consumer = consumer,
			}
			table.insert (devices, info)
		end
	end

	RoomAudioPaths = RoomAudioPaths or {}
	RoomAudioPaths [roomId] = devices
end