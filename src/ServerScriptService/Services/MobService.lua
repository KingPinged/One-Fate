-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local PhysicsService = game:GetService("PhysicsService")

-- setup Knit
local Knit = require(ReplicatedStorage:FindFirstChild("Knit"))
local MobService = Knit.CreateService { Name = "MobService", Client = {}}
--local RemoteEvent = require(Knit.Util.Remote.RemoteEvent)

--modules
local Config = require(Knit.MobMod.config);
local Mob = require(Knit.MobMod.Mob);
local MobData = require(Knit.MobMod.MobData);
local SpawnerCache = {};
local MobCache = {};

--functions
local function IsAlive(Model)
	if Model and Model.PrimaryPart 
		and Model:FindFirstChild"Humanoid"
		and Model.Humanoid.Health > 0 then
		return true
	end
	return false
end

local function GetClosestTarget(Position, Range)
	local Closest
	local PlayerList = Players:GetPlayers();
	for i = 1, #PlayerList do
		local Player = PlayerList[i];
		local Character = Player.Character
		if IsAlive(Character) then
			local Distance = (Character.PrimaryPart.Position - Position).Magnitude
			if not Closest then
				Closest = {Character, Distance}
			elseif Distance < Closest[2] then
				Closest = {Character, Distance}
			end
		end
	end

	if Closest then
		return Closest[1], Closest[2];
	end
end

local function SetCollisionGroup(Model, Group)
	if Model:IsA("BasePart") then
		PhysicsService:SetPartCollisionGroup(Model, Group);
	else
		local ModelDescendants = Model:GetDescendants()
		for i = 1, #ModelDescendants do
			local Model = ModelDescendants[i];
			if Model:IsA("BasePart") then
				PhysicsService:SetPartCollisionGroup(Model, Group);
			end
		end
	end
end

local function PlayerInRange(Point, Range)
	local PlayerList = Players:GetPlayers();
	for i = 1, #PlayerList do
		local Player = PlayerList[i];
		local Character = Player.Character
		if IsAlive(Character) then
			local Distance = (Point - Character.PrimaryPart.Position).Magnitude
			if Distance <= Range then
				return true
			end
		end
	end
	return false;
end

local function GetMoveToPoint(Pos1, Pos2, Range)
	local Difference = Pos1 - Pos2
	local Direction = Difference.Unit;
	return Pos2 + Direction * Range
end

local function Cast(Orgin, Goal, Data, FilterType, IgnoreWater)
	local StartPosition = Orgin
	local EndPosition = Goal
	local Difference = EndPosition - StartPosition
	local Direction = Difference.Unit
	local Distance = Difference.Magnitude

	local RayData = RaycastParams.new()
	RayData.FilterDescendantsInstances = Data or {}
	RayData.FilterType = FilterType or Enum.RaycastFilterType.Blacklist
	RayData.IgnoreWater = IgnoreWater or true

	return workspace:Raycast(StartPosition, Direction * Distance, RayData)
end

-- modules
--local utils = require(Knit.Shared.Utils)

-- events
--MobService.Client.Event_Update_ArrowPanel = RemoteEvent.new()

--// PlayerAdded
function MobService:PlayerAdded(player)

end


--// KnitStart
function MobService:KnitStart()

    PhysicsService:CreateCollisionGroup("Mystifine")
PhysicsService:CollisionGroupSetCollidable("Mystifine", "Mystifine", false)

if not Config.Hiearchy then warn(script.Name, "Hiearchy/Folder for spawners has not been set.") return end;
local Spawners = Config.Hiearchy:GetChildren();
for i = 1, #Spawners do
	local Folder = Spawners[i];
	local Identification = Folder.Name;
	SpawnerCache[Folder] = {};
	MobCache[Folder] = {};
	local Children = Folder:GetChildren();
	for i = 1, #Children do
		local Spawner = Children[i];
		SpawnerCache[Folder][Spawner] = 0;
		MobCache[Folder][Spawner] = {};
		for i = 1, MobData[Identification].SpecifiedQuantity[Spawner] or MobData[Identification].Quantity do
			local RandomVector = (Spawner.CFrame * CFrame.new(math.random(-Spawner.Size.X/2,Spawner.Size.X/2),0,math.random(-Spawner.Size.Z/2,Spawner.Size.Z/2))).Position;
			local Result = Cast(RandomVector, RandomVector - Vector3.new(0,1000,0), {Config.Hiearchy, Config.SpawnHiearchy}, Enum.RaycastFilterType.Blacklist);

			if Result then
				local NPC = Mob.new(Identification, CFrame.new(Result.Position) * CFrame.fromEulerAnglesXYZ(0,math.random(-360,360),0));
				MobCache[Folder][Spawner][NPC.Id] = NPC;
			end
		end
	end
