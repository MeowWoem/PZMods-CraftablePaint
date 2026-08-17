CPELungsIrritationServer = {};
CPELungsIrritationServer.__index = CPELungsIrritationServer;

local instances = {};

CPELungsIrritationServer.coughChance = {
    start = 60,
    ["end"] = 2
};

function CPELungsIrritationServer.getInstanceForPlayer(player, playerNum, playerOnlineID)

    local instanceID = playerNum;

    if(isMultiplayer()) then
        if(playerOnlineID == nil) then return; end
        instanceID = playerOnlineID;
        player = player or getPlayerByOnlineID(playerOnlineID);
    else
        player = player or getSpecificPlayer(playerNum or 0);
        playerNum = playerNum or player:getPlayerNum();
    end

	if not instances[instanceID] then
		instances[instanceID] = CPELungsIrritationServer.new(player, playerNum, playerOnlineID);
	end
	return instances[instanceID];
end

function CPELungsIrritationServer.new(player, playerNum, playerOnlineID)
	local o = {};
	setmetatable(o, CPELungsIrritationServer);
	o:init(player, playerNum, playerOnlineID);
	return o;
end

function CPELungsIrritationServer:init(player, playerNum, playerOnlineID)
	self.player = player;
	self.playerNum = playerNum;
	self.playerOnlineID = playerOnlineID;

    local md = self.player:getModData();
    md.CPELungsIrritation = md.CPELungsIrritation or {
        isActive = false,
        duration = 0,
        timeElapsed = 0,
    };

    self.player:transmitModData();

	self.isActive = md.CPELungsIrritation.isActive;
	self.duration = md.CPELungsIrritation.duration;
	self.timeElapsed = md.CPELungsIrritation.timeElapsed;
	self.healRate = 1;

    if(isDebugEnabled()) then
        print("CPELungsIrritation INIT");
        print(self.isActive);
        print(self.duration);
        print(self.timeElapsed);
    end

    if(self.player:hasTrait(CharacterTrait.FAST_HEALER)) then
        self.healRate = 2;
    elseif(self.player:hasTrait(CharacterTrait.SLOW_HEALER)) then
        self.healRate = 0.5;
    end
end

function CPELungsIrritationServer:activate(duration)
	self.isActive = true;
	self.duration = duration;
    self.timeElapsed = 0;

    local md = self.player:getModData();
	md.CPELungsIrritation.isActive = self.isActive;
	md.CPELungsIrritation.duration = self.duration;
	md.CPELungsIrritation.timeElapsed = self.timeElapsed;

    self.player:transmitModData();

    if(isDebugEnabled()) then
        print("CPELungsIrritation:activate");
        print("        duration: " .. self.duration);
        print("        playerNum: " .. self.playerNum);
    end
end

function CPELungsIrritationServer:deactivate()
	self.isActive = false;
	self.duration = 0;
    self.timeElapsed = 0;

    local md = self.player:getModData();
	md.CPELungsIrritation.isActive = self.isActive;
	md.CPELungsIrritation.duration = self.duration;
	md.CPELungsIrritation.timeElapsed = self.timeElapsed;

    self.player:transmitModData();

    if(isDebugEnabled()) then
        print("CPELungsIrritation:deactivate");
        print("        playerNum: " .. self.playerNum);
    end
end

function CPELungsIrritationServer:update()

    self.timeElapsed = self.timeElapsed + self.healRate;

    local healProgress = PZMath.clamp(self.timeElapsed / self.duration, 0, 1);
    local coughChance = PZMath.lerp(CPELungsIrritationServer.coughChance.start, CPELungsIrritationServer.coughChance["end"], healProgress);

    if(ZombRand(100) < coughChance) then
        if(isMultiplayer()) then
            self.player:sendObjectChange(IsoObjectChange.COUGH);
        else
            self.player:triggerCough();
        end
    end

    local md = self.player:getModData();
	md.CPELungsIrritation.timeElapsed = self.timeElapsed;
    self.player:transmitModData();

    if(isDebugEnabled()) then
        print("CPELungsIrritation:update");
        print("        timeElapsed: " .. self.timeElapsed);
        print("        coughChance: " .. coughChance);
    end

    if(self.timeElapsed >= self.duration or self.player:isGodMod()) then
        self:deactivate();
    end
end

function CPELungsIrritationServer:isIrritated()
	return self.isActive;
end

local function onEveryOneMinute()

    if(isMultiplayer()) then
        local onlineIDs = {};
        local players = getOnlinePlayers();
        for i = 0, players:size() - 1 do
            local p = players:get(i);
            onlineIDs[p:getOnlineID()] = true;
            CPELungsIrritationServer.getInstanceForPlayer(p, p:getPlayerNum(), p:getOnlineID());
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

Events.EveryOneMinute.Add(onEveryOneMinute);
