CPETemporaryBlindnessServer = {};
CPETemporaryBlindnessServer.__index = CPETemporaryBlindnessServer;

local instances = {};

function CPETemporaryBlindnessServer.getInstanceForPlayer(player, playerNum)
    player = player or getSpecificPlayer(playerNum or 0);
    playerNum = playerNum or player:getPlayerNum();
	if not instances[playerNum] then
		instances[playerNum] = CPETemporaryBlindnessServer.new(player, playerNum);
	end
	return instances[playerNum];
end

function CPETemporaryBlindnessServer.new(player, playerNum)
	local o = {};
	setmetatable(o, CPETemporaryBlindnessServer);
	o:init(player, playerNum);
	return o;
end

function CPETemporaryBlindnessServer:init(player, playerNum)
	self.player = player;
	self.playerNum = playerNum;
    
	self.isActive = false;
	self.duration = 0;
	self.timeElapsed = 0;
	self.radius = 0;
	self.healRate = 1;

	self.isIlliterate = player:hasTrait(CharacterTrait.ILLITERATE);

    if(self.player:hasTrait(CharacterTrait.FAST_HEALER)) then
        self.healRate = 2;
    elseif(self.player:hasTrait(CharacterTrait.SLOW_HEALER)) then
        self.healRate = 0.5;
    end
end

function CPETemporaryBlindnessServer:activate(duration, radius)
	self.isActive = true;
	self.duration = duration;
    self.radius = radius;
    self.timeElapsed = 0;

    if(not self.isIlliterate and not self.player:hasTrait(CharacterTrait.ILLITERATE)) then
        self.player:getCharacterTraits():add(CharacterTrait.ILLITERATE);
    end

    print("SERVER: sendServerCommand:activate");
    print("        duration: " .. self.duration);
    print("        radius: " .. self.radius);
    print("        playerNum: " .. self.playerNum);
    sendServerCommand("CPETemporaryBlindness", "activate", {
        duration    = self.duration,
        radius      = self.radius,
        playerNum   = self.playerNum
    });

end

function CPETemporaryBlindnessServer:deactivate()
	self.isActive = false;
	self.duration = 0;
    
    if(not self.isIlliterate) then
        self.player:getCharacterTraits():remove(CharacterTrait.ILLITERATE);
    end
    print("SERVER: sendServerCommand:deactivate");
    sendServerCommand("CPETemporaryBlindness", "deactivate");
end

function CPETemporaryBlindnessServer:update()
    
    self.timeElapsed = self.timeElapsed + self.healRate;

    --PZMath.lerp

    if(self.timeElapsed >= self.duration) then
        self:deactivate();
    end
end

function CPETemporaryBlindnessServer:isBlind()
	return self.isActive;
end

function CPETemporaryBlindnessServer:canReadMap()
	return not self:isBlind();
end

local function onEveryOneMinute()

    for _, instance in pairs(instances) do
        if(instance.isActive) then
            instance:update();
        end
    end

end

local function onEveryTenMinutes()
    for _, instance in pairs(instances) do
        if(instance.isActive) then
            print("SERVER: sendServerCommand:update");
            print("        duration: " .. instance.duration);
            print("        timeElapsed: " .. instance.timeElapsed);
            print("        radius: " .. instance.radius);
            sendServerCommand("CPETemporaryBlindness", "update", {
                duration = instance.duration,
                timeElapsed = instance.timeElapsed,
                radius = instance.radius
            });
        end
    end 
end


local function onCreatePlayer(playerNum, player)
    CPETemporaryBlindnessServer.getInstanceForPlayer(player, playerNum);
end

Events.EveryOneMinute.Add(onEveryOneMinute)
Events.EveryTenMinutes.Add(onEveryTenMinutes)
Events.OnCreatePlayer.Add(onCreatePlayer)