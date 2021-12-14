game.Players.CharacterAutoLoads = false
game.Lighting.ClockTime = 0

local sky = Instance.new("Sky")

sky.CelestialBodiesShown = false
sky.Parent = game.Lighting

local Knit = require(game.ReplicatedStorage.Packages.Knit)

Knit.AddServices(game.ServerScriptService.Services)

Knit.Start():andThen(function()
    print("Knit successfully started(server)")
end):catch(function(err)
    warn(err)
end)
