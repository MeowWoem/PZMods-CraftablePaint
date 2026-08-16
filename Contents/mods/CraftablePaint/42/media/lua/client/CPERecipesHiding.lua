require "Entity/ISUI/CraftRecipe/ISHandCraftPanel";

local Recipes = {};

Recipes.hiddenRecipes = Recipes.hiddenRecipes or {};

function Recipes.hide(recipeName)
    if type(recipeName) ~= "string" or recipeName == "" then return; end 
    Recipes.hiddenRecipes[recipeName] = true;
end

function Recipes.isHidden(recipe)
    return recipe and Recipes.hiddenRecipes[recipe:getName()] == true;
end

function Recipes.filterList(recipeList)
    local filteredList = ArrayList.new();

    for i = 0, recipeList:size() - 1 do
        local recipe = recipeList:get(i);
        if not Recipes.isHidden(recipe) then
            filteredList:add(recipe);
        end
    end

    return filteredList;
end

function ISHandCraftPanel:refreshRecipeList(_forceRefresh)
    if self:updateContainers(_forceRefresh) then
        local recipes;
        if self.recipeQuery then
            recipes = CraftRecipeManager.queryRecipes(self.recipeQuery);
        else
            recipes = self.craftBench:getRecipes();
        end
        if self.seeAllRecipe then
            recipes = ScriptManager.instance:getAllCraftRecipes();
        end
        self.logic:setRecipes(Recipes.filterList(recipes));
    end
end

local OnGameBoot = function()    
    if getActivatedMods():contains("WallpapersB42") == false then
        print("CraftablePaintMod : Wallpapers mod NOT detected !");
        for namespace, patches in pairs(CraftablePaintMod.wallpaperModRecipesToPatch) do
            for recipeName, patch in pairs(patches) do
                Recipes.hide(recipeName);
                Recipes.hide(recipeName.."Bulk");
            end
        end
    end
end

Events.OnGameBoot.Add(OnGameBoot);


if(isDebugEnabled()) then
    local player = getSpecificPlayer(0);

    local enabled = false;
    local sm = getSearchMode();
    local smo = sm:getSearchModeForPlayer(0);

    local function onKeyStartPressed(key)
        if key == Keyboard.KEY_F3 then
               

        print("radius: " .. ISSearchManager.getManager(player).radius)
        print("blur: " .. ISSearchManager.getManager(player).overlayValues.blur)
        print("desat: " .. ISSearchManager.getManager(player).overlayValues.desaturation)
        print("dark: " .. ISSearchManager.getManager(player).overlayValues.darkness)

        enabled = not enabled;

        local blur = 2;
        local desat = 10;
        local radius = 0.2;
        local darkness = 1;
        local gw = 4;

        smo:getBlur():setTargets(blur, blur);
        smo:getDesat():setTargets(desat, desat);
        smo:getRadius():setTargets(radius, radius);
        smo:getDarkness():setTargets(darkness, darkness);
        smo:getGradientWidth():setTargets(gw, gw);

        --sm:setEnabled(0, enabled);
        --sm:setOverride(0, false);
        end
    end

    local function OnPlayerUpdate(player)
        
    end

    Events.OnPlayerUpdate.Add(OnPlayerUpdate)

    Events.OnKeyStartPressed.Add(onKeyStartPressed);
end
