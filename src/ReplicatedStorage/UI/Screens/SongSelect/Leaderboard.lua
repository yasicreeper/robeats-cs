local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Llama = require(game.ReplicatedStorage.Packages.Llama)
local join = Llama.Dictionary.join

local RunService = game:GetService("RunService")

local RoundedTextLabel =  require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedAutoScrollingFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedAutoScrollingFrame)
local LoadingWheel = require(game.ReplicatedStorage.UI.Components.Base.LoadingWheel)

local withInjection = require(game.ReplicatedStorage.UI.Components.HOCs.withInjection)

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local LeaderboardSlot = require(game.ReplicatedStorage.UI.Screens.SongSelect.LeaderboardSlot)

local Leaderboard = Roact.Component:extend("LeaderboardDisplay")

Leaderboard.defaultProps = {
    Leaderboard = {},
    Position = UDim2.fromScale(0, 0),
    Size = UDim2.fromScale(1, 1),
    ScoreLimit = 50
}

function Leaderboard:init()
    self.scoreService = self.props.scoreService
    self.moderationService = self.props.moderationService

    self:setState({
        loading = false,
        scores = {}
    })
end

function Leaderboard:performFetch()
    local songMD5Hash = SongDatabase:get_md5_hash_for_key(self.props.SongKey)

    self:setState({
        loading = true
    })

    self.scoreService:GetScores(songMD5Hash, self.props.ScoreLimit, self.props.SongRate):andThen(function(scores)
        self:setState({
            scores = scores,
            loading = false
        })
    end)
end

function Leaderboard:didMount()
    self:performFetch()
end

function Leaderboard:didUpdate(lastProps)
    if lastProps.SongRate ~= self.props.SongRate then
        local oldRate = self.props.SongRate

        task.delay(0.5, function()
            if self.props.SongRate == oldRate then
                self:performFetch()
            end
        end)
    elseif lastProps.SongKey ~= self.props.SongKey then
        self:performFetch()
    end
end

function Leaderboard:render()
    if self.state.loading then
        return Roact.createElement(RoundedFrame, {
            Active = true,
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(25, 25, 25),
            BorderSizePixel = 0,
            Position = self.props.Position,
            AnchorPoint = self.props.AnchorPoint,
            Size = self.props.Size
        }, {
            LoadingWheel = Roact.createElement(LoadingWheel, {
                RotationSpeed = 0.45,
                Size = UDim2.fromScale(0.13, 0.13),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5)
            })
        })
    elseif #self.state.scores == 0 then
        return Roact.createElement(RoundedFrame, {
            Active = true,
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(25, 25, 25),
            BorderSizePixel = 0,
            Position = self.props.Position,
            AnchorPoint = self.props.AnchorPoint,
            Size = self.props.Size
        }, {
            NoScoresMessage = Roact.createElement(RoundedTextLabel, {
                Size = UDim2.fromScale(0.95, 0.3),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Text = "🏆 There are no scores to display! How about setting one?",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 13,
                BackgroundTransparency = 1
            })
        })
    end

    local children = {}
    
    for i, v in pairs(self.state.scores) do
        children[i] = Roact.createElement(LeaderboardSlot, {
            Data = join(v, {
                Place = i
            }),
            OnClick = self.props.OnLeaderboardSlotClicked,
            IsAdmin = self.props.IsAdmin,
            OnDelete = self.props.OnDelete,
            OnBan = self.props.OnBan
        })
    end

    return Roact.createElement(RoundedAutoScrollingFrame, {
        Active = true,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Position = self.props.Position,
        AnchorPoint = self.props.AnchorPoint,
        Size = self.props.Size,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left,
        UIListLayoutProps = {
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 2),
        }
    }, {
        Children = Roact.createFragment(children)
    });
end

return withInjection(Leaderboard, {
    scoreService = "ScoreService",
    moderationService = "ModerationService"
})
