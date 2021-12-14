local Knit = require(game.ReplicatedStorage.Packages.Knit)

local PermissionsService
local ChatService

local ChatTagService = Knit.CreateService {
    Name = "ChatTagService";
    Client = {}
}

ChatTagService.TagData = {
    Staff = {TagText = "STAFF", TagColor = Color3.fromRGB(248, 113, 113)},
}

function ChatTagService:KnitStart()
    PermissionsService = Knit.GetService("PermissionsService")
    ChatService = require(game.ServerScriptService:WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"))

    ChatService.SpeakerAdded:Connect(function(Speaker)
        self:HandleSpeakerAdded(Speaker)
    end)

    for _, speaker in ipairs(ChatService:GetSpeakerList()) do
        self:HandleSpeakerAdded(speaker)
    end
end

function ChatTagService:HandleSpeakerAdded(speakerName)
    local speaker = ChatService:GetSpeaker(speakerName)
    local player = speaker:GetPlayer()

    if player and PermissionsService:HasModPermissions(player) then
        speaker:SetExtraData("Tags", { ChatTagService.TagData.Staff })
    end
end

return ChatTagService