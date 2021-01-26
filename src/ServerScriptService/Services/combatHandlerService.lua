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
    
end



function combatHandlerService:KnitInit()
    self.Client.handleMove:Connect(function(Player, Action, Bool)

    local class = players[Player]
    if class then
    else 
        players[Player] = combatClass.new(Player) 
        class = players[Player]
    end
    
   --print(class)
    class:action(Action,Bool,self,combatRay)
    end)

end


return combatHandlerService