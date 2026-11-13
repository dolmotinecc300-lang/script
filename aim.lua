if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

_G.cfg = { Aim = false, Fov = 150, Bind = false, Esp = false, Kill = true, TargetPolice = false, TargetCriminals = false, TargetInmates = false, Speed = 27, InfJump = false, JumpBind = false, EspNames = false }
local cfg = _G.cfg
local bg, btn, act = Color3.fromRGB(20,45,70), Color3.fromRGB(45,85,115), Color3.fromRGB(80,150,190)

local pg = LocalPlayer:WaitForChild("PlayerGui")
if pg:FindFirstChild("AimGui") then pg.AimGui:Destroy() end
local gui = Instance.new("ScreenGui", pg)
gui.Name = "AimGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
_G.Gui = gui

local fov = Instance.new("Frame", gui)
fov.BackgroundTransparency = 1
fov.Size = UDim2.new(0, cfg.Fov * 2, 0, cfg.Fov * 2)
fov.Position = UDim2.new(0.5, -cfg.Fov, 0.5, -cfg.Fov)
Instance.new("UICorner", fov).CornerRadius = UDim.new(1,0)
local fovStroke = Instance.new("UIStroke", fov)
fovStroke.Color = Color3.fromRGB(255,0,0)
fovStroke.Thickness = 2

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

local pages, curPage = {}, nil
local function mkPage(name)
    local p = Instance.new("Frame", menu)
    p.Size = UDim2.new(1, 0, 1, -80)
    p.Position = UDim2.new(0, 0, 0, 80)
    p.BackgroundTransparency = 1
    p.Visible = false
    pages[name] = p
end
mkPage("Aim"); mkPage("ESP"); mkPage("Settings")
local function switch(name) if curPage then pages[curPage].Visible = false end; curPage = name; pages[name].Visible = true end

local navs = {}
local function mkNav(txt, x, pName)
    local b = Instance.new("TextButton", menu)
    b.Size = UDim2.new(0, 50, 0, 50)
    b.Position = UDim2.new(0, x, 0, 30)
    b.BackgroundColor3 = btn
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 24
    b.Text = txt
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function()
        for _, navBtn in pairs(navs) do navBtn.BackgroundColor3 = btn end
        b.BackgroundColor3 = act
        switch(pName)
    end)
    table.insert(navs, b)
end
mkNav("🎯", 10, "Aim"); mkNav("👁️", 70, "ESP"); mkNav("⚙️", 130, "Settings")

local aimB = Instance.new("TextButton", pages.Aim)
aimB.Size = UDim2.new(0, 175, 0, 32)
aimB.Position = UDim2.new(0, 10, 0, 10)
aimB.BackgroundColor3 = btn
aimB.TextColor3 = Color3.new(1,1,1)
aimB.Font = Enum.Font.Gotham
aimB.TextSize = 13
aimB.Text = "Aim: OFF"
Instance.new("UICorner", aimB).CornerRadius = UDim.new(0, 6)
aimB.MouseButton1Click:Connect(function() cfg.Aim = not cfg.Aim; aimB.Text = "Aim: " .. (cfg.Aim and "ON" or "OFF") end)

local fovBg = Instance.new("Frame", pages.Aim)
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
    fov.Size = UDim2.new(0, v*2, 0, v*2)
    fov.Position = UDim2.new(0.5, -v, 0.5, -v)
end
fovBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then dragF = true; updFov(i) end end)
UserInputService.InputChanged:Connect(function(i) if dragF and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then updFov(i) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then dragF = false end end)

local killB = Instance.new("TextButton", pages.Aim)
killB.Size = UDim2.new(0, 175, 0, 32)
killB.Position = UDim2.new(0, 10, 0, 110)
killB.BackgroundColor3 = btn
killB.TextColor3 = Color3.new(1,1,1)
killB.Font = Enum.Font.Gotham
killB.TextSize = 13
killB.Text = "Kill Check: ON"
Instance.new("UICorner", killB).CornerRadius = UDim.new(0, 6)
killB.MouseButton1Click:Connect(function() cfg.Kill = not cfg.Kill; killB.Text = "Kill Check: " .. (cfg.Kill and "ON" or "OFF") end)

