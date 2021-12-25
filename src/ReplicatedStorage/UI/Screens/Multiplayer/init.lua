local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)
local e = Roact.createElement

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedAutoScrollingFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedAutoScrollingFrame)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local Room = require(script.Room)

local withInjection = require(game.ReplicatedStorage.UI.Components.HOCs.withInjection)

local Multiplayer = Roact.Component:extend("Multiplayer")

function Multiplayer:init()
    
end

function Multiplayer:render()
    local rooms = {}

    for id, room in pairs(self.props.rooms) do
        rooms[id] = e(Room, {
            Name = room.name,
            RoomId = id,
            Players = room.players,
            SongRate = room.songRate,
            SongKey = room.selectedSongKey,
            OnJoinClick = function(roomId)
                if not room.inProgress then
                    self.props.multiplayerService:JoinRoomPromise(roomId):andThen(function()
                        self.props.history:push("/room", {
                            roomId = roomId
                        })
                    end)
                end
            end
        })
    end

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
                if self.props.location.state.goToHome then
                    self.props.history:push("/")
                    return
                end
                self.props.history:goBack()
            end
        }),
        AddRoomButton = e(RoundedTextButton, {
            Size = UDim2.fromScale(0.05, 0.05),
            HoldSize = UDim2.fromScale(0.06, 0.06),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.1, 0.95),
            BackgroundColor3 = Color3.fromRGB(40, 78, 45),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = "Create",
            TextSize = 12,
            OnClick = function()
                self.props.multiplayerService:AddRoom("unforget", "me"):andThen(function(id)
                    self.props.history:push("/room", {
                        roomId = id
                    })
                end)
            end
        }),
        Rooms = e(RoundedAutoScrollingFrame, {
            Size = UDim2.fromScale(0.95, 0.95),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5)
        }, rooms)
    })
end

local Injected = withInjection(Multiplayer, {
    multiplayerService = "MultiplayerService"
})

return RoactRodux.connect(function(state)
    return {
        rooms = state.multiplayer.rooms
    }
end)(Injected)