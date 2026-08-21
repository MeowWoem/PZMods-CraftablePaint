CPETemporaryBlindnessServer = {};
CPETemporaryBlindnessServer.__index = CPETemporaryBlindnessServer;

local instances = {};

CPETemporaryBlindnessServer.radiusInitValue = {
    min = 0.2,
    max = 1.25,
};

function CPETemporaryBlindnessServer.getInstanceForPlayer(player, playerNum, playerOnlineID)

    local instanceID = playerNum;

    if(isMultiplayer()) then
        if(playerOnlineID == nil) then return; end
        instanceID = playerOnlineID;
        player = player or getPlayerByOnlineID(playerOnlineID);
    else
        player = player or getSpecificPlayer(playerNum or 0);
        playerNum = playerNum or player:getPlayerNum();
    end

	if not instances[instanceID] or instances[instanceID].player ~= player then
		instances[instanceID] = CPETemporaryBlindnessServer.new(player, playerNum, playerOnlineID);
	end
	return instances[instanceID];
end

function CPETemporaryBlindnessServer.new(player, playerNum, playerOnlineID)
	local o = {};
	setmetatable(o, CPETemporaryBlindnessServer);
	o:init(player, playerNum, playerOnlineID);
	return o;
end

function CPETemporaryBlindnessServer:init(player, playerNum, playerOnlineID)
	self.player = player;
	self.playerNum = playerNum;
	self.playerOnlineID = playerOnlineID;
    
    local md = self.player:getModData();
    md.CPETemporaryBlindness = md.CPETemporaryBlindness or {
        isActive = false,
        duration = 0,
        timeElapsed = 0,
        radius = 0,
        isIlliterate = player:hasTrait(CharacterTrait.ILLITERATE);
    };

    self.player:transmitModData();

	self.isActive = md.CPETemporaryBlindness.isActive;
	self.duration = md.CPETemporaryBlindness.duration;
	self.timeElapsed = md.CPETemporaryBlindness.timeElapsed;
	self.radius = md.CPETemporaryBlindness.radius;
	self.healRate = 1;

    if(isDebugEnabled()) then
        print("INIT");
        print(self.isActive);
        print(self.duration);
        print(self.timeElapsed);
    end

	self.isIlliterate = md.CPETemporaryBlindness.isIlliterate;

    if(self.player:hasTrait(CharacterTrait.FAST_HEALER)) then
        self.healRate = 2;
    elseif(self.player:hasTrait(CharacterTrait.SLOW_HEALER)) then
        self.healRate = 0.5;
    end

    self.clientInstance = nil;
    if(isMultiplayer()) then
        if(isDebugEnabled()) then
            print("SERVER: sendServerCommand:init");
            print("        isActive: " .. tostring(self.isActive));
            print("        duration: " .. self.duration);
            print("        timeElapsed: " .. self.timeElapsed);
            print("        radius: " .. self.radius);
            print("        playerNum: " .. self.playerNum);
            print("        playerOnlineID: " .. self.playerOnlineID);
        end
        sendServerCommand("CPETemporaryBlindness", "init", {
            isActive = self.isActive,
            duration = self.duration,
            timeElapsed = self.timeElapsed,
            radius = self.radius,
            playerNum   = self.playerNum,
            playerOnlineID   = self.playerOnlineID
        });
    else
        self.clientInstance = CPETemporaryBlindnessClient.getInstanceForPlayer(self.player, self.playerNum);
    end
end