local tgtB = Instance.new("TextButton", pages.Aim)
tgtB.Size = UDim2.new(0, 175, 0, 32)
tgtB.Position = UDim2.new(0, 195, 0, 110)
tgtB.BackgroundColor3 = btn
tgtB.TextColor3 = Color3.new(1,1,1)
tgtB.Font = Enum.Font.Gotham
tgtB.TextSize = 13
tgtB.Text = "Targets"
Instance.new("UICorner", tgtB).CornerRadius = UDim.new(0, 6)

local drop = Instance.new("Frame", pages.Aim)
drop.Size = UDim2.new(0, 175, 0, 100)
drop.Position = UDim2.new(0, 195, 0, 146)
drop.BackgroundColor3 = bg
drop.Visible = false
Instance.new("UICorner", drop).CornerRadius = UDim.new(0, 6)

local function updateTargetText()
    local txt = "Targets"
    if cfg.TargetPolice or cfg.TargetCriminals or cfg.TargetInmates then
        txt = "Targets: "
        if cfg.TargetPolice then txt = txt .. "P " end
        if cfg.TargetCriminals then txt = txt .. "C " end
        if cfg.TargetInmates then txt = txt .. "I" end
    end
    tgtB.Text = txt
end

local function mkTargetOpt(name, key, yPos)
    local opt = Instance.new("TextButton", drop)
    opt.Size = UDim2.new(1, 0, 0, 30)
    opt.Position = UDim2.new(0, 0, 0, yPos)
    opt.BackgroundTransparency = 1
    opt.Text = "[ ] " .. name
    opt.TextColor3 = Color3.new(1,1,1)
    opt.Font = Enum.Font.Gotham
    opt.TextSize = 13
    opt.TextXAlignment = Enum.TextXAlignment.Left
    opt.MouseButton1Click:Connect(function()
        cfg[key] = not cfg[key]
        opt.Text = (cfg[key] and "[X] " or "[ ] ") .. name
        updateTargetText()
    end)
end
mkTargetOpt("Police", "TargetPolice", 0)
mkTargetOpt("Criminals", "TargetCriminals", 30)
mkTargetOpt("Inmates", "TargetInmates", 60)
tgtB.MouseButton1Click:Connect(function() drop.Visible = not drop.Visible end)

local espB = Instance.new("TextButton", pages.ESP)
espB.Size = UDim2.new(0, 175, 0, 32)
espB.Position = UDim2.new(0, 10, 0, 10)
espB.BackgroundColor3 = btn
espB.TextColor3 = Color3.new(1,1,1)
espB.Font = Enum.Font.Gotham
espB.TextSize = 13
espB.Text = "ESP: OFF"
Instance.new("UICorner", espB).CornerRadius = UDim.new(0, 6)
espB.MouseButton1Click:Connect(function() cfg.Esp = not cfg.Esp; espB.Text = "ESP: " .. (cfg.Esp and "ON" or "OFF") end)

local nickVisibleB = Instance.new("TextButton", pages.ESP)
nickVisibleB.Size = UDim2.new(0, 175, 0, 32)
nickVisibleB.Position = UDim2.new(0, 10, 0, 50)
nickVisibleB.BackgroundColor3 = btn
nickVisibleB.TextColor3 = Color3.new(1,1,1)
nickVisibleB.Font = Enum.Font.Gotham
nickVisibleB.TextSize = 13
nickVisibleB.Text = "Nick Visible: OFF"
Instance.new("UICorner", nickVisibleB).CornerRadius = UDim.new(0, 6)
nickVisibleB.MouseButton1Click:Connect(function() cfg.EspNames = not cfg.EspNames; nickVisibleB.Text = "Nick Visible: " .. (cfg.EspNames and "ON" or "OFF") end)

