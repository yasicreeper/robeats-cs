local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local Rodux = require(game.ReplicatedStorage.Packages.Rodux)

local MultiplayerReducer = require(game.ReplicatedStorage.Reducers.MultiplayerReducer)

local StateService = Knit.CreateService {
    Name = "StateService";
    Client = {
        ActionDispatched = Knit.CreateSignal()
    };
}

local function replicationMiddleware(nextDispatch)
    return function(action)
        StateService.Client.ActionDispatched:FireAll(action)
        return nextDispatch(action)
    end
end

function StateService:KnitInit()
    local combinedReducers = Rodux.combineReducers({
        multiplayer = MultiplayerReducer
    })

    self.Store = Rodux.Store.new(combinedReducers, nil, { replicationMiddleware })
end

function StateService.Client:GetState()
    return StateService.Store:getState()
end

return StateService