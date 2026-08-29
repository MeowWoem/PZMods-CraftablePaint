local MOD_DATA_KEY = "MD_RM_CPE_VHS_1_TEST_1";
local BOREDOM_PER_LINE = -5;

local Tapes = {
    {
        id = "RM_CPE_0-7287-42df-8b78-4486287c42f5",
        name = "RM_CPE_VHS_NAME",
        perk = nil,
        volume = 1,
        recipeSteps = {
            {
                recipes = {
                    "CraftSlakedLime",
                },
                requiredLines = {
                    { 32, 35 },
                    {39, 45}
                },
                learnedText = "RM_CPE_RECIPE_LEARNED_STEP1",
            },
            {
                recipes = {
                    "MixPaintWhite",
                    "MixPaintBlack",
                    "MixPaintYellow",
                    "MixPaintBlue",
                    "MixPaintPurple",
                    "MixPaintGreen",
                    "MixPaintPink",
                    "MixPaintTurquoise",
                    "MixPaintRed",
                    "MixPaintBrown",
                },
                requiredLines = {
                    { 49, 54 },
                    { 57, 67 },
                },
                learnedText = "RM_CPE_RECIPE_LEARNED_STEP2",
            },
        },
        lines = (function()
            local generated = {};
            for i = 1, 74 do
                generated[i] = "RM_CPE_VHS_LINE" .. i;
            end
            return generated;
        end)(),
    },
};

local TapeById = {};
for _, tape in ipairs(Tapes) do
    TapeById[tape.id] = tape;
end

local function buildRequiredLineSet(spec)
    local set = {};
    if not spec then
        return set;
    end
    for _, entry in ipairs(spec) do
        if type(entry) == "table" then
            for i = entry[1], entry[2] do
                set[i] = true;
            end
        else
            set[entry] = true;
        end
    end
    return set;
end

for _, tape in ipairs(Tapes) do
    if tape.recipeSteps then
        for _, step in ipairs(tape.recipeSteps) do
            step.requiredSet = buildRequiredLineSet(step.requiredLines);
        end
    end
end

local NamedLineColors = {
    GRAY = { 0.55, 0.55, 0.55 },
};

local function extractLineColor(text, defaultR, defaultG, defaultB)
    local tag, rest = string.match(text, "^%[([%w%.,:]+)%](.*)$");
    if not tag then
        return defaultR, defaultG, defaultB, text;
    end

    local r, g, b = string.match(tag, "^RGB:([%d%.]+),([%d%.]+),([%d%.]+)$");
    if r then
        return tonumber(r), tonumber(g), tonumber(b), rest;
    end

    local named = NamedLineColors[tag];
    if named then
        return named[1], named[2], named[3], rest;
    end

    return defaultR, defaultG, defaultB, text;
end

local function registerTapes(recordedMedia)
    for _, tape in ipairs(Tapes) do
        local data = recordedMedia:register("Retail-VHS", tape.id, tape.name, 2);
        data:setTitle(tape.name);
        data:setSubtitle("RM_CPE_SUBTITLE");
        data:setAuthor("RM_CPE_AUTHOR");
        data:setExtra("RM_CPE_EXTRA_V" .. tostring(tape.volume));

        for lineNumber, lineKey in ipairs(tape.lines) do
            local codes = "RMB-1";

            if tape.recipeSteps then
                for stepIndex, step in ipairs(tape.recipeSteps) do
                    if step.requiredSet[lineNumber] then
                        codes = codes .. ",RMR=" .. tape.id .. ":" .. tostring(stepIndex) .. ":" .. tostring(lineNumber);
                    end
                end
            end

            if lineNumber == #tape.lines and tape.perk then
                codes = codes .. ",RMP=" .. tape.id;
            end

            local r, g, b = 0.00, 0.69, 0.94;
            if tape.volume == 2 then
                r, g, b = 1.00, 0.75, 0.00;
            end

            local resolvedText = getText(lineKey);
            local finalR, finalG, finalB, displayText = extractLineColor(resolvedText, r, g, b);

            data:addLine(displayText, finalR, finalG, finalB, codes);
        end
    end
end

local function playerCanHear(player, x, y, z)
    if not player or player:isDead() or player:isAsleep() then
        return false;
    end
    if x == -1 and y == -1 and z == -1 then
        return true;
    end
    if math.floor(player:getZ()) ~= math.floor(z) then
        return false;
    end
    if player:getX() < x - 5 or player:getX() > x + 5 or player:getY() < y - 5 or player:getY() > y + 5 then
        return false;
    end

    local source = getCell():getGridSquare(x, y, z);
    local playerSquare = player:getSquare();
    if source and playerSquare and source:isOutside() ~= playerSquare:isOutside() then
        return false;
    end
    return true;
end

