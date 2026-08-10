local recipesToPatch = {
    Base = {
        MixPaintGrey = {
            ["Base.PaintWhite"] = 0.5,
            ["Base.PaintBlack"] = 0.5,
        },
        MixPaintOrange = {
            ["Base.PaintRed"] = 0.5,
            ["Base.PaintYellow"] = 0.5,
        },
        MixPaintCyan = {
            ["Base.PaintBlue"] = 0.5,
            ["Base.PaintGreen"] = 0.5,
        },
        MixPaintLightBrown = {
            ["Base.PaintBrown"] = 0.3,
            ["Base.PaintWhite"] = 0.7,
        },
        MixPaintLightBlue = {
            ["Base.PaintBlue"] = 0.3,
            ["Base.PaintWhite"] = 0.7,
        },
    },
};

CraftablePaintMod = {};
CraftablePaintMod.paintUseDelta = 0.1;
CraftablePaintMod.wallpaperModRecipesToPatch = {
    Base = {
        WallpapersMixPaintMagenta = {
            inputs = {
                ["Base.PaintRed"] = 0.5,
                ["Base.PaintBlue"] = 0.5,
            },
            output = "Base.PaintMagenta",
        },
        WallpapersMixPaintDustBlue = {
            inputs = {
                ["Base.PaintBlue"] = 0.7,
                ["Base.PaintGrey"] = 0.3,
            },
            output = "Base.PaintDustBlue",
        },
        WallpapersMixPaintDustGreen = {
            inputs = {
                ["Base.PaintGreen"] = 0.7,
                ["Base.PaintGrey"] = 0.3,
            },
            output = "Base.PaintDustGreen",
        },
        WallpapersMixPaintDustLilac = {
            inputs = {
                ["Base.PaintPurple"] = 0.7,
                ["Base.PaintGrey"] = 0.3,
            },
            output = "Base.PaintDustLilac",
        },
        WallpapersMixPaintDustOrange = {
            inputs = {
                ["Base.PaintOrange"] = 0.7,
                ["Base.PaintGrey"] = 0.3,
            },
            output = "Base.PaintDustOrange",
        },
        WallpapersMixPaintCamoGreen = {
            inputs = {
                ["Base.PaintGreen"] = 0.6,
                ["Base.PaintBrown"] = 0.4,
            },
            output = "Base.PaintCamoGreen",
        },
        WallpapersMixPaintMidGreen = {
            inputs = {
                ["Base.PaintGreen"] = 0.85,
                ["Base.PaintWhite"] = 0.15,
            },
            output = "Base.PaintMidGreen",
        },
        WallpapersMixPaintMidBlue = {
            inputs = {
                ["Base.PaintBlue"] = 0.85,
                ["Base.PaintWhite"] = 0.15,
            },
            output = "Base.PaintMidBlue",
        },
        WallpapersMixPaintLightOrange = {
            inputs = {
                ["Base.PaintOrange"] = 0.3,
                ["Base.PaintWhite"] = 0.7,
            },
            output = "Base.PaintLightOrange",
        },
        WallpapersMixPaintLightYellow = {
            inputs = {
                ["Base.PaintYellow"] = 0.3,
                ["Base.PaintWhite"] = 0.7,
            },
            output = "Base.PaintLightYellow",
        },
        WallpapersMixPaintIvory = {
            inputs = {
                ["Base.PaintWhite"] = 0.9,
                ["Base.PaintYellow"] = 0.1,
            },
            output = "Base.PaintIvory",
        },
        WallpapersMixPaintWine = {
            inputs = {
                ["Base.PaintRed"] = 0.7,
                ["Base.PaintBlack"] = 0.3,
            },
            output = "Base.PaintWine",
        },
        WallpapersMixPaintViolet = {
            inputs = {
                ["Base.PaintBlue"] = 0.5,
                ["Base.PaintPurple"] = 0.5,
            },
            output = "Base.PaintViolet",
        },
        WallpapersMixPaintPeach = {
            inputs = {
                ["Base.PaintWhite"] = 0.5,
                ["Base.PaintPink"] = 0.3,
                ["Base.PaintOrange"] = 0.2,
            },
            output = "Base.PaintPeach",
        },
        WallpapersMixPaintDarkGrey = {
            inputs = {
                ["Base.PaintBlack"] = 0.7,
                ["Base.PaintWhite"] = 0.3,
            },
            output = "Base.PaintDarkGrey",
        },
        WallpapersMixPaintLime = {
            inputs = {
                ["Base.PaintYellow"] = 0.5,
                ["Base.PaintGreen"] = 0.5,
            },
            output = "Base.PaintLime",
        },
        WallpapersMixPaintBeige = {
            inputs = {
                ["Base.PaintWhite"] = 0.8,
                ["Base.PaintBrown"] = 0.2,
            },
            output = "Base.PaintBeige",
        },
    },
};

local buildItemLines = function(patch, multiplier)
    local itemLines = "";
    for itemType, ratio in pairs(patch) do
        local count = math.floor(((ratio * multiplier) / CraftablePaintMod.paintUseDelta) + 0.5);
        itemLines = itemLines .. string.format("item %d [%s],\n", count, itemType);
    end
    return itemLines;
end

local patchRecipeVariant = function(recipeName, patch, namespace, bulk, output)
    local fullName = recipeName .. (bulk and "Bulk" or "");
    local recipe = ScriptManager.instance:getCraftRecipe(namespace .. "." .. fullName);

    if not recipe then return; end

    recipe:getInputs():clear();

    local itemLines = buildItemLines(output and patch.inputs or patch, bulk and 2 or 1);
    local bucketLine = bulk and "" or "item 1 [Base.PaintbucketEmpty],\n";

    local outputsBlock = "";
    if output then
        recipe:getOutputs():clear();
        outputsBlock = string.format([[
        outputs {
            item %d %s,
        }]], bulk and 2 or 1, patch.output);
    end

    local patchString = string.format([[{
        inputs {
            %s%s
        }
        %s
    }]], bucketLine, itemLines, outputsBlock);

    recipe:Load(fullName, patchString);
end

CraftablePaintMod.patchRecipe = function(recipeName, patch, namespace, output)
    namespace = namespace or "Base";
    output = output or false;
    patchRecipeVariant(recipeName, patch, namespace, false, output);
    patchRecipeVariant(recipeName, patch, namespace, true, output);

end

CraftablePaintMod.onGameBoot = function()
    print("CraftablePaintMod : Patch paint recipes");
    local itemBlack = ScriptManager.instance:getItem("Base.PaintBlack");
    if not itemBlack then return; end
    CraftablePaintMod.paintUseDelta = itemBlack:getUseDelta();

    for namespace, patches in pairs(recipesToPatch) do
        for recipeName, patch in pairs(patches) do
            CraftablePaintMod.patchRecipe(recipeName, patch, namespace);
        end
    end

    
    if getActivatedMods():contains("WallpapersB42") == true then
        print("CraftablePaintMod : Wallpapers mod detected !");
        for namespace, patches in pairs(CraftablePaintMod.wallpaperModRecipesToPatch) do
            for recipeName, patch in pairs(patches) do
                CraftablePaintMod.patchRecipe(recipeName, patch, namespace, true);
            end
        end
    end
end

Events.OnGameBoot.Add(CraftablePaintMod.onGameBoot);