function CPETemporaryBlindnessServer:activate(duration, radius)


	self.isActive = true;
	self.duration = duration;
    self.radius = radius or ZombRandFloat(CPETemporaryBlindnessServer.radiusInitValue.min, CPETemporaryBlindnessServer.radiusInitValue.max);
    self.timeElapsed = 0;

    if(not self.isIlliterate and not self.player:hasTrait(CharacterTrait.ILLITERATE)) then
        self.player:getCharacterTraits():add(CharacterTrait.ILLITERATE);
    end

    local md = self.player:getModData();
	md.CPETemporaryBlindness.isActive = self.isActive;
	md.CPETemporaryBlindness.duration = self.duration;
	md.CPETemporaryBlindness.radius = self.radius;
	md.CPETemporaryBlindness.timeElapsed = self.timeElapsed;

    self.player:transmitModData();

    if(isMultiplayer()) then
        if(isDebugEnabled()) then
            print("SERVER: sendServerCommand:activate");
            print("        duration: " .. self.duration);
            print("        radius: " .. self.radius);
            print("        playerNum: " .. self.playerNum);
            print("        playerOnlineID: " .. self.playerOnlineID);
        end
        sendServerCommand("CPETemporaryBlindness", "activate", {
            duration    = self.duration,
            radius      = self.radius,
            playerNum   = self.playerNum,
            playerOnlineID   = self.playerOnlineID
        });
    elseif(self.clientInstance) then
        self.clientInstance:activate(duration, self.radius);
    end
end

function CPETemporaryBlindnessServer:deactivate()
	self.isActive = false;
	self.duration = 0;
    self.timeElapsed = 0;
    
    if(not self.isIlliterate) then
        self.player:getCharacterTraits():remove(CharacterTrait.ILLITERATE);
    end

    local md = self.player:getModData();
	md.CPETemporaryBlindness.isActive = self.isActive;
	md.CPETemporaryBlindness.duration = self.duration;
	md.CPETemporaryBlindness.timeElapsed = self.timeElapsed;

    self.player:transmitModData();

    if(isMultiplayer()) then
        if(isDebugEnabled()) then
            print("SERVER: sendServerCommand:deactivate");
            print("        playerNum: " .. self.playerNum);
            print("        playerOnlineID: " .. self.playerOnlineID);
        end
        sendServerCommand("CPETemporaryBlindness", "deactivate", {
            playerNum   = self.playerNum,
            playerOnlineID   = self.playerOnlineID
        });
    elseif(self.clientInstance) then
        self.clientInstance:deactivate();
    end
end

function CPETemporaryBlindnessServer:update()
    
    self.timeElapsed = self.timeElapsed + self.healRate;

    local md = self.player:getModData();
	md.CPETemporaryBlindness.timeElapsed = self.timeElapsed;
    self.player:transmitModData();

    if(isDebugEnabled()) then
        print("SERVER: update");
        print("        timeElapsed: " .. self.timeElapsed);
    end
    
    if(self.timeElapsed >= self.duration or self.player:isGodMod()) then
        self:deactivate();
    elseif(isMultiplayer()) then
        if(isDebugEnabled()) then
            print("SERVER: sendServerCommand:update");
            print("        duration: " .. self.duration);
            print("        timeElapsed: " .. self.timeElapsed);
            print("        radius: " .. self.radius);
            print("        playerNum: " .. self.playerNum);
            print("        playerOnlineID: " .. self.playerOnlineID);
        end
        sendServerCommand("CPETemporaryBlindness", "update", {
            duration = self.duration,
            timeElapsed = self.timeElapsed,
            radius = self.radius,
            playerNum   = self.playerNum,
            playerOnlineID   = self.playerOnlineID
        });
    end
end

function CPETemporaryBlindnessServer:isBlind()
	return self.isActive;
end

function CPETemporaryBlindnessServer:canReadMap()
	return not self:isBlind();
end

local function onEveryOneMinute()

    if(isMultiplayer()) then
        local onlineIDs = {};
        local players = getOnlinePlayers();
        for i = 0, players:size() - 1 do
            local p = players:get(i);
            onlineIDs[p:getOnlineID()] = true;
            CPETemporaryBlindnessServer.getInstanceForPlayer(p, p:getPlayerNum(), p:getOnlineID());
        end

        for id, instance in pairs(instances) do
            if not onlineIDs[id] then
                instances[id] = nil;
            end
        end
    end

    for _, instance in pairs(instances) do
        if(instance.isActive) then
            instance:update();
        end
    end

end

local function onCharacterDeath(character)
    if not instanceof(character, "IsoPlayer") then return; end

    local instanceID = character:getPlayerNum();
    if(isMultiplayer()) then
        instanceID = character:getOnlineID();
    end

    instances[instanceID] = nil;
end
Events.EveryOneMinute.Add(onEveryOneMinute);