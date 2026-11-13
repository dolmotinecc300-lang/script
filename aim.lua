local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local config = {
    AimEnabled = false,
    FOVEnabled = true,
    FOVRadius = 150,
    FOVColor = Color3.fromRGB(255, 0, 0),
    AimBind = false,
    ESPEnabled = false,
    VisibleCheck = true,
    TeamCheck = true,
    TargetMode = "All",
}

local targetModes = {"All", "Police", "Criminals", "Inmates"}

local function getGui()
    local pg = LocalPlayer:WaitForChild("PlayerGui")
    local old = pg:FindFirstChild("MobileAimGui")
    if old then old:Destroy() end
    local sg = Instance.new("ScreenGui")
    sg.Name = "MobileAimGui"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.Parent = pg
    return sg
end

local gui = getGui()

-- FOV
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

-- Меню
local menu = Instance.new("Frame")
menu.Name = "Menu"
menu.Size = UDim2.new(0, 260, 0, 420) -- Длинный квадрат
menu.Position = UDim2.new(0, 20, 0, 60)
menu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
menu.Parent = gui
local mcorner = Instance.new("UICorner")
mcorner.CornerRadius = UDim.new(0, 14) -- Закругления
mcorner.Parent = menu
local mstroke = Instance.new("UIStroke")
mstroke.Color = config.FOVColor
mstroke.Thickness = 2
mstroke.Parent = menu

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 35)
title.BackgroundTransparency = 1
title.Text = "Aim Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = menu

-- Крестик
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 2)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.ZIndex = 5
closeBtn.Parent = menu

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 45, 0, 45)
openBtn.Position = UDim2.new(0, 20, 0, 60)
openBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
openBtn.Text = "A"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 20
openBtn.Parent = gui
local obc = Instance.new("UICorner")
obc.CornerRadius = UDim.new(1, 0)
obc.Parent = openBtn
local obstroke = Instance.new("UIStroke")
obstroke.Color = config.FOVColor
obstroke.Thickness = 2
obstroke.Parent = openBtn
openBtn.Visible = false

closeBtn.MouseButton1Click:Connect(function()
    menu.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    menu.Visible = true
    openBtn.Visible = false
end)

-- Функция создания тумблера
local function makeToggle(name, y, getter, setter)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 32)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
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
makeToggle("FOV", 76, function() return config.FOVEnabled end, function(v) config.FOVEnabled = v; fov.Visible = v end)
makeToggle("ESP", 112, function() return config.ESPEnabled end, function(v) config.ESPEnabled = v end)
makeToggle("Visible Check", 148, function() return config.VisibleCheck end, function(v) config.VisibleCheck = v end)
makeToggle("Team Check", 184, function() return config.TeamCheck end, function(v) config.TeamCheck = v end)

-- Выбор цели
local targetBtn = Instance.new("TextButton")
targetBtn.Size = UDim2.new(1, -20, 0, 32)
targetBtn.Position = UDim2.new(0, 10, 0, 220)
targetBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
targetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
targetBtn.Font = Enum.Font.Gotham
targetBtn.TextSize = 13
targetBtn.Text = "Target: " .. config.TargetMode
targetBtn.Parent = menu
local tbc = Instance.new("UICorner")
tbc.CornerRadius = UDim.new(0, 6)
tbc.Parent = targetBtn

targetBtn.MouseButton1Click:Connect(function()
    local currentIndex = 1
    for i, mode in ipairs(targetModes) do
        if mode == config.TargetMode then
            currentIndex = i
            break
        end
    end
    currentIndex = currentIndex % #targetModes + 1
    config.TargetMode = targetModes[currentIndex]
    targetBtn.Text = "Target: " .. config.TargetMode
end)

-- Бинд
local bindBtn = Instance.new("TextButton")
bindBtn.Size = UDim2.new(1, -20, 0, 32)
bindBtn.Position = UDim2.new(0, 10, 0, 256)
bindBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
bindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
bindBtn.Font = Enum.Font.Gotham
bindBtn.TextSize = 13
bindBtn.Text = "Aim Bind: OFF"
bindBtn.Parent = menu
local bbc = Instance.new("UICorner")
bbc.CornerRadius = UDim.new(0, 6)
bbc.Parent = bindBtn

local floatBind = Instance.new("TextButton")
floatBind.Size = UDim2.new(0, 90, 0, 45)
floatBind.Position = UDim2.new(0.5, 60, 0.85, 0)
floatBind.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
floatBind.TextColor3 = Color3.fromRGB(255, 255, 255)
floatBind.Font = Enum.Font.GothamBold
floatBind.TextSize = 16
floatBind.Text = "AIM OFF"
floatBind.Parent = gui
floatBind.Visible = false
local fbc = Instance.new("UICorner")
fbc.CornerRadius = UDim.new(0, 10)
fbc.Parent = floatBind

local function updateBindUI()
    if config.AimBind then
        bindBtn.Text = "Aim Bind: ON"
        floatBind.Visible = true
    else
        bindBtn.Text = "Aim Bind: OFF"
        floatBind.Visible = false
        config.AimEnabled = false
        floatBind.Text = "AIM OFF"
        floatBind.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    end
end

bindBtn.MouseButton1Click:Connect(function()
    config.AimBind = not config.AimBind
    updateBindUI()
end)

