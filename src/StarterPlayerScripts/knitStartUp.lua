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

game.ReplicatedStorage.workspace.knitReady.Value = true

print("Hey there! Welcome to the secret lab. If you find anything in red, please tell the dev team so we can improve player experience (including yours!)")
return a;