local Knit = require(game:GetService("ReplicatedStorage").Knit)

local Players = game:GetService("Players")
local playerAddedService = Knit.CreateService {
    Name = "playerAddedService";
    Client = {};
}



function playerAddedService:KnitStart()
    Players.PlayerAdded:Connect(function(plr)

        local combatFolder = Instance.new("Folder")
        combatFolder.Name = "FX"
        combatFolder.Parent = plr


        plr.CharacterAdded:Connect(function(char)
            while char.Parent == nil do
                char.AncestryChanged:Wait()
            end
            
            Knit.Services.combatHandlerService:setupPlayer(plr)
        end)

        plr.CharacterRemoving:Connect(function()
            Knit.Services.combatHandlerService.removal(plr)
        
        end)
    end)
end


function playerAddedService:KnitInit()


end


return playerAddedService