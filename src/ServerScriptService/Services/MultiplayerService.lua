local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local HttpService = game:GetService("HttpService")

local MultiplayerService = Knit.CreateService {
    Name = "MultiplayerService";
    Client = {};
}

local Llama

local StateService

local AssertType

function MultiplayerService:KnitStart()
    game.Players.PlayerRemoving:Connect(function(player)
        local store = StateService.Store
        local state = MultiplayerService:GetState()

        for id, match in pairs(state.multiplayer.matches) do
            for _, matchPlayer in pairs(match.players) do
                if matchPlayer.player == player then
                    store:dispatch({
                        type = "removeMatchPlayer",
                        roomId = id,
                        player = player
                    })
                end
            end
        end

        for id, room in pairs(state.multiplayer.rooms) do
            if table.find(room.players, player) then
                store:dispatch({
                    type = "removePlayer",
                    roomId = id,
                    player = player
                })
            end
        end
    end)
end

function MultiplayerService:KnitInit()
    StateService = Knit.GetService("StateService")
    Llama = require(game.ReplicatedStorage.Packages.Llama)
    AssertType = require(game.ReplicatedStorage.Shared.AssertType)
end

function MultiplayerService:GetState()
    return StateService.Store:getState()
end

function MultiplayerService:IsHost(player, id)
    local state = self:GetState()
    return state.multiplayer.rooms[id].host == player
end

function MultiplayerService.Client:AddRoom(player, name, password)
    local id = HttpService:GenerateGUID(false)

    StateService.Store:dispatch({
        type = "createRoom",
        name = name,
        id = id,
        player = player,
        password = password
    })

    return id
end

function MultiplayerService.Client:RemoveRoom(player)

end

function MultiplayerService.Client:LeaveRoom(player, id)
    AssertType:is_string(id)

    local store = StateService.Store
    local state = MultiplayerService:GetState()

    local room = state.multiplayer.rooms[id]

    if room.players[tostring(player.UserId)] then
        if Llama.Dictionary.count(room.players) == 1 then
            store:dispatch({
                type = "removeRoom",
                roomId = id
            })
            return
        end
        store:dispatch({
            type = "removePlayer",
            player = player,
            roomId = id
        })

        local match = state.multiplayer.matches[id]

        if match and match.players[tostring(player.UserId)] then
            store:dispatch({
                type = "removeMatchPlayer",
                roomId = id,
                player = player
            })
        end
    end
end

function MultiplayerService.Client:StartMatch(player, id)
    AssertType:is_string(id)

    local store = StateService.Store
    local state = MultiplayerService:GetState()

    if state.multiplayer.matches[id] and state.multiplayer.matches[id].ongoing then
        return
    end

    if MultiplayerService:IsHost(player, id) then
        store:dispatch({
            type = "startMatch",
            roomId = id
        })
    end
end

function MultiplayerService.Client:SetReady(player, id, value)
    AssertType:is_string(id)
    
    local store = StateService.Store

    store:dispatch({
        type = "setReady",
        roomId = id,
        userId = player.UserId,
        value = value
    })

    if not value then
        local state = MultiplayerService:GetState()

        local readyPlayers = #Llama.Dictionary.filter(state.multiplayer.matches[id].players, function(matchPlayer)
            return matchPlayer.ready
        end)

        if readyPlayers == 0 then
            store:dispatch({
                type = "endMatch",
                roomId = id
            })
        end
    end
end

function MultiplayerService.Client:SetSongKey(player, id, key)
    AssertType:is_string(id)

    local store = StateService.Store

    if MultiplayerService:IsHost(player, id) then
        store:dispatch({
            type = "setSongKey",
            songKey = key,
            roomId = id
        })
    end
end

function MultiplayerService.Client:SetSongRate(player, id, rate)
    AssertType:is_string(id)

    local store = StateService.Store

    if MultiplayerService:IsHost(player, id) then
        store:dispatch({
            type = "setSongRate",
            songRate = rate,
            roomId = id
        })
    end
end

function MultiplayerService.Client:JoinRoom(player, id)
    AssertType:is_string(id)

    local store = StateService.Store
    local state = MultiplayerService:GetState()

    if state.multiplayer.rooms[id].inProgress then
        return
    end

    store:dispatch({
        type = "addPlayer",
        player = player,
        roomId = id
    })
end

function MultiplayerService.Client:SetMatchStats(player, id, stats)
    AssertType:is_string(id)

    local store = StateService.Store

    local action = {
        type = "setMatchStats",
        roomId = id,
        userId = player.UserId
    }

    store:dispatch(Llama.Dictionary.join(action, stats))
end

return MultiplayerService
