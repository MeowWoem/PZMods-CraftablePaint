require("CPELungsIrritationServer");
require("CPETemporaryBlindnessServer");

Recipe = Recipe or {};
Recipe.OnCreate = Recipe.OnCreate or {};

local RUBBER_GLOVE_TYPES = {
    ["Base.Gloves_Dish"] = true,
    ["Base.Gloves_Surgical"] = true,
};

local SAFETY_GOGGLES_TYPES = {
    ["Base.Glasses_OldWeldingGoggles"] = true,
    ["Base.Glasses_SafetyGoggles"] = true,
    ["Base.Glasses_SkiGoggles"] = true,
    ["Base.Glasses_SwimmingGoggles"] = true,
    ["Base.WeldingMask"] = true,
};

local MASK_TYPES = {
    ["Base.Mask_Dust"] = true,
    ["Base.Mask_Gas"] = true,
    ["Base.Mask_Surgical"] = true,
};

local function hasProtection(character, protectionType)
    local inv = character:getInventory();
    local items = inv:getItems();

    for i = 0, items:size() - 1 do
        local item = items:get(i);
        if protectionType[item:getFullType()] and character:isEquippedClothing(item) then
            return true;
        end
    end

    return false;
end



function Recipe.OnCreate.CraftSlakedLime(craftRecipeData, character)

    if(character:isGodMod()) then return; end

    local handInjury = false;
    local eyeInjury = false;
    local lungsIrritation = false;

    if (SandboxVars.CraftablePaintEdition.AllowHandsBurning and not hasProtection(character, RUBBER_GLOVE_TYPES)) then
        local bodyDamage = character:getBodyDamage();
        local handL = bodyDamage:getBodyPart(BodyPartType.Hand_L);
        local handR = bodyDamage:getBodyPart(BodyPartType.Hand_R);
        handL:setBurnTime(50);
        handL:setNeedBurnWash(true);
        handL:setAdditionalPain(handL:getAdditionalPain() + 30);
        handR:setBurnTime(50);
        handR:setNeedBurnWash(true);
        handR:setAdditionalPain(handR:getAdditionalPain() + 30);
        handInjury = true;
    end

    if (SandboxVars.CraftablePaintEdition.AllowTemporaryBlindness and not hasProtection(character, SAFETY_GOGGLES_TYPES)) then
        local instance = CPETemporaryBlindnessServer.getInstanceForPlayer(character, character:getPlayerNum(), character:getOnlineID());
        --instance:activate(20);
        instance:activate(ZombRand(SandboxVars.CraftablePaintEdition.TemporaryBlindnessDurationMin, SandboxVars.CraftablePaintEdition.TemporaryBlindnessDurationMax));
        eyeInjury = true;
    end

    if (SandboxVars.CraftablePaintEdition.AllowLungsIrritation and not hasProtection(character, MASK_TYPES)) then
        local instance = CPELungsIrritationServer.getInstanceForPlayer(character, character:getPlayerNum(), character:getOnlineID());
        --instance:activate(20);
        instance:activate(ZombRand(SandboxVars.CraftablePaintEdition.LungsIrritationDurationMin, SandboxVars.CraftablePaintEdition.LungsIrritationDurationMax));
        lungsIrritation = true;
    end

    if(handInjury or eyeInjury or lungsIrritation) then
        if(isMultiplayer()) then
            sendServerCommand("CPEClient", "injurePlayer", {
                playerNum   = character:getPlayerNum(),
                playerOnlineID   = character:getOnlineID(),
                handInjury = handInjury,
                eyeInjury = eyeInjury,
                lungsIrritation = lungsIrritation,
            });
        else
            CPEInjuryFeedback.notify(character, handInjury, eyeInjury, lungsIrritation);
        end
    end

end