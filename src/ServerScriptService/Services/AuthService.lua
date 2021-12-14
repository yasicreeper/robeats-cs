local Knit = require(game.ReplicatedStorage.Packages.Knit)

local AuthService = Knit.CreateService({
    Name = "AuthService",
    Client = {}
})

local DataStoreService

AuthService.APIKey = ""

function AuthService:KnitInit()
    DataStoreService = game:GetService("DataStoreService")

    local authStore = DataStoreService:GetDataStore("AuthStore")

    self.APIKey = authStore:GetAsync("APIKey")
end

return AuthService