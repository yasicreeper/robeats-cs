local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local State = require(game.ReplicatedStorage.State)
local Actions = require(game.ReplicatedStorage.Actions)

local SettingsController = Knit.CreateController { Name = "SettingsController" }

function SettingsController:KnitStart()
    local SettingsService = Knit.GetService("SettingsService")

    local settings = SettingsService:GetSettings()

    if settings then
        for i, v in pairs(settings) do
            State.Store:dispatch(Actions.setPersistentOption(i, v))
        end 
    end
end

return SettingsController