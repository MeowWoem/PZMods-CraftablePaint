require "ISUI/Maps/ISWorldMap";

local old_ISWorldMap_ShowWorldMap = ISWorldMap.ShowWorldMap;

function ISWorldMap:ShowWorldMap(playerNum, centerX, centerY, zoom)
	local instance = CPETemporaryBlindnessClient.getInstanceForPlayer(nil, playerNum);
    if(not instance:canReadMap()) then
        CPEUtils.addBadText(instance.player, getText("IGUI_CPE_CantReadMap"));
        return;
    end
    old_ISWorldMap_ShowWorldMap(self, playerNum, centerX, centerY, zoom)
end