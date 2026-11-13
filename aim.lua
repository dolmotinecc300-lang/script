if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local cfg = { Aim = false, Fov = 150, Bind = false, Esp = false, Kill = true, TargetPolice = false, TargetCriminals = false, TargetInmates = false, Speed = 27, InfJump = false, JumpBind = false, EspNames = false }
local bg, btn, act = Color3.fromRGB(20,45,70), Color3.fromRGB(45,85,115), Color3.fromRGB(80,150,190)

local pg = LocalPlayer:WaitForChild("PlayerGui")
if pg:FindFirstChild("AimGui") then pg.AimGui:Destroy() end
local gui = Instance.new("ScreenGui", pg)
gui.Name = "AimGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- Главное меню (создается сразу)
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, 380, 0, 300)
menu.Position = UDim2.new(0, 20, 0, 60)
menu.BackgroundColor3 = bg
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 14)
local ms = Instance.new("UIStroke", menu)
ms.Thickness = 2

local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, -40, 0, 35)
title.BackgroundTransparency = 1
title.Text = "Aim Menu"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local close = Instance.new("TextButton", menu)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 2)
close.BackgroundTransparency = 1
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 80, 80)
close.Font = Enum.Font.GothamBold
close.TextSize = 18

local open = Instance.new("TextButton", gui)
open.Size = UDim2.new(0, 45, 0, 45)
open.Position = UDim2.new(0, 20, 0, 60)
open.BackgroundColor3 = bg
open.Text = "A"
open.TextColor3 = Color3.new(1,1,1)
open.Font = Enum.Font.GothamBold
open.TextSize = 20
Instance.new("UICorner", open).CornerRadius = UDim.new(1,0)
local os = Instance.new("UIStroke", open)
os.Thickness = 2
open.Visible = false

close.MouseButton1Click:Connect(function() menu.Visible = false; open.Visible = true end)
open.MouseButton1Click:Connect(function() menu.Visible = true; open.Visible = false end)

-- Панель для контента (создается сразу, но пустая)
local contentFrame = Instance.new("Frame", menu)
contentFrame.Size = UDim2.new(1, 0, 1, -80)
contentFrame.Position = UDim2.new(0, 0, 0, 80)
contentFrame.BackgroundTransparency = 1

