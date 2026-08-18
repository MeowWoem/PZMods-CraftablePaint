require "ISUI/Maps/ISWorldMap";

local old_ISWorldMap_ShowWorldMap = ISWorldMap.ShowWorldMap;

function ISWorldMap.ShowWorldMap(playerNum, centerX, centerY, zoom)

    print("_______________________")
    print("_______________________")
    print("_______________________")
    print(playerNum)
    print("_______________________")
    print("_______________________")
    print("_______________________")

	local instance = CPETemporaryBlindnessClient.getInstanceForPlayer(nil, playerNum);
    if(instance and not instance:canReadMap()) then
        CPEUtils.addBadText(instance.player, getText("IGUI_CPE_CantReadMap"));
        return;
    end
    old_ISWorldMap_ShowWorldMap(playerNum, centerX, centerY, zoom)
end