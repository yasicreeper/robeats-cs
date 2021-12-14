local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local StateController = Knit.CreateController { Name = "StateController" }

local Actions = require(game.ReplicatedStorage.Actions)
local State = require(game.ReplicatedStorage.State)

local PermissionsService

function StateController:KnitStart()
    PermissionsService = Knit.GetService("PermissionsService")

    State.Store:dispatch(Actions.setAdmin(PermissionsService:HasModPermissions()))
end

return StateController
