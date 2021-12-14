local RunService = game:GetService("RunService")

local function url(endpoint)
    local dev = RunService:IsStudio() and not game.ServerScriptService:GetAttribute("UseReleaseAPI")
    
    return string.format(if dev then game.ServerScriptService.URLs.Dev.Value else game.ServerScriptService.URLs.Release.Value) .. endpoint
end

return url