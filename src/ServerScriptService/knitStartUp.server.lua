local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Knit = require(ReplicatedStorage:FindFirstChild("Knit",true))

local serverMod = ServerScriptService.Modules
Knit.Shared = ReplicatedStorage.Shared
Knit.Powers = ReplicatedStorage.Shared.PowerModules.Powers
Knit.Abilities = ReplicatedStorage.Shared.PowerModules.Abilities
Knit.Effects = ReplicatedStorage.Shared.PowerModules.Effects
--Knit.ItemSpawnTables = ServerScriptService.Services.ItemSpawnService
Knit.StateModules = ReplicatedStorage.Shared.StateModules
--Knit.InventoryModules = serverMod.InventoryModules
Knit.MobMod = serverMod.mobData

-- Load all services:
Knit.AddServices(script.Parent.Services)

Knit.Start()
print("Knit SERVER - Runtime Started")