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
    ESPEnabled = false,
}

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
menu.Size = UDim2.new(0, 220, 0, 320)
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

-- Заголовок меню (за него таскаем)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Aim Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = menu

-- Кнопка закрытия (Крестик)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.ZIndex = 5
closeBtn.Parent = menu

-- Круглая кнопка открытия (А)
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 45, 0, 45)
openBtn.Position = UDim2.new(0, 20, 0, 60)
openBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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
makeToggle("ESP", 120, function() return config.ESPEnabled end, function(v) config.ESPEnabled = v end)

local bindBtn = Instance.new("TextButton")
bindBtn.Size = UDim2.new(1, -20, 0, 34)
bindBtn.Position = UDim2.new(0, 10, 0, 160)
bindBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
bindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
bindBtn.Font = Enum.Font.Gotham
bindBtn.TextSize = 14
bindBtn.Text = "Aim Bind: OFF"
bindBtn.Parent = menu
local bbc = Instance.new("UICorner")
bbc.CornerRadius = UDim.new(0, 6)
bbc.Parent = bindBtn

-- Плавающая кнопка бинда
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
colorBtn.Size = UDim2.new(1, -20, 0, 34)
colorBtn.Position = UDim2.new(0, 10, 0, 200)
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
    obstroke.Color = config.FOVColor
end)

local radiusSlider = Instance.new("TextButton")
radiusSlider.Size = UDim2.new(1, -20, 0, 34)
radiusSlider.Position = UDim2.new(0, 10, 0, 240)
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

-- Функция перетаскивания (с блокировкой экрана)
local function makeDraggable(frame, target)
    local dragging = false
    local dragInput, dragStart, startPos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
            -- Блокируем движение камеры, пока таскаем
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
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

-- Таскаем только за заголовок и за сами кнопки
makeDraggable(title, menu)
makeDraggable(floatBind, floatBind)
makeDraggable(openBtn, openBtn)

-- ESP Логика
local espFolder = Instance.new("Folder")
espFolder.Name = "ESP"
espFolder.Parent = gui

local espCache = {}

local function getTeamColor(player)
    local char = player.Character
    if not char then return Color3.new(1,1,1) end
    local team = player.Team
    if team then
        local n = team.Name:lower()
        if n:find("guard") or n:find("cop") or n:find("police") then
            return Color3.fromRGB(0, 100, 255) -- Полиция - Синий
        elseif n:find("criminal") or n:find("prisoner") then
            return Color3.fromRGB(255, 0, 0) -- Преступники - Красный
        elseif n:find("inmate") or n:find("prison") then
            return Color3.fromRGB(0, 255, 0) -- Заключенные - Зеленый
        end
    end
    if player.TeamColor then
        if player.TeamColor == BrickColor.new("Really blue") then return Color3.fromRGB(0, 100, 255) end
        if player.TeamColor == BrickColor.new("Really red") then return Color3.fromRGB(255, 0, 0) end
        if player.TeamColor == BrickColor.new("Bright green") then return Color3.fromRGB(0, 255, 0) end
    end
    return Color3.new(1, 1, 1)
end

local function createESP(player)
    if player == LocalPlayer then return end
    local box = Instance.new("Frame")
    box.Name = player.Name
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Parent = espFolder
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Parent = box
    
    local nameTag = Instance.new("TextLabel")
    nameTag.Size = UDim2.new(1, 0, 0, 15)
    nameTag.Position = UDim2.new(0, 0, -1, -5)
    nameTag.BackgroundTransparency = 1
    nameTag.Text = player.Name
    nameTag.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameTag.TextStrokeTransparency = 0
    nameTag.Font = Enum.Font.GothamBold
    nameTag.TextSize = 12
    nameTag.Parent = box
    
    espCache[player] = {box = box, stroke = stroke}
end

local function removeESP(player)
    if espCache[player] then
        espCache[player].box:Destroy()
        espCache[player] = nil
    end
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)
for _, p in ipairs(Players:GetPlayers()) do createESP(p) end

-- Основной цикл
RunService.RenderStepped:Connect(function()
    -- Аим
    if config.AimEnabled and config.AimBind then
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
        if best then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, best.Position)
        end
    end

    -- ESP Отрисовка
    for player, data in pairs(espCache) do
        local box = data.box
        local char = player.Character
        if config.ESPEnabled and char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChild("Humanoid")
            if hrp and head and hum and hum.Health > 0 then
                local headPos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local feetPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                if onScreen and headPos.Z > 0 then
                    local height = math.abs(headPos.Y - feetPos.Y)
                    local width = height / 2
                    box.Size = UDim2.new(0, width, 0, height)
                    box.Position = UDim2.new(0, headPos.X - width/2, 0, headPos.Y)
                    box.Visible = true
                    data.stroke.Color = getTeamColor(player)
                else
                    box.Visible = false
                end
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end
end)
