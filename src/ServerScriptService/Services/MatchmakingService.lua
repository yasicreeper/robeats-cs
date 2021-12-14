local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local MatchmakingService = Knit.CreateService {
    Name = "MatchmakingService";
    Client = {};
}

function MatchmakingService:KnitInit()

end

return MatchmakingService