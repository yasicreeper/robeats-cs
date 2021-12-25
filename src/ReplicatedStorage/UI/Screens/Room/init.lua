local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)
local Llama = require(game.ReplicatedStorage.Packages.Llama)
local e = Roact.createElement

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local SongInfoDisplay = require(game.ReplicatedStorage.UI.Screens.SongSelect.SongInfoDisplay)

local withInjection = require(game.ReplicatedStorage.UI.Components.HOCs.withInjection)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedAutoScrollingFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedAutoScrollingFrame)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local Player = require(script.Player)

local Room = Roact.Component:extend("Room")

function Room:init()

end

function Room:didMount()
    self.props.previewController:PlayId(SongDatabase:get_data_for_key(self.props.room.selectedSongKey).AudioAssetId, function(audio)
        audio.TimePosition = audio.TimeLength * 0.33
    end)
    self.props.previewController:SetRate(self.props.room.songRate / 100)
end

function Room:didUpdate()
    if self.props.room.inProgress then
        self.props.history:push("/play", {
            roomId = self.props.roomId
        })
        return
    end

    self.props.previewController:PlayId(SongDatabase:get_data_for_key(self.props.room.selectedSongKey).AudioAssetId, function(audio)
        audio.TimePosition = audio.TimeLength * 0.33
    end)
    self.props.previewController:SetRate(self.props.room.songRate / 100)
end

function Room:render()
    local players = Llama.Dictionary.map(self.props.room.players, function(player)
        return e(Player, {
            Name = player.Name,
            UserId = player.UserId
        })
    end)

    return e(RoundedFrame, {
    
    }, {
        BackButton = e(RoundedTextButton, {
            Size = UDim2.fromScale(0.05, 0.05),
            HoldSize = UDim2.fromScale(0.06, 0.06),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.04, 0.95),
            BackgroundColor3 = Color3.fromRGB(212, 23, 23),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = "Back",
            TextSize = 12,
            OnClick = function()
                self.props.multiplayerService:LeaveRoom(self.props.roomId)
                if self.props.location.state.goToMultiSelect then
                    self.props.history:push("/multiplayer", {
                        goToHome = true
                    })
                    return
                end
                self.props.history:goBack()
            end
        }),
        StartButton = e(RoundedTextButton, {
            Size = UDim2.fromScale(0.05, 0.05),
            HoldSize = UDim2.fromScale(0.06, 0.06),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.96, 0.95),
            BackgroundColor3 = self.props.isHost and Color3.fromRGB(56, 105, 67) or Color3.fromRGB(51, 51, 51),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = "Start",
            TextSize = 12,
            OnClick = function()
                if self.props.isHost then
                    self.props.multiplayerService:StartMatch(self.props.roomId)
                end
            end
        }),
        ChangeSongButton = e(RoundedTextButton, {
            Size = UDim2.fromScale(0.05, 0.05),
            HoldSize = UDim2.fromScale(0.06, 0.06),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.097, 0.95),
            BackgroundColor3 = self.props.isHost and Color3.fromRGB(64, 121, 121) or Color3.fromRGB(51, 51, 51),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = "Change Song",
            TextSize = 9,
            OnClick = function()
                if self.props.isHost then
                    self.props.history:push("/select", {
                        roomId = self.props.roomId
                    })
                end
            end
        }),
        SongInfoDisplay = e(SongInfoDisplay, {
            ShowRateButtons = self.props.isHost,
            OnUprate = function()
                self.props.multiplayerService:SetSongRate(self.props.roomId, self.props.room.songRate + 5)
            end,
            OnDownrate = function()
                self.props.multiplayerService:SetSongRate(self.props.roomId, self.props.room.songRate - 5)
            end,
            SongRate = self.props.room.songRate,
            Position = UDim2.fromScale(0.5, 0.12),
            Size = UDim2.fromScale(0.975, 0.2),
            AnchorPoint = Vector2.new(0.5, 0.5),
            SongKey = self.props.room.selectedSongKey
        }),
        Players = e(RoundedAutoScrollingFrame, {
            Size = UDim2.fromScale(0.567, 0.68),
            Position = UDim2.fromScale(0.01, 0.23)
        }, players)
    })
end

function Room:willUnmount()
    self.props.previewController:Silence()
end

local Injected = withInjection(Room, {
    multiplayerService = "MultiplayerService",
    previewController = "PreviewController"
})

return RoactRodux.connect(function(state, props)
    local userId = game.Players.LocalPlayer and game.Players.LocalPlayer.UserId

    print(props)

    local room = state.multiplayer.rooms[props.location.state.roomId]

    return {
        room = room,
        roomId = props.location.state.roomId,
        isHost = if room.host then userId == state.multiplayer.rooms[props.location.state.roomId].host.UserId else false
    }
end)(Injected)