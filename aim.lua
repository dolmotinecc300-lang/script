local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local cfg = { Aim = false, Fov = 150, Bind = false, Esp = false, Kill = true, Target = "All", Speed = 16 }
local modes = {"All", "Police", "Criminals", "Inmates"}
local bg, btn, act = Color3.fromRGB(20,45,70), Color3.fromRGB(30,60,90), Color3.fromRGB(50,100,140)

local pg = LocalPlayer:WaitForChild("PlayerGui")
if pg:FindFirstChild("AimGui") then pg.AimGui:Destroy() end
local gui = Instance.new("ScreenGui", pg)
gui.Name = "AimGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

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
        for _, navBtn in pairs(navs) do
            navBtn.BackgroundColor3 = btn
        end
        b.BackgroundColor3 = act
        switch(pName)
    end)
    table.insert(navs, b)
end
mkNav("🎯", 10, "Aim"); mkNav("👁️", 70, "ESP"); mkNav("⚙️", 130, "Settings")

-- СТРАНИЦА AIM
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
tgtB.Text = "Target: All"
Instance.new("UICorner", tgtB).CornerRadius = UDim.new(0, 6)

local drop = Instance.new("Frame", pages.Aim)
drop.Size = UDim2.new(0, 175, 0, 120)
drop.Position = UDim2.new(0, 195, 0, 146)
drop.BackgroundColor3 = bg
drop.Visible = false
Instance.new("UICorner", drop).CornerRadius = UDim.new(0, 6)

for i, m in ipairs(modes) do
    local o = Instance.new("TextButton", drop)
    o.Size = UDim2.new(1, 0, 0, 30)
    o.Position = UDim2.new(0, 0, 0, (i-1)*30)
    o.BackgroundTransparency = 1
    o.Text = m
    o.TextColor3 = Color3.new(1,1,1)
    o.Font = Enum.Font.Gotham
    o.TextSize = 13
    o.MouseButton1Click:Connect(function() cfg.Target = m; tgtB.Text = "Target: " .. m; drop.Visible = false end)
end
tgtB.MouseButton1Click:Connect(function() drop.Visible = not drop.Visible end)

-- СТРАНИЦА ESP
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

-- СТРАНИЦА НАСТРОЕК
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

local spdBg = Instance.new("Frame", pages.Settings)
spdBg.Size = UDim2.new(0, 350, 0, 10)
spdBg.Position = UDim2.new(0, 10, 0, 105)
spdBg.BackgroundColor3 = Color3.fromRGB(30,60,90)
Instance.new("UICorner", spdBg).CornerRadius = UDim.new(1,0)
local spdFill = Instance.new("Frame", spdBg)
spdFill.Size = UDim2.new((cfg.Speed-16)/14, 0, 1, 0)
spdFill.BackgroundColor3 = act
Instance.new("UICorner", spdFill).CornerRadius = UDim.new(1,0)
local spdKnob = Instance.new("Frame", spdBg)
spdKnob.Size = UDim2.new(0, 20, 0, 20)
spdKnob.Position = UDim2.new((cfg.Speed-16)/14, -10, 0.5, -10)
spdKnob.BackgroundColor3 = Color3.new(1,1,1)
Instance.new("UICorner", spdKnob).CornerRadius = UDim.new(1,0)

local spdTxt = Instance.new("TextLabel", pages.Settings)
spdTxt.Size = UDim2.new(0, 175, 0, 20)
spdTxt.Position = UDim2.new(0, 10, 0, 85)
spdTxt.BackgroundTransparency = 1
spdTxt.Text = "Speed: " .. cfg.Speed
spdTxt.TextColor3 = Color3.new(1,1,1)
spdTxt.Font = Enum.Font.Gotham
spdTxt.TextSize = 13
spdTxt.TextXAlignment = Enum.TextXAlignment.Left

