-- Copyright 2025 Snap One, LLC. All rights reserved.

require ('drivers-common-public.global.lib')
require ('drivers-common-public.global.handlers')

DEBUGPRINT = true

function PopulateDynamicPropertyList ()
	local items = {
		'',
		'First Property Item',
		'Second Property Item',
		'Third Property Item',
		'Fourth Property Item',
		'Fifth Property Item',
	}

	local items = table.concat (items, ',')

	C4:UpdatePropertyList ('Property Dynamic List Selector', items)
end

function OPC.Property_Dynamic_List_Selector (value)
	UpdateProperty ('Property Dynamic List Selector', '')
	UpdateProperty ('Chosen Dynamic Property Item', value)
end

function GetCommandParamList (command, param)
	print (command, param)
	if (command == 'Command Dynamic List Selector' and param == 'Chosen Command Dynamic List Item') then
		local items = {
			'First Command Item',
			'Second Command Item',
			'Third Command Item',
			'Fourth Command Item',
			'Fifth Command Item',
		}
		return items
	end
end

function OnDriverLateInit (reason)
	PopulateDynamicPropertyList ()
end
