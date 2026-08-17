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
