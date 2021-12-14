local Knit = require(game.ReplicatedStorage.Packages.Knit)

local EnvironmentSetup = require(game.ReplicatedStorage.RobeatsGameCore.EnvironmentSetup)

local function game_init()
	Knit.AddControllers(game.ReplicatedStorage.Controllers)
	EnvironmentSetup:initial_setup()

	Knit.Start():andThen(function()
		print("Knit successfully started(client)")
	end):catch(function(err)
		warn(err)
	end)
end

game_init()
