local LocalizationService = game:GetService("LocalizationService")
local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local withInjection = require(game.ReplicatedStorage.UI.Components.HOCs.withInjection)

local Matchmaking = Roact.Component:extend("Matchmaking")

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local LoadingWheel = require(game.ReplicatedStorage.UI.Components.Base.LoadingWheel)

function Matchmaking:init()

end

function Matchmaking:render()
    return e(RoundedFrame, {

    }, {
        Message = e(RoundedTextLabel, {
            Position = UDim2.fromScale(0.54, 0.5),
            Size = UDim2.fromScale(0.2, 0.2),
            AnchorPoint = Vector2.new(1, 0.5),
            Text = "Finding match...",
            TextScaled = true,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Right
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 25
            })
        }),
        LoadingWheel = e(LoadingWheel, {
            Position = UDim2.fromScale(0.57, 0.5),
            Size = UDim2.fromScale(0.1, 0.1),
            AnchorPoint = Vector2.new(0, 0.5)
        }),
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
                self.props.history:goBack()
            end
        }),
    })
end

-- return withInjection(Matchmaking, {
--     matchmakingService = "MatchmakingService"
-- })

return Matchmaking