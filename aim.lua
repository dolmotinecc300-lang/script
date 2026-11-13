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

-- Основное меню
local menu = Instance.new("Frame")
menu.Name = "Menu"
menu.Size = UDim2.new(0, 380, 0, 260)
menu.Position = UDim2.new(0, 20, 0, 60)
menu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
menu.Parent = gui
local mcorner = Instance.new("UICorner")
mcorner.CornerRadius = UDim.new(0, 14)
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

-- Панели вкладок
local pages = {}
local currentPage = nil

local function createPage(name)
    local page = Instance.new("Frame")
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, -80)
    page.Position = UDim2.new(0, 0, 0, 80)
    page.BackgroundTransparency = 1
    page.Parent = menu
    page.Visible = false
    pages[name] = page
    return page
end

local aimPage = createPage("Aim")
local espPage = createPage("ESP")
local settingsPage = createPage("Settings")

local function switchPage(name)
    if currentPage then
        pages[currentPage].Visible = false
    end
    currentPage = name
    pages[name].Visible = true
end

-- Кнопки навигации (Стикеры)
local navButtons = {}

local function makeNavButton(text, x, pageName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = UDim2.new(0, x, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 24
    btn.Text = text
    btn.Parent = menu
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 8)
    bc.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(navButtons) do
            b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end
        btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        switchPage(pageName)
    end)
    table.insert(navButtons, btn)
    return btn
end

makeNavButton("🎯", 10, "Aim")
makeNavButton("👁️", 70, "ESP")
makeNavButton("⚙️", 130, "Settings")

-- ================= СТРАНИЦА АИМ =================
-- Кнопка включения аима
local aimToggleBtn = Instance.new("TextButton")
aimToggleBtn.Size = UDim2.new(0, 175, 0, 32)
aimToggleBtn.Position = UDim2.new(0, 10, 0, 10)
aimToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
aimToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
aimToggleBtn.Font = Enum.Font.Gotham
aimToggleBtn.TextSize = 13
aimToggleBtn.Text = "Aim: OFF"
aimToggleBtn.Parent = aimPage
local atbc = Instance.new("UICorner")
atbc.CornerRadius = UDim.new(0, 6)
atbc.Parent = aimToggleBtn

aimToggleBtn.MouseButton1Click:Connect(function()
    config.AimEnabled = not config.AimEnabled
    aimToggleBtn.Text = "Aim: " .. (config.AimEnabled and "ON" or "OFF")
end)

-- Ползунок FOV
local fovSliderBg = Instance.new("Frame")
fovSliderBg.Size = UDim2.new(0, 350, 0, 10)
fovSliderBg.Position = UDim2.new(0, 10, 0, 60)
fovSliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fovSliderBg.Parent = aimPage
local fsbc = Instance.new("UICorner")
fsbc.CornerRadius = UDim.new(1, 0)
fsbc.Parent = fovSliderBg

local fovSliderFill = Instance.new("Frame")
fovSliderFill.Size = UDim2.new(config.FOVRadius / 360, 0, 1, 0)
fovSliderFill.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
fovSliderFill.Parent = fovSliderBg
local fsfc = Instance.new("UICorner")
fsfc.CornerRadius = UDim.new(1, 0)
fsfc.Parent = fovSliderFill

local fovSliderText = Instance.new("TextLabel")
fovSliderText.Size = UDim2.new(1, 0, 0, 20)
fovSliderText.Position = UDim2.new(0, 0, 0, -22)
fovSliderText.BackgroundTransparency = 1
fovSliderText.Text = "FOV: " .. config.FOVRadius
fovSliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
fovSliderText.Font = Enum.Font.Gotham
fovSliderText.TextSize = 13
fovSliderText.Parent = fovSliderBg

local isDraggingFov = false
local function updateFovSlider(input)
    local relX = math.clamp(input.Position.X - fovSliderBg.AbsolutePosition.X, 0, fovSliderBg.AbsoluteSize.X)
    local value = math.floor((relX / fovSliderBg.AbsoluteSize.X) * 360)
    config.FOVRadius = value
    fovSliderFill.Size = UDim2.new(value / 360, 0, 1, 0)
    fovSliderText.Text = "FOV: " .. value
    fov.Size = UDim2.new(0, value * 2, 0, value * 2)
    fov.Position = UDim2.new(0.5, -value, 0.5, -value)
end

fovSliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingFov = true
        updateFovSlider(input)
    end
