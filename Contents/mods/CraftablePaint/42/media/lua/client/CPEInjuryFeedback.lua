CPEInjuryFeedback = {};

local function joinWithAnd(items)
    local result = "";
    local count = #items;
    for i, item in ipairs(items) do
        if(i == 1) then
            result = item;
        elseif(i == count) then
            result = result .. " " .. getText("IGUI_CPE_And") .. " " .. item;
        else
            result = result .. ", " .. item;
        end
    end
    return result;
end
 
function CPEInjuryFeedback.notify(character, handInjury, eyeInjury, lungsIrritation)
    local symptoms = {};
    local missingProtections = {};
 
    if(handInjury) then
        table.insert(symptoms, getText("IGUI_CPE_HandBurnSymptom"));
        table.insert(missingProtections, getText("IGUI_CPE_ProtectionGloves"));
    end
    if(eyeInjury) then
        table.insert(symptoms, getText("IGUI_CPE_EyeIrritationSymptom"));
        table.insert(missingProtections, getText("IGUI_CPE_ProtectionGoggles"));
    end
    if(lungsIrritation) then
        table.insert(symptoms, getText("IGUI_CPE_LungsIrritationSymptom"));
        table.insert(missingProtections, getText("IGUI_CPE_ProtectionMask"));
    end
 
    if(#symptoms == 0) then return; end
 
    local message = table.concat(symptoms, " ") .. "\n" .. getText("IGUI_CPE_PreventionAdvice", joinWithAnd(missingProtections));
    CPEUtils.addBadText(character, message);
 
    if(handInjury or eyeInjury) then
        character:transmitPlayerVoiceSound("PainFromLacerate");
    end
end

local function onServerCommand(module, command, args)
    if(module == "CPEClient") then
        if(command == "injurePlayer") then
            local player = getPlayerByOnlineID(args.playerOnlineID);
            if(not player or not player:isLocalPlayer()) then return; end
            CPEInjuryFeedback.notify(player, args.handInjury, args.eyeInjury, args.lungsIrritation);
        end
    end
end

Events.OnServerCommand.Add(onServerCommand);