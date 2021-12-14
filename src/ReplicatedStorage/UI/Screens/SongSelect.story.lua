local Promise = require(game.ReplicatedStorage.Packages.Promise)
local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)
local State = require(game.ReplicatedStorage.State)
local SongSelect = require(game.ReplicatedStorage.UI.Screens.SongSelect)
local Fitumi = require(game.ReplicatedStorage.Packages.Fitumi)

local a = Fitumi.a

local DIContext = require(game.ReplicatedStorage.Contexts.DIContext)

return function(target)
    local storeProvider = Roact.createElement(RoactRodux.StoreProvider, {
        store = State.Store
    }, {
        App = Roact.createElement(SongSelect)
    })

    local fakeScoreService = a.fake()

    a.callTo(fakeScoreService.GetScoresPromise, fakeScoreService, Fitumi.wildcard, Fitumi.wildcard)
        :returns(Promise.new(function(resolve)
            local fakeLeaderboard = {}

            for i = 1, 50 do
                local randomPlayerName = ""

                for _ = 1, math.random(4, 13) do
                    randomPlayerName ..= string.char(math.random(97, 122))
                end

                local fakeLeaderboardSlot = {
                    UserId = math.random(1000, 100000),
                    PlayerName = randomPlayerName,
                    Marvelouses = math.random(1230, 2340),
                    Perfects = math.random(678, 890),
                    Greats = math.random(145, 300),
                    Goods = math.random(3, 78),
                    Bads = math.random(0, 17),
                    Misses = math.random(1, 57),
                    Accuracy = math.random(52, 100),
                    Place = i,
                    Rating = math.random(0.2, 54),
                    Score = math.random(50, 190),
                    Rate = math.floor(math.random(50, 190))
                }

                table.insert(fakeLeaderboard, fakeLeaderboardSlot)
            end

            resolve(fakeLeaderboard)
        end))

    local fakePreviewController = a.fake()

    a.callTo(fakePreviewController.PlayId, fakePreviewController, Fitumi.wildcard)
        :returns(nil)

    local app = Roact.createElement(DIContext.Provider, {
        value = {
            ScoreService = fakeScoreService,
            PreviewController = fakePreviewController
        }
    }, {
        StoreProvider = storeProvider
    })

    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end