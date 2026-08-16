require "ISUI/Maps/ISWorldMap";

local old_ISWorldMap_IsAllowed = ISWorldMap.IsAllowed;

-- function ISWorldMap.IsAllowed()
-- 	if(not old_ISWorldMap_IsAllowed()) then return false; end
--     --return CPETemporaryBlindness.getInstance():canReadMap();
--     return true;
-- end