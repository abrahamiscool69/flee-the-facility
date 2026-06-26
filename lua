local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WEBHOOK_URL = "https://discord.com/api/webhooks/1519860915086950510/-apfDDjN1CYYrNizN0UfoeN-PYb_I_bOJVBp7peiS6d5IBoWcb-6ukW4O8RFENPxW96i"
local YOUR_GAME_ID = 893973440

local SendToDiscordEvent = ReplicatedStorage:WaitForChild("SendToDiscordEvent")

local function sendToDiscord(player)
    if game.PlaceId ~= YOUR_GAME_ID then return end

    local success, gameInfo = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)

    local data = {
        username = "Roblox Logger",
        avatar_url = "https://i.imgur.com/4n9v5.png",
        embeds = {{
            title = "🎮 Player Clicked Log Button",
            color = 0x00ff00,
            fields = {
                { name = "Username", value = player.Name, inline = true },
                { name = "User ID", value = tostring(player.UserId), inline = true },
                { name = "Display Name", value = player.DisplayName, inline = true },
                { name = "Account Age", value = player.AccountAge .. " days", inline = true },
                { name = "Server ID", value = game.JobId, inline = false },
                { name = "Place ID", value = tostring(game.PlaceId), inline = true },
                { name = "Game Name", value = success and gameInfo.Name or "Unknown", inline = true },
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)
end

SendToDiscordEvent.OnServerEvent:Connect(sendToDiscord)
print("Discord Logger loaded")
