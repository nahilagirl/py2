--// GUI setup
local gui = Instance.new("ScreenGui")
gui.Name = "RIVAL Cheat"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 300)
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
title.TextColor3 = Color3.new(1, 1, 1)
title.Text = "RIVAL Cheat Menu"
title.Parent = frame

local triggerBotToggle = Instance.new("TextButton")
triggerBotToggle.Size = UDim2.new(1, 0, 0, 30)
triggerBotToggle.Position = UDim2.new(0, 0, 0, 30)
triggerBotToggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
triggerBotToggle.TextColor3 = Color3.new(1, 1, 1)
triggerBotToggle.Text = "Trigger Bot: OFF"
triggerBotToggle.Parent = frame

local aimBotToggle = Instance.new("TextButton")
aimBotToggle.Size = UDim2.new(1, 0, 0, 30)
aimBotToggle.Position = UDim2.new(0, 0, 0, 60)
aimBotToggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
aimBotToggle.TextColor3 = Color3.new(1, 1, 1)
aimBotToggle.Text = "Aim Bot: OFF"
aimBotToggle.Parent = frame

local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(1, 0, 0, 30)
espToggle.Position = UDim2.new(0, 0, 0, 90)
espToggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
espToggle.TextColor3 = Color3.new(1, 1, 1)
espToggle.Text = "ESP: OFF"
espToggle.Parent = frame

--// Cheat variables
local triggerBotEnabled = false
local aimBotEnabled = false
local espEnabled = false

--// Anti-cheat bypass (basic, might not work)
local function bypassAntiCheat()
    --// Attempt to disable some anti-cheat functions
    game:GetService("ScriptService").Disabled = true
    game:GetService("RunService"):SetPhysicsThrottleEnabled(false)
end

bypassAntiCheat()

--// Trigger bot
triggerBotToggle.MouseButton1Click:Connect(function()
    triggerBotEnabled = not triggerBotEnabled
    if triggerBotEnabled then
        triggerBotToggle.Text = "Trigger Bot: ON"
    else
        triggerBotToggle.Text = "Trigger Bot: OFF"
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if triggerBotEnabled then
        local mouse = game.Players.LocalPlayer:GetMouse()
        local target = mouse.Target
        if target and target.Parent:FindFirstChild("Humanoid") then
            mouse.Button1Down:FireServer()
        end
    end
end)

--// Aim bot
aimBotToggle.MouseButton1Click:Connect(function()
    aimBotEnabled = not aimBotEnabled
    if aimBotEnabled then
        aimBotToggle.Text = "Aim Bot: ON"
    else
        aimBotToggle.Text = "Aim Bot: OFF"
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if aimBotEnabled then
        local localPlayer = game.Players.LocalPlayer
        local character = localPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local rootPart = character.HumanoidRootPart
            local closestTarget = nil
            local closestDistance = math.huge
            
            for i, player in pairs(game.Players:GetPlayers()) do
                if player ~= localPlayer then
                    local targetCharacter = player.Character
                    if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
                        local targetRootPart = targetCharacter.HumanoidRootPart
                        local distance = (rootPart.Position - targetRootPart.Position).Magnitude
                        if distance < closestDistance then
                            closestTarget = targetRootPart
                            closestDistance = distance
                        end
                    end
                end
            end
            
            if closestTarget then
                local camera = game.Workspace.CurrentCamera
                local viewportPoint = camera:WorldToViewportPoint(closestTarget.Position)
                game.Players.LocalPlayer:GetMouse().X = viewportPoint.X
                game.Players.LocalPlayer:GetMouse().Y = viewportPoint.Y
            end
        end
    end
end)

--// ESP
espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        espToggle.Text = "ESP: ON"
    else
        espToggle.Text = "ESP: OFF"
    end
end)

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if espEnabled then
            local box = Instance.new("BillboardGui")
            box.Name = "ESPBox"
            box.Adornee = character:FindFirstChild("HumanoidRootPart")
            box.Size = UDim2.new(0, 50, 0, 50)
            box.AlwaysOnTop = true
            box.Parent = character
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = Color3.new(1, 0, 0)
            frame.BackgroundTransparency = 0.5
            frame.Parent = box
        end
    end)
end)

game.Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        local character = player.Character
        local espBox = character:FindFirstChild("ESPBox")
        if espBox then
            espBox:Destroy()
        end
    end
end)