-- Функция очистки контента
local function clearContent()
    for _, child in ipairs(contentFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
end

-- Навигационные кнопки (создаются сразу)
local navFrame = Instance.new("Frame", menu)
navFrame.Size = UDim2.new(1, 0, 0, 50)
navFrame.Position = UDim2.new(0, 0, 0, 30)
navFrame.BackgroundTransparency = 1

local navAim = Instance.new("TextButton", navFrame)
navAim.Size = UDim2.new(0, 50, 0, 50)
navAim.Position = UDim2.new(0, 10, 0, 0)
navAim.BackgroundColor3 = btn
navAim.Text = "🎯"
navAim.TextColor3 = Color3.new(1,1,1)
navAim.Font = Enum.Font.Gotham
navAim.TextSize = 24
Instance.new("UICorner", navAim).CornerRadius = UDim.new(0, 8)

local navEsp = Instance.new("TextButton", navFrame)
navEsp.Size = UDim2.new(0, 50, 0, 50)
navEsp.Position = UDim2.new(0, 70, 0, 0)
navEsp.BackgroundColor3 = btn
navEsp.Text = "👁️"
navEsp.TextColor3 = Color3.new(1,1,1)
navEsp.Font = Enum.Font.Gotham
navEsp.TextSize = 24
Instance.new("UICorner", navEsp).CornerRadius = UDim.new(0, 8)

local navSet = Instance.new("TextButton", navFrame)
navSet.Size = UDim2.new(0, 50, 0, 50)
navSet.Position = UDim2.new(0, 130, 0, 0)
navSet.BackgroundColor3 = btn
navSet.Text = "⚙️"
navSet.TextColor3 = Color3.new(1,1,1)
navSet.Font = Enum.Font.Gotham
navSet.TextSize = 24
Instance.new("UICorner", navSet).CornerRadius = UDim.new(0, 8)

-- Функции создания страниц (ленивая загрузка)
local function loadAimPage()
    clearContent()
    navAim.BackgroundColor3 = act
    
    -- Кнопка Aim
    local aimB = Instance.new("TextButton", contentFrame)
    aimB.Size = UDim2.new(0, 175, 0, 32)
    aimB.Position = UDim2.new(0, 10, 0, 10)
    aimB.BackgroundColor3 = btn
    aimB.TextColor3 = Color3.new(1,1,1)
    aimB.Font = Enum.Font.Gotham
    aimB.TextSize = 13
    aimB.Text = "Aim: " .. (cfg.Aim and "ON" or "OFF")
    Instance.new("UICorner", aimB).CornerRadius = UDim.new(0, 6)
    aimB.MouseButton1Click:Connect(function()
        cfg.Aim = not cfg.Aim
        aimB.Text = "Aim: " .. (cfg.Aim and "ON" or "OFF")
        aimB.BackgroundColor3 = cfg.Aim and act or btn
    end)
    
    -- FOV ползунок
    local fovBg = Instance.new("Frame", contentFrame)
    fovBg.Size = UDim2.new(0, 350, 0, 10)
    fovBg.Position = UDim2.new(0, 10, 0, 65)
    fovBg.BackgroundColor3 = Color3.fromRGB(30,60,90)
    Instance.new("UICorner", fovBg).CornerRadius = UDim.new(1,0)
    local fovFill = Instance.new("Frame", fovBg)
    fovFill.Size = UDim2.new(cfg.Fov/360, 0, 1, 0)
    fovFill.BackgroundColor3 = act
    Instance.new("UICorner", fovFill).CornerRadius = UDim.new(1,0)
    local fovKnob = Instance.new("Frame", fovBg)
    fovKnob.Size = UDim2.new(0, 20, 0, 20)
    fovKnob.Position = UDim2.new(cfg.Fov/360, -10, 0.5, -10)
    fovKnob.BackgroundColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", fovKnob).CornerRadius = UDim.new(1,0)

    local dragF = false
    local function updFov(inp)
        local rX = math.clamp(inp.Position.X - fovBg.AbsolutePosition.X, 0, fovBg.AbsoluteSize.X)
        local v = math.floor((rX/fovBg.AbsoluteSize.X)*360)
        cfg.Fov = v
        fovFill.Size = UDim2.new(v/360, 0, 1, 0)
        fovKnob.Position = UDim2.new(v/360, -10, 0.5, -10)
    end
    fovBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then dragF = true; updFov(i) end end)
    UserInputService.InputChanged:Connect(function(i) if dragF and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then updFov(i) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then dragF = false end end)

    -- Kill Check
    local killB = Instance.new("TextButton", contentFrame)
    killB.Size = UDim2.new(0, 175, 0, 32)
    killB.Position = UDim2.new(0, 10, 0, 110)
    killB.BackgroundColor3 = btn
    killB.TextColor3 = Color3.new(1,1,1)
    killB.Font = Enum.Font.Gotham
    killB.TextSize = 13
    killB.Text = "Kill: " .. (cfg.Kill and "ON" or "OFF")
    Instance.new("UICorner", killB).CornerRadius = UDim.new(0, 6)
    killB.MouseButton1Click:Connect(function()
        cfg.Kill = not cfg.Kill
        killB.Text = "Kill: " .. (cfg.Kill and "ON" or "OFF")
        killB.BackgroundColor3 = cfg.Kill and act or btn
    end)
    
    -- Targets
    local tgtB = Instance.new("TextButton", contentFrame)
    tgtB.Size = UDim2.new(0, 175, 0, 32)
    tgtB.Position = UDim2.new(0, 195, 0, 110)
    tgtB.BackgroundColor3 = btn
    tgtB.TextColor3 = Color3.new(1,1,1)
    tgtB.Font = Enum.Font.Gotham
    tgtB.TextSize = 13
    tgtB.Text = "Targets: " .. (cfg.TargetPolice and "P " or "") .. (cfg.TargetCriminals and "C " or "") .. (cfg.TargetInmates and "I" or "")
    Instance.new("UICorner", tgtB).CornerRadius = UDim.new(0, 6)
    tgtB.MouseButton1Click:Connect(function()
        if not cfg.TargetPolice and not cfg.TargetCriminals and not cfg.TargetInmates then
            cfg.TargetPolice = true
        elseif cfg.TargetPolice and not cfg.TargetCriminals and not cfg.TargetInmates then
            cfg.TargetPolice = false; cfg.TargetCriminals = true
        elseif not cfg.TargetPolice and cfg.TargetCriminals and not cfg.TargetInmates then
            cfg.TargetCriminals = false; cfg.TargetInmates = true
        else
            cfg.TargetPolice, cfg.TargetCriminals, cfg.TargetInmates = false, false, false
        end
        tgtB.Text = "Targets: " .. (cfg.TargetPolice and "P " or "") .. (cfg.TargetCriminals and "C " or "") .. (cfg.TargetInmates and "I" or "")
    end)
end

local function loadEspPage()
    clearContent()
    navEsp.BackgroundColor3 = act
    
    local espB = Instance.new("TextButton", contentFrame)
    espB.Size = UDim2.new(0, 175, 0, 32)
    espB.Position = UDim2.new(0, 10, 0, 10)
    espB.BackgroundColor3 = btn
    espB.TextColor3 = Color3.new(1,1,1)
    espB.Font = Enum.Font.Gotham
    espB.TextSize = 13
    espB.Text = "ESP: " .. (cfg.Esp and "ON" or "OFF")
    Instance.new("UICorner", espB).CornerRadius = UDim.new(0, 6)
    espB.MouseButton1Click:Connect(function()
        cfg.Esp = not cfg.Esp
        espB.Text = "ESP: " .. (cfg.Esp and "ON" or "OFF")
        espB.BackgroundColor3 = cfg.Esp and act or btn
    end)
    
    local nickB = Instance.new("TextButton", contentFrame)
    nickB.Size = UDim2.new(0, 175, 0, 32)
    nickB.Position = UDim2.new(0, 10, 0, 50)
    nickB.BackgroundColor3 = btn
    nickB.TextColor3 = Color3.new(1,1,1)
    nickB.Font = Enum.Font.Gotham
    nickB.TextSize = 13
    nickB.Text = "Nick: " .. (cfg.EspNames and "ON" or "OFF")
    Instance.new("UICorner", nickB).CornerRadius = UDim.new(0, 6)
    nickB.MouseButton1Click:Connect(function()
        cfg.EspNames = not cfg.EspNames
        nickB.Text = "Nick: " .. (cfg.EspNames and "ON" or "OFF")
        nickB.BackgroundColor3 = cfg.EspNames and act or btn
    end)
