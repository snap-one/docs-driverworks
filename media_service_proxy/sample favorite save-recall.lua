function OnDriverLateInit ()
	MS_DEVICE_ID, AMP_DEVICE_ID = C4:GetProxyDevices () --assuming that the MSP proxy is first in <proxies> in driver.xml
	SYNC_TO_MEDIA_DB = true -- control this with a property, ideally defaulting to false
	FavList = {} -- initialize this with your favorites.
end

function SyncFavorites ()
	PersistData = PersistData or {}
	if (FavList) then

		-- check what's already in the media DB for our favorites
		local stationsByStationId = {}

		if (SYNC_TO_MEDIA_DB) then
			C4:MediaSetDeviceContext (MS_DEVICE_ID)
			local stations = C4:MediaGetAllBroadcastAudio ()

			for mediaId, stationId in pairs (stations or {}) do
				stationsByStationId [stationId] = mediaId
			end
		end

		-- go through the favorites from the device

		for _, fav in ipairs (FavList) do
			-- this shows the data structure of the FavList items; adjust if yours are different
			local id = fav.id
			local name = fav.name
			local imageUrl = fav.imageUrl
			local description = fav.description
			local serviceName = (fav.service and fav.service.name) or nil

			if (SYNC_TO_MEDIA_DB) then
				local mediaId = stationsByStationId [id]

				-- if it's already in the media DB, set it so that we don't remove it later
				if (mediaId) then
					local mediaInfo = C4:MediaGetBroadcastAudioInfo (mediaId)

					-- media DB can't handle renaming a favorite, so we need to delete the existing one and recreate.
					-- this WILL break programming that relies on the favorite ID, so encourage them not to rename!

					if (mediaInfo.name ~= name) then
						dbg ('Removing ' .. mediaInfo.name .. ': name changed to : ' .. name)
						C4:MediaRemoveBroadcastAudio (mediaId)
						mediaId = nil
					end
					stationsByStationId [id] = nil
				end

				-- if it didn't exist, or we renamed it above:

				if (mediaId == nil) then
					local station = {
						name = name,
						audio_only = "True",
						description = description,
						genre = serviceName,
					}

					-- the media DB needs the images included as base64 blobs, not as URLs, hence this next section

					local addStation = function (ticketId, strData, responseCode, tHeaders, strError)
						if (responseCode == 200 and strError == nil) then
							if (strData) then
								local imageData = C4:Base64Encode (strData)
								station.cover_art = imageData
								dbg ('Adding station with image: ', id, name)
							else
								dbg ('Adding station without image: ', id, name)
							end
							C4:MediaAddBroadcastAudioInfo (id, name, station)
						end
					end

					if (imageUrl) then
						C4:urlGet (imageUrl, {}, false, addStation)
					else
						addStation (nil, nil, 200)
					end
				end
			end
		end

		-- catch all the stations that were in the media DB, but aren't in the favorite list now and remove them
		if (SYNC_TO_MEDIA_DB) then
			for id, mediaId in pairs (stationsByStationId or {}) do
				local mediaInfo = C4:MediaGetBroadcastAudioInfo (mediaId)
				dbg ('Removing ' .. mediaInfo.name .. ' : no longer a favorite')
				C4:MediaRemoveBroadcastAudio (mediaId)
			end
		end
	end
end

function RemoveAllFavorites ()
	C4:MediaSetDeviceContext (MS_DEVICE_ID)
	local stations = C4:MediaGetAllBroadcastAudio ()

	for mediaId, stationId in pairs (stations or {}) do
		C4:MediaRemoveBroadcastAudio (mediaId)
	end
end


function ReceivedFromProxy (idBinding, strCommand, tParams, args)

	-- handle a favorite being selected
	if (strCommand == 'SELECT_SOURCE') then
		local mediaId = tonumber (tParams.MEDIA_ID)
		local roomId = tonumber (tParams.ROOM_ID)

		if (mediaId and mediaId ~= 0) then
			C4:MediaSetDeviceContext (MS_DEVICE_ID)
			local mediaInfo = C4:MediaGetBroadcastAudioInfo (mediaId)
			if (mediaInfo and mediaInfo.location) then
				local id = mediaInfo.location
				-- eg SelectFavorite (id, roomId)
			end
		end
	end
end

