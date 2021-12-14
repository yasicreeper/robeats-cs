local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)
local e = Roact.createElement
local State = require(game.ReplicatedStorage.State)

local Promise = require(game.ReplicatedStorage.Packages.Promise)

local Actions = require(game.ReplicatedStorage.Actions)

local DIContext = require(game.ReplicatedStorage.Contexts.DIContext)

local Fitumi = require(game.ReplicatedStorage.Packages.Fitumi)
local a = Fitumi.a

local MainMenu = require(script.Parent.MainMenu)

return function(target)
    State.Store:dispatch(Actions.setAdmin(true))

    local storeProvider = Roact.createElement(RoactRodux.StoreProvider, {
        store = State.Store
    }, {
        App = Roact.createElement(MainMenu)
    })

    local fakePreviewController = a.fake()
    local fakeScoreService = a.fake()

    a.callTo(fakePreviewController.GetSoundInstance, fakePreviewController)
        :returns(Instance.new("Sound"))

    a.callTo(fakeScoreService.GetProfilePromise, fakeScoreService)
        :returns(Promise.Resolve({Rank = 13}))

    local app = Roact.createElement(DIContext.Provider, {
        value = {
            PreviewController = fakePreviewController,
            ScoreService = fakeScoreService
        }
    }, {
        StoreProvider = storeProvider
    })

    local handle = Roact.mount(app, target)

    return function ()
        Roact.unmount(handle)
    end
end