-- Copyright 2020 Wirepath Home Systems, LLC. All rights reserved.

function OnDriverInit (dit)
	C4:UpdateProperty ('OnDriverInit DIT Value', dit)
end

function OnDriverLateInit (dit)
	C4:UpdateProperty ('OnDriverLateInit DIT Value', dit)
end

function OnDriverDestroyed (dit)
	C4:UpdateProperty ('OnDriverDestroyed DIT Value', dit)
end