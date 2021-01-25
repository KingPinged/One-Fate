local a = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Knit = require(ReplicatedStorage:FindFirstChild("Knit"))

-- Expose Modules to Knit
Knit.Shared = ReplicatedStorage.Shared
Knit.Powers = ReplicatedStorage.Shared.PowerModules.Powers
Knit.Abilities = ReplicatedStorage.Shared.PowerModules.Abilities
Knit.Effects = ReplicatedStorage.Shared.PowerModules.Effects
Knit.GuiModules = StarterPlayer.StarterPlayerScripts.Modules.GuiModules
Knit.StateModules = ReplicatedStorage.Shared.StateModules
Knit.modules = StarterPlayer.StarterPlayerScripts.Modules

-- Load all controllers:
Knit.AddControllers(script.Parent.Controllers)

Knit.Start()

return a;