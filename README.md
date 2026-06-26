local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local SendToDiscordEvent = ReplicatedStorage:WaitForChild("SendToDiscordEvent")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local infiniteJumpEnabled = false
local espEnabled = false
local customSpeedEnabled = false
local defaultWalkSpeed = 16
local currentSpeed = 16
local espObjects = {}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminPanel"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 290, 0, 380)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Admin Panel"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(0.9, 0, 0, 45)
discordBtn.Position = UDim2.new(0.05, 0, 0, 50)
discordBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
discordBtn.Text = "Send Info to Discord"
discordBtn.TextColor3 = Color3.new(1,1,1)
discordBtn.TextScaled = true
discordBtn.Font = Enum.Font.GothamBold
discordBtn.Parent = mainFrame
Instance.new("UICorner", discordBtn)

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 25)
speedLabel.Position = UDim2.new(0.05, 0, 0, 110)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Custom Speed"
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = mainFrame

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.55, 0, 0, 35)
speedBox.Position = UDim2.new(0.05, 0, 0, 135)
speedBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
speedBox.Text = "50"
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Parent = mainFrame
Instance.new("UICorner", speedBox)

local toggleSpeedBtn = Instance.new("TextButton")
toggleSpeedBtn.Size = UDim2.new(0.35, 0, 0, 35)
toggleSpeedBtn.Position = UDim2.new(0.62, 0, 0, 135)
toggleSpeedBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
toggleSpeedBtn.Text = "OFF"
toggleSpeedBtn.TextColor3 = Color3.new(1,1,1)
toggleSpeedBtn.Parent = mainFrame
Instance.new("UICorner", toggleSpeedBtn)

local infJumpBtn = Instance.new("TextButton")
infJumpBtn.Size = UDim2.new(0.9, 0, 0, 45)
infJumpBtn.Position = UDim2.new(0.05, 0, 0, 190)
infJumpBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
infJumpBtn.Text = "Infinite Jump: OFF"
infJumpBtn.TextColor3 = Color3.new(1,1,1)
infJumpBtn.TextScaled = true
infJumpBtn.Font = Enum.Font.GothamSemibold
infJumpBtn.Parent = mainFrame
Instance.new("UICorner", infJumpBtn)

local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0.9, 0, 0, 45)
espBtn.Position = UDim2.new(0.05, 0, 0, 245)
espBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
espBtn.Text = "ESP: OFF"
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.TextScaled = true
espBtn.Font = Enum.Font.GothamSemibold
espBtn.Parent = mainFrame
Instance.new("UICorner", espBtn)

local function toggleCustomSpeed()
    customSpeedEnabled = not customSpeedEnabled
    local speedValue = tonumber(speedBox.Text) or 50
    if customSpeedEnabled then
        currentSpeed = speedValue
        toggleSpeedBtn.Text = "ON"
        toggleSpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        if humanoid then humanoid.WalkSpeed = currentSpeed end
    else
        toggleSpeedBtn.Text = "OFF"
        toggleSpeedBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        if humanoid then humanoid.WalkSpeed = defaultWalkSpeed end
    end
end

local function toggleInfiniteJump()
    infiniteJumpEnabled = not infiniteJumpEnabled
    infJumpBtn.Text = "Infinite Jump: " .. (infiniteJumpEnabled and "ON" or "OFF")
    infJumpBtn.BackgroundColor3 = infiniteJumpEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(100, 100, 100)
end

local function createESP(plr)
    if plr == player then return end
    local char = plr.Character
    if not char then return end
   
    local highlight = Instance.new("Highlight")
    highlight.Adornee = char
    highlight.FillColor = Color3.fromRGB(255, 50, 50)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.6
    highlight.Parent = screenGui

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = char:FindFirstChild("Head")
    billboard.Size = UDim2.new(0, 250, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = screenGui

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = plr.Name .. " (" .. plr.UserId .. ")"
    nameLabel.TextColor3 = Color3.new(1,1,1)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard

    espObjects[plr] = {highlight, billboard}
end

local function toggleESP()
    espEnabled = not espEnabled
    espBtn.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(100, 100, 100)

    if espEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            createESP(plr)
        end
    else
        for _, objects in pairs(espObjects) do
            for _, obj in pairs(objects) do obj:Destroy() end
        end
        espObjects = {}
    end
end

discordBtn.MouseButton1Click:Connect(function()
    SendToDiscordEvent:FireServer()
    discordBtn.Text = "Sent to Discord!"
    task.wait(1.5)
    discordBtn.Text = "Send Info to Discord"
end)

toggleSpeedBtn.MouseButton1Click:Connect(toggleCustomSpeed)
infJumpBtn.MouseButton1Click:Connect(toggleInfiniteJump)
espBtn.MouseButton1Click:Connect(toggleESP)

speedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and customSpeedEnabled and humanoid then
        currentSpeed = tonumber(speedBox.Text) or 50
        humanoid.WalkSpeed = currentSpeed
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    task.wait(0.5)
    if customSpeedEnabled then
        humanoid.WalkSpeed = currentSpeed
    end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        if espEnabled then createESP(plr) end
    end)
end)
