if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local cfg = { Aim = false, Fov = 150, Bind = false, Esp = false, Kill = true, TargetPolice = false, TargetCriminals = false, TargetInmates = false, Speed = 27, InfJump = false, JumpBind = false, EspNames = false }
local bg, btn, act = Color3.fromRGB(20,45,70), Color3.fromRGB(45,85,115), Color3.fromRGB(80,150,190)

-- ================= DRAWING API =================
local menuOpen = true
local menuX, menuY = 20, 60
local menuW, menuH = 380, 300
local curPage = "Aim"

local elements = {}

local function newText(pos, size, text, color, visible)
    local t = Drawing.new("Text")
    t.Position = pos
    t.Size = size
    t.Text = text
    t.Color = color or Color3.new(1,1,1)
    t.Visible = visible ~= false
    t.Center = false
    t.Outline = true
    table.insert(elements, t)
    return t
end

local function newSquare(pos, size, color, filled, visible)
    local s = Drawing.new("Square")
    s.Position = pos
    s.Size = size
    s.Color = color or Color3.new(1,1,1)
    s.Filled = filled ~= false
    s.Visible = visible ~= false
    s.Thickness = 1
    table.insert(elements, s)
    return s
end

local function newLine(from, to, color, visible)
    local l = Drawing.new("Line")
    l.From = from
    l.To = to
    l.Color = color or Color3.new(1,1,1)
    l.Thickness = 1
    l.Visible = visible ~= false
    table.insert(elements, l)
    return l
end

-- Фон меню
local bgSquare = newSquare(Vector2.new(menuX, menuY), Vector2.new(menuW, menuH), bg, true, true)
local borderLine = newSquare(Vector2.new(menuX, menuY), Vector2.new(menuW, menuH), act, false, true)

-- Заголовок
local titleText = newText(Vector2.new(menuX + 10, menuY + 8), 16, "Aim Menu", Color3.new(1,1,1), true)
local closeText = newText(Vector2.new(menuX + menuW - 25, menuY + 8), 18, "X", Color3.fromRGB(255,80,80), true)

-- Вкладки (рисуем как текст)
local navAim = newText(Vector2.new(menuX + 10, menuY + 40), 20, "🎯", Color3.new(1,1,1), true)
local navEsp = newText(Vector2.new(menuX + 70, menuY + 40), 20, "👁️", Color3.new(1,1,1), true)
local navSet = newText(Vector2.new(menuX + 130, menuY + 40), 20, "⚙️", Color3.new(1,1,1), true)

-- Кнопки Аима
local aimBtn = newText(Vector2.new(menuX + 10, menuY + 80), 14, "Aim: OFF", Color3.new(1,1,1), true)
local fovTxt = newText(Vector2.new(menuX + 10, menuY + 110), 12, "FOV: 150", Color3.new(1,1,1), true)
local killBtn = newText(Vector2.new(menuX + 10, menuY + 140), 14, "Kill: ON", Color3.new(1,1,1), true)
local tgtBtn = newText(Vector2.new(menuX + 10, menuY + 170), 14, "Targets", Color3.new(1,1,1), true)

-- Кнопки ESP
local espBtn = newText(Vector2.new(menuX + 10, menuY + 80), 14, "ESP: OFF", Color3.new(1,1,1), false)
local nickBtn = newText(Vector2.new(menuX + 10, menuY + 110), 14, "Nick: OFF", Color3.new(1,1,1), false)

-- Кнопки настроек
local bindBtn = newText(Vector2.new(menuX + 10, menuY + 80), 14, "Aim Bind: OFF", Color3.new(1,1,1), false)
local jumpBtn = newText(Vector2.new(menuX + 10, menuY + 110), 14, "Inf Jump: OFF", Color3.new(1,1,1), false)
local jumpBindBtn = newText(Vector2.new(menuX + 10, menuY + 140), 14, "Jump Bind: OFF", Color3.new(1,1,1), false)
local spdTxt = newText(Vector2.new(menuX + 10, menuY + 170), 12, "Speed: 27", Color3.new(1,1,1), false)

-- Обновление видимости элементов в зависимости от вкладки
local function updateVisibility()
    local isAim = curPage == "Aim"
    local isEsp = curPage == "ESP"
    local isSet = curPage == "Settings"

    aimBtn.Visible = isAim
    fovTxt.Visible = isAim
    killBtn.Visible = isAim
    tgtBtn.Visible = isAim

    espBtn.Visible = isEsp
    nickBtn.Visible = isEsp

    bindBtn.Visible = isSet
    jumpBtn.Visible = isSet
    jumpBindBtn.Visible = isSet
    spdTxt.Visible = isSet
end