local szB = Instance.new("TextButton", pages.Settings)
szB.Size = UDim2.new(0, 175, 0, 32)
szB.Position = UDim2.new(0, 10, 0, 10)
szB.BackgroundColor3 = btn
szB.TextColor3 = Color3.new(1,1,1)
szB.Font = Enum.Font.Gotham
szB.TextSize = 13
szB.Text = "Menu Size: 1.0"
Instance.new("UICorner", szB).CornerRadius = UDim.new(0, 6)
local szs = {1.0, 0.8, 1.2, 1.5}
local szI = 1
szB.MouseButton1Click:Connect(function() szI = szI % #szs + 1; local ns = szs[szI]; menu.Size = UDim2.new(0, 380*ns, 0, 300*ns); szB.Text = "Menu Size: " .. ns end)

local bindB = Instance.new("TextButton", pages.Settings)
bindB.Size = UDim2.new(0, 175, 0, 32)
bindB.Position = UDim2.new(0, 10, 0, 50)
bindB.BackgroundColor3 = btn
bindB.TextColor3 = Color3.new(1,1,1)
bindB.Font = Enum.Font.Gotham
bindB.TextSize = 13
bindB.Text = "Aim Bind: OFF"
Instance.new("UICorner", bindB).CornerRadius = UDim.new(0, 6)

local infJumpBtn = Instance.new("TextButton", pages.Settings)
infJumpBtn.Size = UDim2.new(0, 175, 0, 32)
infJumpBtn.Position = UDim2.new(0, 10, 0, 90)
infJumpBtn.BackgroundColor3 = btn
infJumpBtn.TextColor3 = Color3.new(1,1,1)
infJumpBtn.Font = Enum.Font.Gotham
infJumpBtn.TextSize = 13
infJumpBtn.Text = "Inf Jump: OFF"
Instance.new("UICorner", infJumpBtn).CornerRadius = UDim.new(0, 6)

local jumpBindBtn = Instance.new("TextButton", pages.Settings)
jumpBindBtn.Size = UDim2.new(0, 175, 0, 32)
jumpBindBtn.Position = UDim2.new(0, 10, 0, 130)
jumpBindBtn.BackgroundColor3 = btn
jumpBindBtn.TextColor3 = Color3.new(1,1,1)
jumpBindBtn.Font = Enum.Font.Gotham
jumpBindBtn.TextSize = 13
jumpBindBtn.Text = "Jump Bind: OFF"
Instance.new("UICorner", jumpBindBtn).CornerRadius = UDim.new(0, 6)

local spdTxt = Instance.new("TextLabel", pages.Settings)
spdTxt.Size = UDim2.new(0, 175, 0, 20)
spdTxt.Position = UDim2.new(0, 10, 0, 175)
spdTxt.BackgroundTransparency = 1
spdTxt.Text = "Speed (16-30):"
spdTxt.TextColor3 = Color3.new(1,1,1)
spdTxt.Font = Enum.Font.Gotham
spdTxt.TextSize = 13
spdTxt.TextXAlignment = Enum.TextXAlignment.Left

local spdInp = Instance.new("TextBox", pages.Settings)
spdInp.Size = UDim2.new(0, 80, 0, 30)
spdInp.Position = UDim2.new(0, 195, 0, 170)
spdInp.BackgroundColor3 = btn
spdInp.TextColor3 = Color3.new(1,1,1)
spdInp.Font = Enum.Font.Gotham
spdInp.TextSize = 13
spdInp.Text = tostring(cfg.Speed)
spdInp.PlaceholderText = "16-30"
Instance.new("UICorner", spdInp).CornerRadius = UDim.new(0, 6)

-- Исправленная функция скорости
local function applySpd(v)
    v = math.clamp(tonumber(v) or 16, 16, 30)
    cfg.Speed = v
    spdInp.Text = tostring(v)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = v
    end
end
spdInp.FocusLost:Connect(function()
    applySpd(spdInp.Text)
end)

local fBind = Instance.new("TextButton", gui)
fBind.Size = UDim2.new(0, 90, 0, 45)
fBind.Position = UDim2.new(0.5, 60, 0.85, 0)
fBind.BackgroundColor3 = Color3.fromRGB(200,40,40)
fBind.TextColor3 = Color3.new(1,1,1)
fBind.Font = Enum.Font.GothamBold
fBind.TextSize = 16
fBind.Text = "AIM OFF"
fBind.Visible = false
Instance.new("UICorner", fBind).CornerRadius = UDim.new(0, 10)

local jBind = Instance.new("TextButton", gui)
jBind.Size = UDim2.new(0, 90, 0, 45)
jBind.Position = UDim2.new(0.5, -150, 0.85, 0)
jBind.BackgroundColor3 = Color3.fromRGB(200,40,40)
jBind.TextColor3 = Color3.new(1,1,1)
jBind.Font = Enum.Font.GothamBold
jBind.TextSize = 16
jBind.Text = "JUMP OFF"
jBind.Visible = false
Instance.new("UICorner", jBind).CornerRadius = UDim.new(0, 10)

bindB.MouseButton1Click:Connect(function() cfg.Bind = not cfg.Bind; bindB.Text = "Aim Bind: " .. (cfg.Bind and "ON" or "OFF"); fBind.Visible = cfg.Bind end)
fBind.MouseButton1Click:Connect(function() cfg.Aim = not cfg.Aim; fBind.Text = cfg.Aim and "AIM ON" or "AIM OFF"; fBind.BackgroundColor3 = cfg.Aim and Color3.fromRGB(40,200,40) or Color3.fromRGB(200,40,40) end)

infJumpBtn.MouseButton1Click:Connect(function()
    cfg.InfJump = not cfg.InfJump
    infJumpBtn.Text = "Inf Jump: " .. (cfg.InfJump and "ON" or "OFF")
    if cfg.JumpBind then
        jBind.Text = cfg.InfJump and "JUMP ON" or "JUMP OFF"
        jBind.BackgroundColor3 = cfg.InfJump and Color3.fromRGB(40,200,40) or Color3.fromRGB(200,40,40)
    end
end)

jumpBindBtn.MouseButton1Click:Connect(function()
    cfg.JumpBind = not cfg.JumpBind
    jumpBindBtn.Text = "Jump Bind: " .. (cfg.JumpBind and "ON" or "OFF")
    jBind.Visible = cfg.JumpBind
    if cfg.JumpBind then
        jBind.Text = cfg.InfJump and "JUMP ON" or "JUMP OFF"
        jBind.BackgroundColor3 = cfg.InfJump and Color3.fromRGB(40,200,40) or Color3.fromRGB(200,40,40)
    end
end)

jBind.MouseButton1Click:Connect(function()
    cfg.InfJump = not cfg.InfJump
    infJumpBtn.Text = "Inf Jump: " .. (cfg.InfJump and "ON" or "OFF")
    jBind.Text = cfg.InfJump and "JUMP ON" or "JUMP OFF"
    jBind.BackgroundColor3 = cfg.InfJump and Color3.fromRGB(40,200,40) or Color3.fromRGB(200,40,40)
end)

local function mkDrag(f, t)
    local d, s, p = false, nil, nil
    f.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then d, s, p = true, i.Position, t.Position end end)
    f.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then local df = i.Position - s; t.Position = UDim2.new(p.X.Scale, p.X.Offset + df.X, p.Y.Scale, p.Y.Offset + df.Y) end end)
    f.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
