local Flipper = require(game.ReplicatedStorage.Packages.Flipper)
local Promise = require(game.ReplicatedStorage.Packages.Promise)

local function withHitDeviancePoint(_hit_deviance_point)
    local motor = Flipper.SingleMotor.new(1)

    motor:onStep(function(a)
        if a == 1 then
            _hit_deviance_point:Destroy()
            return
        end

        _hit_deviance_point.BackgroundTransparency = a
    end)

    Promise.delay(2):andThen(function()
        motor:setGoal(Flipper.Spring.new(1, {
            frequency = 0.4;
            dampingRatio = 1.5;
        }))
    end)

    motor:setGoal(Flipper.Spring.new(0, {
        frequency = 4;
        dampingRatio = 1.5;
    }))
end

return withHitDeviancePoint