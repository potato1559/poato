-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create a Window
local Window = Rayfield:CreateWindow({
    Name = "Player Speed Modifier",
    LoadingTitle = "Loading Speed Modifier...",
    LoadingSubtitle = "Client-Side Control",
    ConfigurationSaving = { Enabled = false }
})

-- Create a Tab
local MainTab = Window:CreateTab("Speed Controls", 4483362458)

-- Variables
local player = game:GetService("Players").LocalPlayer
local targetSpeed = 16
local speedEnabled = false
local heartbeatConnection

-- Function to apply speed
local function applySpeed(speed)
    if player and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
        end
    end
end

-- Slider for Speed Value
local SpeedSlider = MainTab:CreateSlider({
    Name = "Set Player Speed (0 - 100000)",
    Range = {0, 100000},
    Increment = 1000,
    Suffix = " WalkSpeed",
    CurrentValue = 16,
    Callback = function(Value)
        targetSpeed = Value
        if speedEnabled then
            applySpeed(targetSpeed)
        end
    end,
})

-- Toggle Button
local SpeedToggle = MainTab:CreateToggle({
    Name = "Enable Speed Modifier",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(Value)
        speedEnabled = Value
        if speedEnabled then
            heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function()
                applySpeed(targetSpeed)
            end)
            applySpeed(targetSpeed)
            Rayfield:Notify({
                Title = "Speed Modifier Enabled",
                Content = "WalkSpeed is now active.",
                Duration = 3
            })
        else
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
                heartbeatConnection = nil
            end
            applySpeed(16)
            Rayfield:Notify({
                Title = "Speed Modifier Disabled",
                Content = "WalkSpeed reset to default (16).",
                Duration = 3
            })
        end
    end,
})

-- Handle Character Respawns
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    if speedEnabled then
        applySpeed(targetSpeed)
    end
end)
