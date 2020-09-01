--Copyright 2017 Control4 Corporation. All rights reserved.

function ExecuteCommand (strCommand, tParams)
--[[
This function call is triggered by a programming script running that contains a <command> from this driver, or by selecting an <action> from the Actions tab in this driver in Composer

--parameters
strCommand - the <name> of the <command> in the driver.xml if a programming command, or LUA_ACTION if an <action> selected from the Actions tab in Composer
tParams - the table of key/value pairs defined in the driver.xml for this <action> or <command>.  Additionally contains ACTION key with value of <name> if an <action>.

--effect
prints the name of the function, the name of the command and then a list of all the parameters to the function
--]]
	local output = {'--- ExecuteCommand', strCommand, '----PARAMS----'}
	for k,v in pairs (tParams) do table.insert (output, tostring (k) .. ' = ' .. tostring (v)) end
	table.insert (output, '---')
	print (table.concat (output, '\r\n'))
end

function CustomSelectDemoFunction (currentValue, callbackWhenDone, search, filter)

--[[
This function call is triggered by pressing the ... button next to a CUSTOM_SELECT type parameter to a command or action in Composer, and by moving through the menu structure in the popup.
The name of the function is specified with the type : <type>CUSTOM_SELECT:CustomSelectDemoFunction</type> will trigger the function named CustomSelectDemoFunction

--parameters
currentValue (string) - the "value" of the chosen item in the popup, or the "value" of an item that is a folder to drill into
callbackWhenDone (function) - a reference to a Lua function (callback) used to return the list and other options.  Can be used instead of returning values from the current function.
search (string, optional - default nil) - the text typed into the search text box in Composer (and then Enter pressed or a filter chosen to trigger this function call).
filter (string, optional - default nil) - the name attribute from the filter selected in Composer as defined in the <filters> section in the driver.xml

--arguments to callbackWhenDone / return (list, back, searchable)
list (table, required)- a 1-indexed table (array-like) of tables, each containing the following keys:
				text (string, required) - the text that will be displayed in Composer for this item
				value (string, required) - the value for this item that will be sent to ExecuteCommand when triggered
				folder (boolean, optional - default false) - whether this item can be double clicked in Composer to display a new list of "child" items
				selectable (boolean, optional - default true unless folder is true) - if this item is selected in Composer, can the OK button be pressed to "choose" this item for the parameter
			The list will be displayed in order in Composer.

back (string, optional - default nil) - if not nil, shows a Back button in the popup in Composer and defines what currentValue will be set to when it is pressed

searchable (boolean, optional, default true) - if true, enables the search dialog in the popup in Composer

--]]
	print ('CustomSelectDemoFunction', currentValue, search, filter)

	local back = nil
	local searchable = true
	local list = {}

	if (search and filter) then
		--demonstrates using the callbackWhenDone function as a callback later when we've entered a search string.  currentValue can be used as a mask inside the filter if your API supports that (for example, only searching by filter artists with search Soul when you've selected the Genre 90s in the browse list)
		CallbackFunction (currentValue, callbackWhenDone, search, filter)
		return
	end

	if (currentValue == 'popular') then
		back = '' -- Back to the root menu
		for i = 1, 10 do
			table.insert (list, {text = 'Channel #' .. i, value = 'popular' .. i})
		end

	elseif (currentValue == 'playlists') then
		back = '' -- Back to the root menu
		table.insert (list, {text = 'Mine', value = 'myplaylists', folder = true})
		for i = 1, 5 do
			table.insert (list, {text = 'Playlist ' .. i, value = 'playlists' .. i})
		end

	elseif (currentValue == 'myplaylists') then
		back = 'playlists' -- Back to the Playlists menu
		for i = 1, 2 do
			table.insert (list, {text = 'My playlist ' .. i, value = 'myplaylists' .. i})
		end

	elseif (currentValue == 'favorites') then
		back = '' -- Back to the root menu
		for i = 1, 3 do
			table.insert (list, {text = 'Favorite ' .. i, value = 'favorites' .. i})
		end

	else
		table.insert (list, {text = 'Playlists', value = 'playlists', folder = true})
		table.insert (list, {text = 'Favorites', value = 'favorites', folder = true})
		table.insert (list, {text = 'Most popular', value = 'popular', folder = true, selectable = true})
		for i = 1, 5 do
			table.insert (list, {text = 'Channel ' .. i, value = 'channel' .. i})
		end
	end

	return list, back, searchable
end

function CallbackFunction (currentValue, callbackWhenDone, search, filter)
--[[
This function call is triggered by working with searches in the main CustomSelectDemoFunction above.  It has the exact same arguments, and is here to show using the "callbackWhenDone" callback function to return data.
--]]
	print ('CallbackFunction', currentValue, callbackWhenDone, search, filter)

	local list = {}
	local back = currentValue -- return to previous position in list browse if Back pressed
	local searchable = false -- make search results not searchable

	if (filter == 'popular') then
		table.insert (list, {text = 'Popular search result 1 for ' .. search .. ' in ' .. currentValue, value = 'search:' .. filter .. ':' .. search .. ':1'})
		table.insert (list, {text = 'Popular search result 2 for ' .. search .. ' in ' .. currentValue, value = 'search:' .. filter .. ':' .. search .. ':2'})
	elseif (filter == 'playlists') then
		table.insert (list, {text = 'Playlists search result 1 for ' .. search .. ' in ' .. currentValue, value = 'search:' .. filter .. ':' .. search .. ':1'})
		table.insert (list, {text = 'Playlists search result 2 for ' .. search .. ' in ' .. currentValue, value = 'search:' .. filter .. ':' .. search .. ':2'})
	elseif (filter == 'favorites') then
		table.insert (list, {text = 'Favorites search result 1 for ' .. search .. ' in ' .. currentValue, value = 'search:' .. filter .. ':' .. search .. ':1'})
		table.insert (list, {text = 'Favorites search result 2 for ' .. search .. ' in ' .. currentValue, value = 'search:' .. filter .. ':' .. search .. ':2'})
	end

	callbackWhenDone (list, back, searchable)
end

