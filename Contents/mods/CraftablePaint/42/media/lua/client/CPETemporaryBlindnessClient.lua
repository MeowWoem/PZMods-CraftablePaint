CPETemporaryBlindnessClient = {};
CPETemporaryBlindnessClient.__index = CPETemporaryBlindnessClient;

local instances = {};

function CPETemporaryBlindnessClient.getInstanceForPlayer(player, playerNum)
    player = player or getSpecificPlayer(playerNum or 0);
    playerNum = playerNum or player:getPlayerNum();

    if(not player) then return false; end

	if not instances[playerNum] or instances[playerNum].player ~= player then
		instances[playerNum] = CPETemporaryBlindnessClient.new(player, playerNum);
	end
	return instances[playerNum];
end

function CPETemporaryBlindnessClient.new(player, playerNum)
	local o = {};
	setmetatable(o, CPETemporaryBlindnessClient);
	o:init(player, playerNum);
	return o;
end

function CPETemporaryBlindnessClient:init(player, playerNum)
	self.player = player;
	self.playerNum = playerNum;
    
    local md = self.player:getModData();
    md.CPETemporaryBlindness = md.CPETemporaryBlindness or {
        isActive = false,
        duration = 0,
        timeElapsed = 0,
        radius = 0,
        isIlliterate = player:hasTrait(CharacterTrait.ILLITERATE);
    };
	
	self.isActive = md.CPETemporaryBlindness.isActive or false;
	self.duration = md.CPETemporaryBlindness.duration or 0;
	self.timeElapsed = md.CPETemporaryBlindness.timeElapsed or 0;
	self.radius = md.CPETemporaryBlindness.radius or 0;
	self.healRate = 1;
    self.tempBlindnessInitValues = {
        blur = 1,
        desat = 10,
        radius = {
            min = 0.2,
            max = 1.25,
        },
        darkness = 1,
        gw = 4
    };
    self.radius = 0;

    self.sm = getSearchMode():getSearchModeForPlayer(playerNum);

    if(self.player:hasTrait(CharacterTrait.FAST_HEALER)) then
        self.healRate = 2;
    elseif(self.player:hasTrait(CharacterTrait.SLOW_HEALER)) then
        self.healRate = 0.5;
    end

end

function CPETemporaryBlindnessClient:activate(duration, radius)
	self.isActive = true;
	self.duration = duration;
    self.timeElapsed = 0;

    self.radius = radius or ZombRandFloat(self.tempBlindnessInitValues.radius.min, self.tempBlindnessInitValues.radius.max);
    self.sm:getBlur():setTargets(self.tempBlindnessInitValues.blur, self.tempBlindnessInitValues.blur);
    self.sm:getDesat():setTargets(self.tempBlindnessInitValues.desat, self.tempBlindnessInitValues.desat);
    self.sm:getRadius():setTargets(self.radius, self.radius);
    self.sm:getDarkness():setTargets(self.tempBlindnessInitValues.darkness, self.tempBlindnessInitValues.darkness);
    self.sm:getGradientWidth():setTargets(self.tempBlindnessInitValues.gw, self.tempBlindnessInitValues.gw);
    getSearchMode():setEnabled(self.playerNum, true);
    --getSearchMode():setOverride(self.playerNum, true);
end

function CPETemporaryBlindnessClient:deactivate()
	self.isActive = false;
	self.duration = 0;
    self.timeElapsed = 0;
    getSearchMode():setEnabled(self.playerNum, false);
    --getSearchMode():setOverride(self.playerNum, false);
end

function CPETemporaryBlindnessClient:update()   

    self.timeElapsed = self.timeElapsed + self.healRate;
    
    if(self.player:isGodMod()) then
        self:deactivate();
    end
end

function CPETemporaryBlindnessClient:isBlind()
	return self.isActive;
end

function CPETemporaryBlindnessClient:canReadMap()
	return not self:isBlind();
end


local function onCreatePlayer(playerNum, player)
    CPETemporaryBlindnessClient.getInstanceForPlayer(player, playerNum);
    if(not isMultiplayer()) then
        CPETemporaryBlindnessServer.getInstanceForPlayer(player, playerNum);
    end
end

local function onPlayerUpdate(player)
    local instance = CPETemporaryBlindnessClient.getInstanceForPlayer(player);
    if(instance.isActive) then
        local radius = PZMath.lerp(instance.radius, 25, instance.timeElapsed / instance.duration);
        instance.sm:getRadius():setTargets(radius, radius);
        instance.sm:getBlur():setTargets(instance.tempBlindnessInitValues.blur, instance.tempBlindnessInitValues.blur);
        instance.sm:getDesat():setTargets(instance.tempBlindnessInitValues.desat, instance.tempBlindnessInitValues.desat);
        instance.sm:getDarkness():setTargets(instance.tempBlindnessInitValues.darkness, instance.tempBlindnessInitValues.darkness);
        instance.sm:getGradientWidth():setTargets(instance.tempBlindnessInitValues.gw, instance.tempBlindnessInitValues.gw);
        getSearchMode():setEnabled(instance.playerNum, true);
    end
end

local function onEveryOneMinute()
    for _, instance in pairs(instances) do
        if(instance.isActive) then
            instance:update();
        end
    end 
end

local function onServerCommand(module, command, args)
    if(isDebugEnabled()) then
        print("CLIENT: onServerCommand: " .. module .. ":"..command);
    end
    if(module == "CPETemporaryBlindness") then
        if(isDebugEnabled()) then
            print("        playerNum: " .. args.playerNum);
            print("        playerOnlineID: " .. args.playerOnlineID);
        end

 
        local player = getPlayerByOnlineID(args.playerOnlineID);
        if(not player or not player:isLocalPlayer()) then return; end
        local playerNum = player:getPlayerNum();
       

        local instance = CPETemporaryBlindnessClient.getInstanceForPlayer(nil, playerNum);

		if(command == "activate") then

            instance:activate(args.duration, args.radius);

        elseif(command == "init") then

            instance.isActive = args.isActive;
            instance.duration = args.duration;
            instance.timeElapsed = args.timeElapsed;
            instance.radius = args.radius;

        elseif(command == "deactivate") then

            instance:deactivate();


        elseif(command == "update") then
            if(isDebugEnabled()) then
                print("        duration: " .. args.duration);
                print("        timeElapsed: " .. args.timeElapsed);
                print("        radius: " .. args.radius);
            end
            instance.duration = args.duration;
            instance.timeElapsed = args.timeElapsed;
            instance.radius = args.radius;

        end
    end
end
local function onCharacterDeath(character)
    if not instanceof(character, "IsoPlayer") then return; end

    instances[character:getPlayerNum()] = nil;
end

Events.OnCharacterDeath.Add(onCharacterDeath);
Events.OnCreatePlayer.Add(onCreatePlayer);
Events.OnPlayerUpdate.Add(onPlayerUpdate);
Events.EveryOneMinute.Add(onEveryOneMinute);
Events.OnServerCommand.Add(onServerCommand);