updateVisibility()

-- ================= ЛОГИКА КЛИКОВ =================
-- Поскольку Drawing не обрабатывает клики, мы используем UserInputService и проверяем попадание в координаты текста

local function isInside(pos, x, y, w, h)
    return pos.X >= x and pos.X <= x + w and pos.Y >= y and pos.Y <= y + h
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        local pos = input.Position
        if not menuOpen then return end

        -- Закрытие
        if isInside(pos, menuX + menuW - 30, menuY + 5, 25, 25) then
            menuOpen = false
            bgSquare.Visible = false
            borderLine.Visible = false
            titleText.Visible = false
            closeText.Visible = false
            for _, el in ipairs(elements) do
                if el ~= bgSquare and el ~= borderLine and el ~= titleText and el ~= closeText then
                    el.Visible = false
                end
            end
            return
        end

        -- Переключение вкладок
        if isInside(pos, menuX + 10, menuY + 40, 50, 40) then curPage = "Aim"; updateVisibility(); return end
        if isInside(pos, menuX + 70, menuY + 40, 50, 40) then curPage = "ESP"; updateVisibility(); return end
        if isInside(pos, menuX + 130, menuY + 40, 50, 40) then curPage = "Settings"; updateVisibility(); return end

        -- Клики по кнопкам (в зависимости от вкладки)
        if curPage == "Aim" then
            if isInside(pos, menuX + 10, menuY + 80, 150, 20) then
                cfg.Aim = not cfg.Aim
                aimBtn.Text = "Aim: " .. (cfg.Aim and "ON" or "OFF")
                aimBtn.Color = cfg.Aim and Color3.fromRGB(40,200,40) or Color3.new(1,1,1)
            elseif isInside(pos, menuX + 10, menuY + 140, 150, 20) then
                cfg.Kill = not cfg.Kill
                killBtn.Text = "Kill: " .. (cfg.Kill and "ON" or "OFF")
            elseif isInside(pos, menuX + 10, menuY + 170, 150, 20) then
                if cfg.TargetPolice and cfg.TargetCriminals and cfg.TargetInmates then
                    cfg.TargetPolice, cfg.TargetCriminals, cfg.TargetInmates = false, false, false
                elseif not cfg.TargetPolice and not cfg.TargetCriminals and not cfg.TargetInmates then
                    cfg.TargetPolice = true
                elseif cfg.TargetPolice and not cfg.TargetCriminals and not cfg.TargetInmates then
                    cfg.TargetPolice = false; cfg.TargetCriminals = true
                elseif not cfg.TargetPolice and cfg.TargetCriminals and not cfg.TargetInmates then
                    cfg.TargetCriminals = false; cfg.TargetInmates = true
                else
                    cfg.TargetPolice, cfg.TargetCriminals, cfg.TargetInmates = false, false, false
                end
                tgtBtn.Text = "Targets: " .. (cfg.TargetPolice and "P " or "") .. (cfg.TargetCriminals and "C " or "") .. (cfg.TargetInmates and "I" or "")
            end
        elseif curPage == "ESP" then
            if isInside(pos, menuX + 10, menuY + 80, 150, 20) then
                cfg.Esp = not cfg.Esp
                espBtn.Text = "ESP: " .. (cfg.Esp and "ON" or "OFF")
                espBtn.Color = cfg.Esp and Color3.fromRGB(40,200,40) or Color3.new(1,1,1)
            elseif isInside(pos, menuX + 10, menuY + 110, 150, 20) then
                cfg.EspNames = not cfg.EspNames
                nickBtn.Text = "Nick: " .. (cfg.EspNames and "ON" or "OFF")
                nickBtn.Color = cfg.EspNames and Color3.fromRGB(40,200,40) or Color3.new(1,1,1)
            end
        elseif curPage == "Settings" then
            if isInside(pos, menuX + 10, menuY + 80, 150, 20) then
                cfg.Bind = not cfg.Bind
                bindBtn.Text = "Aim Bind: " .. (cfg.Bind and "ON" or "OFF")
            elseif isInside(pos, menuX + 10, menuY + 110, 150, 20) then
                cfg.InfJump = not cfg.InfJump
                jumpBtn.Text = "Inf Jump: " .. (cfg.InfJump and "ON" or "OFF")
            elseif isInside(pos, menuX + 10, menuY + 140, 150, 20) then
                cfg.JumpBind = not cfg.JumpBind
                jumpBindBtn.Text = "Jump Bind: " .. (cfg.JumpBind and "ON" or "OFF")
            end
        end
    end
end)

-- ================= ЛОГИКА ИГРЫ =================