end)
RunService.RenderStepped:Connect(function()
    if isDraggingFov then
        local mouse = game.Players.LocalPlayer:GetMouse()
        updateFovSlider({Position = Vector2.new(mouse.X, mouse.Y)})
    end
end)
fovSliderBg.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingFov = false
    end
end)

-- ================= СТРАНИЦА ESP =================
-- Кнопка включения ESP
local espToggleBtn = Instance.new("TextButton")
espToggleBtn.Size = UDim2.new(0, 175, 0, 32)
espToggleBtn.Position = UDim2.new(0, 10, 0, 10)
espToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
espToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espToggleBtn.Font = Enum.Font.Gotham
espToggleBtn.TextSize = 13
espToggleBtn.Text = "ESP: OFF"
espToggleBtn.Parent = espPage
local etbc = Instance.new("UICorner")
etbc.CornerRadius = UDim.new(0, 6)
etbc.Parent = espToggleBtn

espToggleBtn.MouseButton1Click:Connect(function()
    config.ESPEnabled = not config.ESPEnabled
    espToggleBtn.Text = "ESP: " .. (config.ESPEnabled and "ON" or "OFF")
end)

-- Выбор цели (модальное окно)
local targetBtn = Instance.new("TextButton")
targetBtn.Size = UDim2.new(0, 175, 0, 32)
targetBtn.Position = UDim2.new(0, 10, 0, 50)
targetBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
targetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
targetBtn.Font = Enum.Font.Gotham
targetBtn.TextSize = 13
targetBtn.Text = "Target: " .. config.TargetMode
targetBtn.Parent = espPage
local tbc = Instance.new("UICorner")
tbc.CornerRadius = UDim.new(0, 6)
tbc.Parent = targetBtn

local targetDropdown = Instance.new("Frame")
targetDropdown.Size = UDim2.new(0, 175, 0, 130)
targetDropdown.Position = UDim2.new(0, 10, 0, 86)
targetDropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
targetDropdown.Parent = espPage
targetDropdown.Visible = false
local tdc = Instance.new("UICorner")
tdc.CornerRadius = UDim.new(0, 6)
tdc.Parent = targetDropdown

for i, mode in ipairs(targetModes) do
    local opt = Instance.new("TextButton")
    opt.Size = UDim2.new(1, 0, 0, 30)
    opt.Position = UDim2.new(0, 0, 0, (i-1)*30)
    opt.BackgroundTransparency = 1
    opt.Text = mode
    opt.TextColor3 = Color3.fromRGB(255, 255, 255)
    opt.Font = Enum.Font.Gotham
    opt.TextSize = 13
    opt.Parent = targetDropdown
    opt.MouseButton1Click:Connect(function()
        config.TargetMode = mode
        targetBtn.Text = "Target: " .. mode
        targetDropdown.Visible = false
    end)
end

targetBtn.MouseButton1Click:Connect(function()
    targetDropdown.Visible = not targetDropdown.Visible
end)

-- ================= СТРАНИЦА НАСТРОЕК =================
local function makeSettingToggle(name, y, getter, setter)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 175, 0, 32)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Text = name .. ": " .. (getter() and "ON" or "OFF")
    btn.Parent = settingsPage
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = btn
    btn.MouseButton1Click:Connect(function()
        setter(not getter())
        btn.Text = name .. ": " .. (getter() and "ON" or "OFF")
    end)
    return btn
end

makeSettingToggle("Visible Check", 10, function() return config.VisibleCheck end, function(v) config.VisibleCheck = v end)
makeSettingToggle("Team Check", 50, function() return config.TeamCheck end, function(v) config.TeamCheck = v end)

-- Кнопка бинда
local bindBtn = Instance.new("TextButton")
bindBtn.Size = UDim2.new(0, 175, 0, 32)
bindBtn.Position = UDim2.new(0, 10, 0, 90)
bindBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
bindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
bindBtn.Font = Enum.Font.Gotham
bindBtn.TextSize = 13
bindBtn.Text = "Aim Bind: OFF"
bindBtn.Parent = settingsPage
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

-- Перетаскивание
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

-- RGB Подсветка
local hue = 0
RunService.RenderStepped:Connect(function(dt)
    hue = (hue + dt * 0.1) % 1
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

-- Включаем стартовую вкладку
navButtons[1].BackgroundColor3 = Color3.fromRGB(80, 80, 80)
switchPage("Aim")