end
mkDrag(title, menu); mkDrag(fBind, fBind); mkDrag(jBind, jBind); mkDrag(open, open)

local pal = {Color3.fromRGB(0,200,255), Color3.fromRGB(0,100,255), Color3.fromRGB(0,50,150), Color3.fromRGB(0,150,255), Color3.fromRGB(20,80,200)}
local ci, ct = 1, 0
RunService.RenderStepped:Connect(function(dt)
    local ni = ci % #pal + 1
    ct = ct + dt * 0.8
    if ct >= 1 then ct = 0; ci = ni end
    local fc = pal[ci]:Lerp(pal[ni], ct)
    ms.Color = fc; os.Color = fc; fovFill.BackgroundColor3 = fc
    local pulse = (math.sin(tick() * 2) + 1) / 2
    local activeColor = fc:Lerp(Color3.new(1,1,1), 0.3 * pulse)
    if cfg.Aim then aimB.BackgroundColor3 = activeColor else aimB.BackgroundColor3 = btn end
    if cfg.Kill then killB.BackgroundColor3 = activeColor else killB.BackgroundColor3 = btn end
    if cfg.Esp then espB.BackgroundColor3 = activeColor else espB.BackgroundColor3 = btn end
    if cfg.Bind then bindB.BackgroundColor3 = activeColor else bindB.BackgroundColor3 = btn end
    if cfg.InfJump then infJumpBtn.BackgroundColor3 = activeColor else infJumpBtn.BackgroundColor3 = btn end
    if cfg.JumpBind then jumpBindBtn.BackgroundColor3 = activeColor else jumpBindBtn.BackgroundColor3 = btn end
    if cfg.EspNames then nickVisibleB.BackgroundColor3 = activeColor else nickVisibleB.BackgroundColor3 = btn end
end)

navs[1].BackgroundColor3 = act
switch("Aim")

-- ЗАГРУЗКА ДВИЖКА
task.wait(0.2)
local engineUrl = "https://raw.githubusercontent.com/dolmotinecc300-lang/script2/refs/heads/main/engine.lua"
local success, code = pcall(function() return game:HttpGet(engineUrl) end)
if success and code then
    local func = loadstring(code)
    if func then pcall(func) end
end
