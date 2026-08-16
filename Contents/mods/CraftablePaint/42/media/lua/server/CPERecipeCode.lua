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
    local hasBeenInjured = false;

    if not hasProtection(character, RUBBER_GLOVE_TYPES) then
        local bodyDamage = character:getBodyDamage();
        local handL = bodyDamage:getBodyPart(BodyPartType.Hand_L);
        local handR = bodyDamage:getBodyPart(BodyPartType.Hand_R);
        handL:setBurnTime(50);
        handL:setNeedBurnWash(true);
        handL:setAdditionalPain(handL:getAdditionalPain() + 30);
        handR:setBurnTime(50);
        handR:setNeedBurnWash(true);
        handR:setAdditionalPain(handR:getAdditionalPain() + 30);
        hasBeenInjured = true;
    end

    if not hasProtection(character, SAFETY_GOGGLES_TYPES) then
        
    end

    if(hasBeenInjured) then
        character:playerVoiceSound("PainFromLacerate");
        HaloTextHelper.addBadText(character, getText("IGUI_BurnedByCausticSodaMessage"));
    end
    
end