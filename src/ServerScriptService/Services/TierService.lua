local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

local TierService = Knit.CreateService {
    Name = "TierService";
    Client = {};
}

local TierRatingMap = {
    { name = "Prism", minRating = 65 },
    { name = "Ultraviolet", minRating = 55 },
    { name = "Emerald", minRating = 45 },
    { name = "Diamond", minRating = 35 },
    { name = "Gold", minRating = 27 },
    { name = "Silver", minRating = 18 },
    { name = "Bronze", minRating = 11 },
    { name = "Tin", minRating = 0 }
}

function TierService:GetTierFromRating(rating)
    for i, tier in ipairs(TierRatingMap) do
        if rating >= tier.minRating or i == #TierRatingMap then
            if i ~= 1 then
                local nextTier = TierRatingMap[i - 1]

                for x = 2, 0, -1 do
                    if rating >= SPUtil:lerp(tier.minRating, nextTier.minRating, x / 3) then
                        return {
                            name = tier.name,
                            division = x + 1
                        }
                    end
                end
            else
                return {
                    name = tier.name
                }
            end
        end
    end
end

function TierService.Client:GetTierFromRating(_, rating)
    return TierService:GetTierFromRating(rating)
end

return TierService