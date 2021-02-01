local Knit = require(game:GetService("ReplicatedStorage").Knit)

local dataService = Knit.CreateService {
    Name = "dataService";
    Client = {};
}

local dataMod = require(Knit.modules.userData)

function dataService:KnitStart()
    
end


function dataService:KnitInit()
    
end


return dataService