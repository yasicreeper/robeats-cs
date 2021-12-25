local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement
local f = Roact.createFragment
local Llama = require(game.ReplicatedStorage.Packages.Llama)

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local LeaderboardSlot = require(game.ReplicatedStorage.UI.Screens.Gameplay.LeaderboardSlot)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)

local MultiplayerLeaderboard = Roact.Component:extend("MultiplayerLeaderboard")

MultiplayerLeaderboard.defaultProps = {
    SongKey = 1,
    LocalRating = 0,
    LocalAccuracy = 0,
    Scores = {}
}

function MultiplayerLeaderboard:render()
    local scores = Llama.Dictionary.values(self.props.Scores)

    table.sort(scores, function(a, b)
        return a.rating > b.rating
    end)

    local children = Llama.Dictionary.map(scores, function(itr_score, itr_score_index)
        local player = itr_score.player

        return e(LeaderboardSlot, {
           PlayerName = player.Name,
           UserId = player.UserId,
           Rating = itr_score.rating,
           Accuracy = itr_score.accuracy,
           Place = itr_score_index,
           IsLocalProfile = player.UserId == game.Players.LocalPlayer.UserId
       })
    end)

    return e(RoundedFrame, {
        Position = self.props.Position,
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.fromScale(0.175, 0.5),
        BackgroundTransparency = 1
    }, children)
end

return MultiplayerLeaderboard