local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local DataStoreService = require(game.ReplicatedStorage.Packages.DataStoreService)
local SettingsDatastore = DataStoreService:GetDataStore("SettingsStore")

local DatastoreSerialization = require(game.ReplicatedStorage.Serialization.Datastore)

local SettingsService = Knit.CreateService {
    Name = "SettingsService";
    Client = {};
}

function SettingsService.Client:GetSettings(player)
    local settings = SettingsDatastore:GetAsync(player.UserId)
    if settings then
        return DatastoreSerialization:deserialize_table(settings)
    end
    return {}
end

function SettingsService.Client:SetSettings(player, settings)
    SettingsDatastore:SetAsync(player.UserId, DatastoreSerialization:serialize_table(settings))
end

return SettingsService