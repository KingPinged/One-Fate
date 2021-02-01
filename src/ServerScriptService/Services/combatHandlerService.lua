local Knit = require(game:GetService("ReplicatedStorage").Knit)

local combatHandlerService = Knit.CreateService {
    Name = "combatHandlerService";
    Client = {};
}
local RemoteSignal = require(Knit.Util.Remote.RemoteSignal)
combatHandlerService.Client.handleMove = RemoteSignal.new()
combatHandlerService.Client.screenR = RemoteSignal.new()

local combatRay = require(Knit.RepMods.RaycastHit.RaycastHitbox)

local combatClass=  require(Knit.classes.combatPlayer)

local players = {}
function combatHandlerService:KnitStart()
    self.Client.handleMove:Connect(function(Player, Action, Bool)

        local class = players[Player]

        if class then
            class:action(Action,Bool)
        end

        if not class then

            
           -- players[Player] = combatClass.new(Player,combatRay,self.Client.screenR) 
           -- class = players[Player]
        end
        
       -- class:action(Action,Bool)
        end)

end

function combatHandlerService.removal(Player)
    local class = players[Player]
    if class then
        players[Player] = nil
    end
end

function combatHandlerService:setupPlayer(Player)

    local punchHitBox = game.ServerStorage.Storage.combat:WaitForChild("PunchHitbox"):Clone()
	punchHitBox.Parent = Player.Character


    players[Player] = combatClass.new(Player,combatRay,self.Client.screenR) 
    
end





function combatHandlerService:KnitInit()

end


return combatHandlerService