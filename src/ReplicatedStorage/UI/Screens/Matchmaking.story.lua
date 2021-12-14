local Roact = require(game.ReplicatedStorage.Packages.Roact)

local Matchmaking = require(script.Parent.Matchmaking)

return function(target)
    local app = Roact.createElement(Matchmaking)

    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end