local spdInp = Instance.new("TextBox", pages.Settings)
spdInp.Size = UDim2.new(0, 80, 0, 30)
spdInp.Position = UDim2.new(0, 195, 0, 85)
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
    spdTxt.Text = "Speed: " .. v
    spdFill.Size = UDim2.new((v-16)/14, 0, 1, 0)
    spdKnob.Position = UDim2.new((v-16)/14, -10, 0.5, -10)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = v end
end
spdInp.FocusLost:Connect(function() applySpd(spdInp.Text) end)

local dragS = false
local function updSpd(inp)
    local rX = math.clamp(inp.Position.X - spdBg.AbsolutePosition.X, 0, spdBg.AbsoluteSize.X)
    applySpd(math.floor((rX/spdBg.AbsoluteSize.X)*14 + 16))
end
spdBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then dragS = true; updSpd(i) end end)
UserInputService.InputChanged:Connect(function(i) if dragS and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then updSpd(i) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then dragS = false end end)

LocalPlayer.CharacterAdded:Connect(function(c) task.wait(1); local h = c:FindFirstChild("Humanoid"); if h then h.WalkSpeed = cfg.Speed end end)
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = cfg.Speed end

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

bindB.MouseButton1Click:Connect(function() cfg.Bind = not cfg.Bind; bindB.Text = "Aim Bind: " .. (cfg.Bind and "ON" or "OFF"); fBind.Visible = cfg.Bind end)
fBind.MouseButton1Click:Connect(function()
    cfg.Aim = not cfg.Aim
    fBind.Text = cfg.Aim and "AIM ON" or "AIM OFF"
    fBind.BackgroundColor3 = cfg.Aim and Color3.fromRGB(40,200,40) or Color3.fromRGB(200,40,40)
end)

local function mkDrag(f, t)
    local d, s, p = false, nil, nil
    f.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then d, s, p = true, i.Position, t.Position end end)
    f.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then local df = i.Position - s; t.Position = UDim2.new(p.X.Scale, p.X.Offset + df.X, p.Y.Scale, p.Y.Offset + df.Y) end end)
    f.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
end
mkDrag(title, menu); mkDrag(fBind, fBind); mkDrag(open, open)

local pal = {Color3.fromRGB(0,200,255), Color3.fromRGB(0,100,255), Color3.fromRGB(0,50,150), Color3.fromRGB(0,150,255), Color3.fromRGB(20,80,200)}
local ci, ct = 1, 0
RunService.RenderStepped:Connect(function(dt)
    local ni = ci % #pal + 1
    ct = ct + dt * 0.5
    if ct >= 1 then ct = 0; ci = ni end
    local fc = pal[ci]:Lerp(pal[ni], ct)
    ms.Color = fc; os.Color = fc; fovFill.BackgroundColor3 = fc; spdFill.BackgroundColor3 = fc
end)

local function getCol(p)
    local n = (p.Team and p.Team.Name:lower()) or ""
    if n:find("guard") or n:find("cop") or n:find("police") then return Color3.fromRGB(0,100,255) end
    if n:find("criminal") or n:find("prisoner") then return Color3.fromRGB(255,0,0) end
    if n:find("inmate") or n:find("prison") then return Color3.fromRGB(0,255,0) end
    if p.TeamColor == BrickColor.new("Really blue") then return Color3.fromRGB(0,100,255) end
    if p.TeamColor == BrickColor.new("Really red") then return Color3.fromRGB(255,0,0) end
    if p.TeamColor == BrickColor.new("Bright green") then return Color3.fromRGB(0,255,0) end
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

RunService.RenderStepped:Connect(function()
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
                        if cfg.Target == "All" then vm = true
                        elseif cfg.Target == "Police" and (n:find("guard") or n:find("cop") or n:find("police")) then vm = true
                        elseif cfg.Target == "Criminals" and (n:find("criminal") or n:find("prisoner")) then vm = true
                        elseif cfg.Target == "Inmates" and (n:find("inmate") or n:find("prison")) then vm = true end
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

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("ESP_Highlight")
            if h then h.Enabled = cfg.Esp; if cfg.Esp then h.FillColor = getCol(p) end end
        end
    end
end)

navs[1].BackgroundColor3 = act
switch("Aim")