floatBind.MouseButton1Click:Connect(function()
    config.AimEnabled = not config.AimEnabled
    floatBind.Text = config.AimEnabled and "AIM ON" or "AIM OFF"
    floatBind.BackgroundColor3 = config.AimEnabled and Color3.fromRGB(40, 200, 40) or Color3.fromRGB(200, 40, 40)
end)

-- Цвет и радиус
local colorBtn = Instance.new("TextButton")
colorBtn.Size = UDim2.new(1, -20, 0, 32)
colorBtn.Position = UDim2.new(0, 10, 0, 292)
colorBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
colorBtn.Font = Enum.Font.Gotham
colorBtn.TextSize = 13
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
end)

local radiusSlider = Instance.new("TextButton")
radiusSlider.Size = UDim2.new(1, -20, 0, 32)
radiusSlider.Position = UDim2.new(0, 10, 0, 328)
radiusSlider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
radiusSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
radiusSlider.Font = Enum.Font.Gotham
radiusSlider.TextSize = 13
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

local function makeDraggable(frame, target)
    local dragging = false
    local dragStart, startPos
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
makeDraggable(floatBind, floatBind)
makeDraggable(openBtn, openBtn)

-- RGB Подсветка меню
local hue = 0
RunService.RenderStepped:Connect(function(dt)
    hue = (hue + dt * 0.1) % 1 -- Медленная переливка
    local rgbColor = Color3.fromHSV(hue, 1, 1)
    mstroke.Color = rgbColor
    obstroke.Color = rgbColor
end)

-- ESP Логика
local espCache = {}

local function getTeamColor(player)
    local char = player.Character
    if not char then return Color3.new(1,1,1) end
    local team = player.Team
    if team then
        local n = team.Name:lower()
        if n:find("guard") or n:find("cop") or n:find("police") then
            return Color3.fromRGB(0, 100, 255)
        elseif n:find("criminal") or n:find("prisoner") then
            return Color3.fromRGB(255, 0, 0)
        elseif n:find("inmate") or n:find("prison") then
            return Color3.fromRGB(0, 255, 0)
        end
    end
    if player.TeamColor then
        if player.TeamColor == BrickColor.new("Really blue") then return Color3.fromRGB(0, 100, 255) end
        if player.TeamColor == BrickColor.new("Really red") then return Color3.fromRGB(255, 0, 0) end
        if player.TeamColor == BrickColor.new("Bright green") then return Color3.fromRGB(0, 255, 0) end
    end
    return Color3.new(1, 1, 1)
end

local function isSameTeam(player)
    if not config.TeamCheck then return false end
    return player.Team == LocalPlayer.Team
end

local function checkTargetMode(player)
    if config.TargetMode == "All" then return true end
    local teamName = (player.Team and player.Team.Name:lower()) or ""
    if config.TargetMode == "Police" then
        return teamName:find("guard") or teamName:find("cop") or teamName:find("police")
    elseif config.TargetMode == "Criminals" then
        return teamName:find("criminal") or teamName:find("prisoner")
    elseif config.TargetMode == "Inmates" then
        return teamName:find("inmate") or teamName:find("prison")
    end
    return false
end

local function applyChams(player)
    local char = player.Character
    if not char or player == LocalPlayer then return end
    local oldHighlight = char:FindFirstChild("ESP_Highlight")
    if oldHighlight then oldHighlight:Destroy() end
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillColor = getTeamColor(player)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = config.ESPEnabled
    highlight.Parent = char
end

local function removeChams(player)
    if player.Character then
        local h = player.Character:FindFirstChild("ESP_Highlight")
        if h then h:Destroy() end
    end
end

local function setupPlayer(player)
    if player == LocalPlayer then return end
    player.CharacterAdded:Connect(function()
        task.wait(1)
        applyChams(player)
    end)
    if player.Character then
        applyChams(player)
    end
end

Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(removeChams)
for _, p in ipairs(Players:GetPlayers()) do setupPlayer(p) end

-- Проверка видимости
local function isVisible(targetPart)
    if not config.VisibleCheck then return true end
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    local result = workspace:Raycast(origin, direction, rayParams)
    return result == nil
end

-- Основной цикл
RunService.RenderStepped:Connect(function()
    -- Аим
    if config.AimEnabled and config.AimBind then
        local best, bestDist = nil, config.FOVRadius
        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local head = p.Character:FindFirstChild("Head")
                local hum = p.Character:FindFirstChild("Humanoid")
                
                if hrp and head and hum and hum.Health > 0 and not isSameTeam(p) and checkTargetMode(p) then
                    local screen, onScreen = Camera.WorldToViewportPoint(head.Position)
                    if onScreen then
                        local dist = (Vector2.new(screen.X, screen.Y) - center).Magnitude
                        if dist < bestDist and isVisible(head) then
                            bestDist = dist
                            best = head
                        end
                    end
                end
            end
        end
        if best then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, best.Position)
        end
    end

    -- Управление хайлайтами
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("ESP_Highlight")
            if highlight then
                highlight.Enabled = config.ESPEnabled
                if config.ESPEnabled then
                    highlight.FillColor = getTeamColor(player)
                end
            end
        end
    end
end)