local function applyTapeLine(player, codes)
    local modData = player:getModData()[MOD_DATA_KEY];
    if type(modData) ~= "table" then
        modData = { perksWatched = {}, recipeProgress = {} };
        player:getModData()[MOD_DATA_KEY] = modData;
    end

    local changed = false;

    if string.find(codes, "RMB-1", 1, true) then
        local stats = player:getStats();
        if stats then
            stats:add(CharacterStat.BOREDOM, BOREDOM_PER_LINE);
        end
    end

    local rmpTapeId = string.match(codes, "RMP=([%w_%-]+)");
    if rmpTapeId then
        local tape = TapeById[rmpTapeId];
        if tape and tape.perk then
            local watchedKey = tape.perk.id .. ":V" .. tostring(tape.volume);
            if not modData.perksWatched[watchedKey] then
                modData.perksWatched[watchedKey] = true;
                changed = true;

                local perk = Perks.FromString(tape.perk.id);
                if perk and perk ~= Perks.None then
                    player:getXp():AddXP(perk, tape.perk.xp);
                end
            end
        end
    end

    for tapeId, stepIndexStr, lineStr in string.gmatch(codes, "RMR=([%w_%-]+):(%d+):(%d+)") do
        local tape = TapeById[tapeId];
        if tape and tape.recipeSteps then
            local step = tape.recipeSteps[tonumber(stepIndexStr)];
            if step and step.recipes and #step.recipes > 0 then
                local progress = modData.recipeProgress[tapeId];
                if type(progress) ~= "table" then
                    progress = {};
                    modData.recipeProgress[tapeId] = progress;
                end

                local stepProgress = progress[stepIndexStr];
                if type(stepProgress) ~= "table" then
                    stepProgress = { seen = {}, learned = false };
                    progress[stepIndexStr] = stepProgress;
                end

                if not stepProgress.learned then
                    local lineIndex = tonumber(lineStr);
                    if not stepProgress.seen[lineIndex] then
                        stepProgress.seen[lineIndex] = true;
                        changed = true;
                    end

                    local allRequiredLinesSeen = true;
                    for requiredIndex in pairs(step.requiredSet) do
                        if not stepProgress.seen[requiredIndex] then
                            allRequiredLinesSeen = false;
                            break
                        end
                    end

                    if allRequiredLinesSeen then
                        local knownRecipes = player:getKnownRecipes();
                        for _, recipeName in ipairs(step.recipes) do
                            if not knownRecipes:contains(recipeName) then
                                knownRecipes:add(recipeName);
                            end
                        end
                        stepProgress.learned = true;
                        changed = true;

                        if step.learnedText then
                            HaloTextHelper.addTextWithArrow(player, getText(step.learnedText), true, HaloTextHelper.getColorGreen());
                        end
                    end
                end
            end
        end
    end

    if changed and isServer() then
        player:transmitModData();
    end
end

local function onDeviceText(guid, codes, x, y, z, line)
    if isClient() or not codes then
        return;
    end
    if not string.find(codes, "RMB-1", 1, true)
        and not string.find(codes, "RMP=", 1, true)
        and not string.find(codes, "RMR=", 1, true) then
        return;
    end

    if isServer() then
        local players = getOnlinePlayers();
        for index = 0, players:size() - 1 do
            local player = players:get(index);
            if playerCanHear(player, x, y, z) then
                applyTapeLine(player, codes);
            end
        end
    else
        for playerNumber = 0, 3 do
            local player = getSpecificPlayer(playerNumber);
            if playerCanHear(player, x, y, z) then
                applyTapeLine(player, codes);
            end
        end
    end
end

if (isDebugEnabled()) then

CPE_DEBUG = CPE_DEBUG or {};

function CPE_DEBUG.addStarterTape(player, tapeId)
    player = player or getSpecificPlayer(0);
    local tape = tapeId and TapeById[tapeId] or Tapes[1];
    if not tape then
        return;
    end

    local recordedMedia = getZomboidRadio() and getZomboidRadio():getRecordedMedia();
    local mediaData = recordedMedia and recordedMedia:getMediaData(tape.id);
    if not mediaData then
        return;
    end

    local container = player:getInventory();
    local item = container:AddItem("Base.VHS_Retail");
    if not item then
        return;
    end
    item:setRecordedMediaData(mediaData);

    if isServer() then
        player:transmitModData();
    end
end

end

if isServer() then
    local function onEveryOneMinute()
        if SandboxVars.CraftablePaintEdition.RequireRecipesToBeLearned then
            return;
        end
        local players = getOnlinePlayers();
        for i = 0, players:size() - 1 do
            local p = players:get(i);
            local knownRecipes = p:getKnownRecipes();
            for _, tape in ipairs(Tapes) do
                for _, step in ipairs(tape.recipeSteps) do
                    for _, recipeName in ipairs(step.recipes) do
                        if not knownRecipes:contains(recipeName) then
                            knownRecipes:add(recipeName);
                        end
                    end
                end
            end
        end
    end
    Events.EveryOneMinute.Add(onEveryOneMinute);
else
    local function onGameStart()
        if SandboxVars.CraftablePaintEdition.RequireRecipesToBeLearned then
            return;
        end
        for playerNumber = 0, 3 do
            local p = getSpecificPlayer(playerNumber);
            if p then
                local knownRecipes = p:getKnownRecipes();
                for _, tape in ipairs(Tapes) do
                    for _, step in ipairs(tape.recipeSteps) do
                        for _, recipeName in ipairs(step.recipes) do
                            if not knownRecipes:contains(recipeName) then
                                knownRecipes:add(recipeName);
                            end
                        end
                    end
                end
            end
        end
    end

    Events.OnGameStart.Add(onGameStart);
end
Events.OnInitRecordedMedia.Add(registerTapes);
Events.OnDeviceText.Add(onDeviceText);