local function getCol(p)
    local n = (p.Team and p.Team.Name:lower()) or ""
    if n:find("guard") or n:find("cop") or n:find("police") then return Color3.fromRGB(0,100,255) end
    if n:find("criminal") or n:find("prisoner") then return Color3.fromRGB(255,0,0) end
    if n:find("inmate") or n:find("prison") then return Color3.fromRGB(0,255,0) end
    return Color3.new(1,1,1)
end

local function setupP(p)
    if p == LocalPlayer then return end
    local function a()
        if not p.Character then return end
        local o = p.Character:FindFirstChild("ESP_Highlight")
        if o then o:Destroy() end
        local h = Instance.new("Highlight", p.Character)
        h.Name = "ESP_Highlight"
        h.FillColor = getCol(p)
        h.OutlineColor = Color3.new(1,1,1)
        h.FillTransparency = 0.3
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Enabled = cfg.Esp

        local head = p.Character:FindFirstChild("Head")
        if head then
            local oldBb = head:FindFirstChild("ESP_Name")
            if oldBb then oldBb:Destroy() end
            local bb = Instance.new("BillboardGui", head)
            bb.Name = "ESP_Name"
            bb.Size = UDim2.new(0, 100, 0, 20)
            bb.StudsOffset = Vector3.new(0, 1.5, 0)
            bb.AlwaysOnTop = true
            bb.Enabled = cfg.EspNames
            local txt = Instance.new("TextLabel", bb)
            txt.Size = UDim2.new(1, 0, 1, 0)
            txt.BackgroundTransparency = 1
            txt.Text = p.Name
            txt.TextColor3 = getCol(p)
            txt.TextStrokeTransparency = 0
            txt.Font = Enum.Font.GothamBold
            txt.TextSize = 12
        end
    end
    p.CharacterAdded:Connect(function() task.wait(1); a() end)
    if p.Character then a() end
end
Players.PlayerAdded:Connect(setupP)
for _, p in ipairs(Players:GetPlayers()) do setupP(p) end

local function isVis(part)
    if not cfg.Kill then return true end
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = {LocalPlayer.Character, part.Parent}
    return workspace:Raycast(Camera.CFrame.Position, part.Position - Camera.CFrame.Position, rp) == nil
end

LocalPlayer.CharacterAdded:Connect(function(c) task.wait(1); local h = c:FindFirstChild("Humanoid"); if h then h.WalkSpeed = cfg.Speed end end)
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = cfg.Speed end

UserInputService.JumpRequest:Connect(function()
    if cfg.InfJump then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    -- Аим
    if cfg.Aim and cfg.Bind then
        local b, bd = nil, cfg.Fov
        local c = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("Head")
                local hu = p.Character:FindFirstChild("Humanoid")
                if h and hu then
                    local vh = true
                    if cfg.Kill and hu.Health <= 0 then vh = false end
                    if vh then
                        local n = (p.Team and p.Team.Name:lower()) or ""
                        local vm = false
                        if cfg.TargetPolice and (n:find("guard") or n:find("cop") or n:find("police")) then vm = true end
                        if cfg.TargetCriminals and (n:find("criminal") or n:find("prisoner")) then vm = true end
                        if cfg.TargetInmates and (n:find("inmate") or n:find("prison")) then vm = true end
                        
                        if vm then
                            local sp, on = Camera:WorldToViewportPoint(h.Position)
                            if on then
                                local d = (Vector2.new(sp.X, sp.Y) - c).Magnitude
                                if d < bd and isVis(h) then bd = d; b = h end
                            end
                        end
                    end
                end
            end
        end
        if b then Camera.CFrame = CFrame.new(Camera.CFrame.Position, b.Position) end
    end

    -- ESP и ники
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("ESP_Highlight")
            if h then 
                h.Enabled = cfg.Esp
                if cfg.Esp then h.FillColor = getCol(p) end 
            end
            local head = p.Character:FindFirstChild("Head")
            local theirRoot = p.Character:FindFirstChild("HumanoidRootPart")
            if head and myRoot and theirRoot then
                local bb = head:FindFirstChild("ESP_Name")
                if bb then
                    local dist = (theirRoot.Position - myRoot.Position).Magnitude
                    bb.Enabled = cfg.EspNames and dist >= 500
                    if bb.Enabled then bb.TextLabel.TextColor3 = getCol(p) end
                end
            end
        end
    end
end)

-- FOV круг (Drawing)
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.NumSides = 100
fovCircle.Radius = cfg.Fov
fovCircle.Filled = false
fovCircle.Color = act
fovCircle.Visible = true
fovCircle.ZIndex = 999
fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

RunService.RenderStepped:Connect(function()
    fovCircle.Radius = cfg.Fov
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
end)