end

local function loadSettingsPage()
    clearContent()
    navSet.BackgroundColor3 = act
    
    local bindB = Instance.new("TextButton", contentFrame)
    bindB.Size = UDim2.new(0, 175, 0, 32)
    bindB.Position = UDim2.new(0, 10, 0, 10)
    bindB.BackgroundColor3 = btn
    bindB.TextColor3 = Color3.new(1,1,1)
    bindB.Font = Enum.Font.Gotham
    bindB.TextSize = 13
    bindB.Text = "Aim Bind: " .. (cfg.Bind and "ON" or "OFF")
    Instance.new("UICorner", bindB).CornerRadius = UDim.new(0, 6)
    bindB.MouseButton1Click:Connect(function()
        cfg.Bind = not cfg.Bind
        bindB.Text = "Aim Bind: " .. (cfg.Bind and "ON" or "OFF")
        bindB.BackgroundColor3 = cfg.Bind and act or btn
    end)
    
    local jumpB = Instance.new("TextButton", contentFrame)
    jumpB.Size = UDim2.new(0, 175, 0, 32)
    jumpB.Position = UDim2.new(0, 10, 0, 50)
    jumpB.BackgroundColor3 = btn
    jumpB.TextColor3 = Color3.new(1,1,1)
    jumpB.Font = Enum.Font.Gotham
    jumpB.TextSize = 13
    jumpB.Text = "Inf Jump: " .. (cfg.InfJump and "ON" or "OFF")
    Instance.new("UICorner", jumpB).CornerRadius = UDim.new(0, 6)
    jumpB.MouseButton1Click:Connect(function()
        cfg.InfJump = not cfg.InfJump
        jumpB.Text = "Inf Jump: " .. (cfg.InfJump and "ON" or "OFF")
        jumpB.BackgroundColor3 = cfg.InfJump and act or btn
    end)
    
    local spdTxt = Instance.new("TextLabel", contentFrame)
    spdTxt.Size = UDim2.new(0, 175, 0, 20)
    spdTxt.Position = UDim2.new(0, 10, 0, 95)
    spdTxt.BackgroundTransparency = 1
    spdTxt.Text = "Speed (16-30):"
    spdTxt.TextColor3 = Color3.new(1,1,1)
    spdTxt.Font = Enum.Font.Gotham
    spdTxt.TextSize = 13
    spdTxt.TextXAlignment = Enum.TextXAlignment.Left
    
    local spdInp = Instance.new("TextBox", contentFrame)
    spdInp.Size = UDim2.new(0, 80, 0, 30)
    spdInp.Position = UDim2.new(0, 195, 0, 90)
    spdInp.BackgroundColor3 = btn
    spdInp.TextColor3 = Color3.new(1,1,1)
    spdInp.Font = Enum.Font.Gotham
    spdInp.TextSize = 13
    spdInp.Text = tostring(cfg.Speed)
    spdInp.PlaceholderText = "16-30"
    Instance.new("UICorner", spdInp).CornerRadius = UDim.new(0, 6)
    
    local function applySpd(v)
        v = math.clamp(tonumber(v) or 16, 16, 30)
        cfg.Speed = v
        spdInp.Text = tostring(v)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = v end
    end
    spdInp.FocusLost:Connect(function() applySpd(spdInp.Text) end)
end

-- Навешиваем переключение вкладок
navAim.MouseButton1Click:Connect(loadAimPage)
navEsp.MouseButton1Click:Connect(loadEspPage)
navSet.MouseButton1Click:Connect(loadSettingsPage)

-- Загружаем первую страницу
loadAimPage()

-- Подсветка и бинды (создаются сразу)
local pal = {Color3.fromRGB(0,200,255), Color3.fromRGB(0,100,255), Color3.fromRGB(0,50,150), Color3.fromRGB(0,150,255), Color3.fromRGB(20,80,200)}
local ci, ct = 1, 0
RunService.RenderStepped:Connect(function(dt)
    local ni = ci % #pal + 1
    ct = ct + dt * 0.8
    if ct >= 1 then ct = 0; ci = ni end
    local fc = pal[ci]:Lerp(pal[ni], ct)
    ms.Color = fc; os.Color = fc
end)

-- Логика игры (без изменений)
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
