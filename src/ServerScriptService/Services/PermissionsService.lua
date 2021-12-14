local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local RunService = game:GetService("RunService")

local PermissionsService = Knit.CreateService {
    Name = "PermissionsService";
    Client = {};
}

function PermissionsService:HasModPermissions(player)
    if RunService:IsStudio() then
        return true
    end

    if game.CreatorType == Enum.CreatorType.Group then
        return player:GetRankInGroup(game.CreatorId) >= 251
    end
    return game.CreatorId == player.UserId
end

PermissionsService.Client.HasModPermissions = PermissionsService.HasModPermissions

return PermissionsService