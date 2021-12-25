local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local StateController = Knit.CreateController { Name = "StateController" }

local Rodux = require(game.ReplicatedStorage.Packages.Rodux)

local OptionsReducer = require(game.ReplicatedStorage.Reducers.OptionsReducer)
local PermissionsReducer = require(game.ReplicatedStorage.Reducers.PermissionsReducer)
local MultiplayerReducer = require(game.ReplicatedStorage.Reducers.MultiplayerReducer)

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local Actions = require(game.ReplicatedStorage.Actions)

local PermissionsService

function StateController:KnitInit()
    PermissionsService = Knit.GetService("PermissionsService")

    local combinedReducers = Rodux.combineReducers({
        options = OptionsReducer,
        permissions = PermissionsReducer,
        multiplayer = MultiplayerReducer
    })
        
    self.Store = Rodux.Store.new(combinedReducers)

    self.Store:dispatch(Actions.setAdmin(PermissionsService:HasModPermissions()))
    self.Store:dispatch(Actions.setTransientOption("SongKey", math.random(1, SongDatabase:get_key_count())))
end

function StateController:KnitStart()
    local StateService = Knit.GetService("StateService")

    StateService.ActionDispatched:Connect(function(action)
        self.Store:dispatch(action)

        -- print(action, self.Store:getState().multiplayer)
    end)

    local _, state = StateService:GetState():await()

    self.Store:dispatch({ type = "setState", state = state })
end

return StateController
