require("CPELungsIrritationServer");
require("CPETemporaryBlindnessServer");

CPERecipeCode = CPERecipeCode or {};
CPERecipeCode.OnCreate = CPERecipeCode.OnCreate or {};

CPERecipeCode.RUBBER_GLOVE_TYPES = {
    ["Base.Gloves_Dish"] = true,
    ["Base.Gloves_Surgical"] = true,
    ["Base.Gloves_GarbageBag"] = true,
};

CPERecipeCode.LEATHER_GLOVE_TYPES = {
    ["Base.Gloves_IceHockeyGloves_Blue"] = true,
    ["Base.Gloves_IceHockeyGloves_White"] = true,
    ["Base.Gloves_IceHockeyGloves_Black"] = true,
    ["Base.Gloves_IceHockeyGloves"] = true,
    ["Base.Gloves_LeatherGlovesBrown"] = true,
    ["Base.Gloves_LeatherGlovesBlack"] = true,
    ["Base.Gloves_LeatherGloves"] = true,
};

CPERecipeCode.SAFETY_GOGGLES_TYPES = {
    ["Base.Glasses_OldWeldingGoggles"] = true,
    ["Base.Glasses_SafetyGoggles"] = true,
    ["Base.Glasses_SkiGoggles"] = true,
    ["Base.Glasses_SwimmingGoggles"] = true,
    ["Base.WeldingMask"] = true,
    ["Base.Hat_GasMask"] = true,
    ["Base.Hat_GasMask_nofilter"] = true,
    ["Base.Hat_ImprovisedGasMask"] = true,
    ["Base.Hat_ImprovisedGasMask_nofilter"] = true,
};

CPERecipeCode.MASK_TYPES = {
    ["Base.Hat_DustMask"] = true,
    ["Base.Hat_GasMask"] = true,
    ["Base.Hat_ImprovisedGasMask"] = true,
    ["Base.Hat_SurgicalMask"] = true,
    ["Base.Hat_BuildersRespirator"] = true,
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



function CPERecipeCode.OnCreate.CraftSlakedLime(craftRecipeData, character)

    if(character:isGodMod()) then return; end

    local handInjury = false;
    local eyeInjury = false;
    local lungsIrritation = false;
    
    local handIsProtected = hasProtection(character, CPERecipeCode.RUBBER_GLOVE_TYPES)
        or (SandboxVars.CraftablePaintEdition.AllowLeatherGlovesProtectiveGear and hasProtection(character, CPERecipeCode.LEATHER_GLOVE_TYPES));

    local bodyDamage = character:getBodyDamage();

    if (SandboxVars.CraftablePaintEdition.AllowHandsBurning and not handIsProtected) then
        local handL = bodyDamage:getBodyPart(BodyPartType.Hand_L);
        local handR = bodyDamage:getBodyPart(BodyPartType.Hand_R);
        handL:setBurnTime(50);
        handL:setNeedBurnWash(true);
        handL:setAdditionalPain(handL:getAdditionalPain() + 30);
        handR:setBurnTime(50);
        handR:setNeedBurnWash(true);
        handR:setAdditionalPain(handR:getAdditionalPain() + 30);

        syncBodyPart(handL, 0x380400000);
        syncBodyPart(handR, 0x380400000);

        handInjury = true;
    end

    if (SandboxVars.CraftablePaintEdition.AllowTemporaryBlindness and not hasProtection(character, CPERecipeCode.SAFETY_GOGGLES_TYPES)) then
        local instance = CPETemporaryBlindnessServer.getInstanceForPlayer(character, character:getPlayerNum(), character:getOnlineID());
        local head = bodyDamage:getBodyPart(BodyPartType.Head);
        head:setAdditionalPain(head:getAdditionalPain() + 30);

        syncBodyPart(head, 0x400000);

        instance:activate(ZombRand(SandboxVars.CraftablePaintEdition.TemporaryBlindnessDurationMin, SandboxVars.CraftablePaintEdition.TemporaryBlindnessDurationMax));
        
        eyeInjury = true;
    end

    if (SandboxVars.CraftablePaintEdition.AllowLungsIrritation and not hasProtection(character, CPERecipeCode.MASK_TYPES)) then
        local instance = CPELungsIrritationServer.getInstanceForPlayer(character, character:getPlayerNum(), character:getOnlineID());
        local torsoUpper = bodyDamage:getBodyPart(BodyPartType.Torso_Upper);
        torsoUpper:setAdditionalPain(torsoUpper:getAdditionalPain() + 30);

        syncBodyPart(torsoUpper, 0x400000);

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