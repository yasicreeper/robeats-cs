local Roact = require(game.ReplicatedStorage.Packages.Roact)
local UserButton = require(game.ReplicatedStorage.UI.Screens.Moderation.Users.UserButton)

return function(target)
    local app = Roact.createElement(UserButton, {
        UserId = 59777518
    })
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end