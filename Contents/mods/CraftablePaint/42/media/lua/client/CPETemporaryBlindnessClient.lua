CPETemporaryBlindnessClient = {};
CPETemporaryBlindnessClient.__index = CPETemporaryBlindnessClient;

local instances = {};

function CPETemporaryBlindnessClient.getInstanceForPlayer(player, playerNum)
    player = player or getSpecificPlayer(playerNum or 0);
    playerNum = playerNum or player:getPlayerNum();
	if not instances[playerNum] then
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
    
	self.isActive = false;
	self.duration = 0;
	self.healRate = 1;
	self.timeElapsed = 0;
    self.tempBlindnessInitValues = {
        blur = 1,
        desat = 10,
        radius = {
            min = 0.2,
            max = 1,
        },
        darkness = 1,
        gw = 4
    };

    self.sm = getSearchMode():getSearchModeForPlayer(playerNum);

end

function CPETemporaryBlindnessClient:activate(duration, radius)
	self.isActive = true;
	self.duration = duration;
    self.timeElapsed = 0;

    local radius = radius or ZombRand(self.tempBlindnessInitValues.radius.min, self.tempBlindnessInitValues.radius.max);
    self.sm:getBlur():setTargets(self.tempBlindnessInitValues.blur, self.tempBlindnessInitValues.blur);
    self.sm:getDesat():setTargets(self.tempBlindnessInitValues.desat, self.tempBlindnessInitValues.desat);
    self.sm:getRadius():setTargets(radius, radius);
    self.sm:getDarkness():setTargets(self.tempBlindnessInitValues.darkness, self.tempBlindnessInitValues.darkness);
    self.sm:getGradientWidth():setTargets(self.tempBlindnessInitValues.gw, self.tempBlindnessInitValues.gw);
    getSearchMode():setEnabled(self.playerNum, true);
    getSearchMode():setOverride(self.playerNum, true);
  
end

function CPETemporaryBlindnessClient:deactivate()
	self.isActive = false;
	self.duration = 0;
    getSearchMode():setEnabled(self.playerNum, false);
    getSearchMode():setOverride(self.playerNum, false);
end

function CPETemporaryBlindnessClient:update()
	local healRate = 1;
    

    --PZMath.lerp

    
end

function CPETemporaryBlindnessClient:isBlind()
	return self.isActive;
end

function CPETemporaryBlindnessClient:canReadMap()
	return not self:isBlind();
end

local function onEveryOneMinute()

    for _, instance in pairs(instances) do
        if(instance.isActive) then
            instance:update();
        end
    end 
end


local function onServerCommand(module, command, args)
	
    if(module == "CPETemporaryBlindness") then
        print("CLIENT: sendServerCommand:update");
        print("        playerNum: " .. args.playerNum);
        local instance = CPETemporaryBlindnessClient.getInstanceForPlayer(nil, args.playerNum);

		if(command == "activate") then

            instance:activate(args.duration, args.radius);

        elseif(command == "deactivate") then

            instance:deactivate();


        elseif(command == "update") then
            print("        duration: " .. args.duration);
            print("        timeElapsed: " .. args.timeElapsed);
            print("        radius: " .. args.radius);
            instance.duration = args.duration;
            instance.timeElapsed = args.timeElapsed;
            instance.radius = args.radius;

        end

    end
end

Events.EveryOneMinute.Add(onEveryOneMinute)
Events.OnServerCommand.Add(onServerCommand);