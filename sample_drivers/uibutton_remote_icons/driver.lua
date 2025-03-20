do -- globals
	PROXY_CMDS = {}
	EX_CMDS = {}
	ON_PROPERTY_CHANGED = {}
	TOGGLE_STATE = TOGGLE_STATE or false

	STATE_NAME = STATE_NAME or {}
	STATE_NAME ['Selected'] = 'On'
	STATE_NAME ['Default'] = 'Off'
end

function OnDriverInit ()
	C4:UpdateProperty ('Driver Version', C4:GetDriverConfigInfo ("version"))
end

function OnDriverLateInit ()
	DisplayState ()
end

function ReceivedFromProxy (idBinding, strCommand, tParams)
	if type (PROXY_CMDS [strCommand]) == "function" then
		local success, retVal = pcall (PROXY_CMDS [strCommand], tParams, idBinding)
		if success then
			return retVal
		end
	end
	return nil
end

function PROXY_CMDS.SELECT (tParams, idBinding)
	STATE = not STATE
	DisplayState ()
end

function EX_CMDS.SetState (tParams)
	STATE = (tParams.State == 'On')
	DisplayState ()
end

function EX_CMDS.ToggleState (tParams)
	PROXY_CMDS.SELECT (tParams)
end

function DisplayState ()
	if STATE then
		C4:SendToProxy(5001, "ICON_CHANGED", {icon = 'Selected', icon_description = 'On'})
	else
		C4:SendToProxy(5001, "ICON_CHANGED", {icon = 'Default', icon_description = 'Off'})
	end
	C4:UpdateProperty ('Current State', tostring (STATE))
end

