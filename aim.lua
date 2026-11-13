local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local config = {
    AimEnabled = false,
    FOVEnabled = true,
    FOVRadius = 150,
    FOVColor = Color3.fromRGB(255, 0, 0),
    AimBind = false,
}

local function getGui()
    local pg = LocalPlayer:WaitForChild("PlayerGui")
    local old = pg:FindFirstChild("MobileAimGui")
    if old then old:Destroy() end
    local sg = Instance.new("ScreenGui")
    sg.Name = "MobileAimGui"
    sg.ResetOnSpawn = false
    sg.Parent = pg
    return sg
end

local gui = getGui()

local fov = Instance.new("Frame")
fov.Name = "FOV"
fov.BackgroundTransparency = 1
fov.Size = UDim2.new(0, config.FOVRadius * 2, 0, config.FOVRadius * 2)
fov.Position = UDim2.new(0.5, -config.FOVRadius, 0.5, -config.FOVRadius)
fov.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = fov

local stroke = Instance.new("UIStroke")
stroke.Color = config.FOVColor
stroke.Thickness = 2
stroke.Parent = fov

fov.Visible = config.FOVEnabled

local menu = Instance.new("Frame")
menu.Name = "Menu"
menu.Size = UDim2.new(0, 220, 0, 250)
menu.Position = UDim2.new(0, 20, 0, 60)
menu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menu.Parent = gui

local mcorner = Instance.new("UICorner")
mcorner.CornerRadius = UDim.new(0, 10)
mcorner.Parent = menu

local mstroke = Instance.new("UIStroke")
mstroke.Color = config.FOVColor
mstroke.Thickness = 2
mstroke.Parent = menu

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Aim Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = menu

local function makeToggle(name, y, getter, setter)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 34)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = name .. ": " .. (getter() and "ON" or "OFF")
    btn.Parent = menu
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = btn
    btn.MouseButton1Click:Connect(function()
        setter(not getter())
        btn.Text = name .. ": " .. (getter() and "ON" or "OFF")
    end)
    return btn
end

makeToggle("Aim", 40, function() return config.AimEnabled end, function(v) config.AimEnabled = v end)
makeToggle("FOV", 80, function() return config.FOVEnabled end, function(v) config.FOVEnabled = v; fov.Visible = v end)

local colorBtn = Instance.new("TextButton")
colorBtn.Size = UDim2.new(1, -20, 0, 34)
colorBtn.Position = UDim2.new(0, 10, 0, 120)
colorBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
colorBtn.Font = Enum.Font.Gotham
colorBtn.TextSize = 14
colorBtn.Text = "FOV Color"
colorBtn.Parent = menu
local cbc = Instance.new("UICorner")
cbc.CornerRadius = UDim.new(0, 6)
cbc.Parent = colorBtn

local colors = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 150, 255),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(255, 0, 255),
}
local colorIndex = 1
colorBtn.MouseButton1Click:Connect(function()
    colorIndex = colorIndex % #colors + 1
    config.FOVColor = colors[colorIndex]
    stroke.Color = config.FOVColor
    mstroke.Color = config.FOVColor
end)

local radiusSlider = Instance.new("TextButton")
radiusSlider.Size = UDim2.new(1, -20, 0, 34)
radiusSlider.Position = UDim2.new(0, 10, 0, 160)
radiusSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
radiusSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
radiusSlider.Font = Enum.Font.Gotham
radiusSlider.TextSize = 14
radiusSlider.Text = "FOV Radius: " .. config.FOVRadius
radiusSlider.Parent = menu
local rbc = Instance.new("UICorner")
rbc.CornerRadius = UDim.new(0, 6)
rbc.Parent = radiusSlider
radiusSlider.MouseButton1Click:Connect(function()
    config.FOVRadius = config.FOVRadius + 25
    if config.FOVRadius > 300 then config.FOVRadius = 75 end
    fov.Size = UDim2.new(0, config.FOVRadius * 2, 0, config.FOVRadius * 2)
    fov.Position = UDim2.new(0.5, -config.FOVRadius, 0.5, -config.FOVRadius)
    radiusSlider.Text = "FOV Radius: " .. config.FOVRadius
end)

local bind = Instance.new("TextButton")
bind.Size = UDim2.new(0, 90, 0, 45)
bind.Position = UDim2.new(0.5, 60, 0.85, 0)
bind.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
bind.TextColor3 = Color3.fromRGB(255, 255, 255)
bind.Font = Enum.Font.GothamBold
bind.TextSize = 16
bind.Text = "AIM OFF"
bind.Parent = gui
local bbc = Instance.new("UICorner")
bbc.CornerRadius = UDim.new(0, 10)
bbc.Parent = bind

local function updateBind()
    bind.Text = config.AimBind and "AIM ON" or "AIM OFF"
    bind.BackgroundColor3 = config.AimBind and Color3.fromRGB(40, 200, 40) or Color3.fromRGB(200, 40, 40)
end

bind.MouseButton1Click:Connect(function()
    config.AimBind = not config.AimBind
    updateBind()
end)

local function makeDraggable(frame, target)
    local dragging = false
    local dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

makeDraggable(title, menu)
makeDraggable(bind, bind)

local function getTarget()
    local best, bestDist = nil, config.FOVRadius
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChild("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local screen, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local dist = (Vector2.new(screen.X, screen.Y) - center).Magnitude
                    if dist < bestDist then
                        bestDist = dist
                        best = hrp
                    end
                end
            end
        end
    end
    return best
end

RunService.RenderStepped:Connect(function()
    if config.AimEnabled and config.AimBind then
        local target = getTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)

updateBind()