end


if Config.PlayerCollide == false then
	Players.PlayerAdded:Connect(function(Player)
		local Character = Player.Character or Player.CharacterAdded:Wait()
		SetCollisionGroup(Character, "Mystifine");
		Player.CharacterAdded:Connect(function(Character)
			SetCollisionGroup(Character, "Mystifine");
		end)
	end)
end

while true do
	for Category, Spawners in next, MobCache do
		for Spawner, NPCS in next, Spawners do
			local InRange = PlayerInRange(Spawner.Position, MobData[Category.Name].SpecifiedHideRange[Spawner] or MobData[Category.Name].NPCHideRange)
			for _, Mob in next, NPCS do
				if not InRange and IsAlive(Mob.Model) then	
					print("reparenting")				--| Reparent to ReplicatedStorage;
					Mob.Model.Parent = game.ReplicatedStorage;
				elseif InRange and IsAlive(Mob.Model) then
					Mob.Model.Parent = Config.SpawnHiearchy or game.Workspace;

					if os.clock() - Mob.LastUpdate >= 0.25 and (MobData[Mob.Name].Agressive or Mob.Model.Humanoid.Health < Mob.Model.Humanoid.MaxHealth) then
						--| Calculate against players
						Mob.LastUpdate = os.clock();

						local Target, Distance = GetClosestTarget(Mob.Model.PrimaryPart.Position, MobData[Mob.Name].SeekRange);
						if Target then
							--| Chase Target
							local CanAttack = os.clock() - Mob.LastAttack >= MobData[Mob.Name].AttackSpeed 
							local InAttackRange = math.floor(Distance - 0.5) <= MobData[Mob.Name].AttackRange 
							if InAttackRange and CanAttack then
								Mob.Model.PrimaryPart.Rotater.CFrame = CFrame.new(Mob.Model.PrimaryPart.Position, Target.PrimaryPart.Position);
								Mob.Model.PrimaryPart.Rotater.MaxTorque = Vector3.new(0,1,1) * 50000;
								Mob.Animations.Walk:Stop(); 

								--> Attack;
								if MobData[Mob.Name].Attack then
									MobData[Mob.Name].Attack(Mob, Target);
								else
									--| Default Attack
									Target.Humanoid:TakeDamage(MobData[Mob.Name].Damage);
									if MobData[Mob.Name].AttackSequence == "RNG" then
										local RandomAnimation = Mob.Animations.Attack[math.random(1, #Mob.Animations.Attack)];
										RandomAnimation:Play();
									elseif MobData[Mob.Name].AttackSequence == "LIST" then
										Mob.LastAttackIndex += 1;
										if Mob.LastAttackIndex >= #Mob.Animations.Attack then
											Mob.LastAttackIndex = 1;
										end
										local Animation = Mob.Animations.Attack[Mob.LastAttackIndex]
										Animation:Play();
									end
								end
								Mob.LastAttack = os.clock();
							elseif not InAttackRange then
								--> Chase;
								if not Mob.Animations.Walk.IsPlaying then Mob.Animations.Walk:Play() end;
								Mob.Model.Humanoid:MoveTo(GetMoveToPoint(Mob.Model.PrimaryPart.Position, Target.PrimaryPart.Position, MobData[Mob.Name].AttackRange), Target.PrimaryPart);

								--> Update BodyGyro;
								Mob.Model.PrimaryPart.Rotater.CFrame = CFrame.new(Mob.Model.PrimaryPart.Position, Target.PrimaryPart.Position);
								Mob.Model.PrimaryPart.Rotater.MaxTorque = Vector3.new(0,1,1) * 50000;
							end
						else
							Mob.Model.PrimaryPart.Rotater.MaxTorque = Vector3.new(0,0,0);
						end
					end		
				end
			end
		end
	end
	wait(0.5)
end

    
end

--// KnitInit
function MobService:KnitInit()

    -- Player Added event
    Players.PlayerAdded:Connect(function(player)
        self:PlayerAdded(player)
    end)

    -- Player Added event for studio tesing, catches when a player has joined before the server fully starts
    for _, player in ipairs(Players:GetPlayers()) do
        self:PlayerAdded(player)
    end

    -- Player Removing event
    Players.PlayerRemoving:Connect(function(player)
        --self:PlayerRemoved(player)
    end)

end


return MobService