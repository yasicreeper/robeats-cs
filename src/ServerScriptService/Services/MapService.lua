local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local InsertService = game:GetService("InsertService")

local MapService = Knit.CreateService {
    Name = "MapService";
    Client = {};
}

function MapService:KnitStart()
    local existing_maps = workspace:FindFirstChild("Songs")
    
    if not existing_maps then
        local maps = InsertService:LoadAsset(6485121344)
        local song_maps = maps.Songs
        song_maps.Name = "Songs"
        song_maps.Parent = workspace
    
        maps:Destroy()
    end
end

return MapService