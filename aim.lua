local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local config = {
    AimEnabled = false,
    FOVRadius = 150,
    AimBind = false,
    ESPEnabled = false,
    VisibleCheck = true,
    TeamCheck = true,
    TargetMode = "All",
}

local targetModes = {"All", "Police", "Criminals", "Inmates"}
local bgColor = Color3.fromRGB(20, 35, 50)
local btnColor = Color3.fromRGB(30, 50, 70)
local btnActiveColor = Color3.fromRGB(50, 80, 110)

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

local fov = Instance.new("Frame")
fov.BackgroundTransparency = 1
fov.Size = UDim2.new(0, config.FOVRadius * 2, 0, config.FOVRadius * 2)
fov.Position = UDim2.new(0.5, -config.FOVRadius, 0.5, -config.FOVRadius)
fov.Parent = gui
Instance.new("UICorner", fov).CornerRadius = UDim.new(1, 0)
local stroke = Instance.new("UIStroke", fov)
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Thickness = 2

local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 380, 0, 260)
menu.Position = UDim2.new(0, 20, 0, 60)
menu.BackgroundColor3 = bgColor
menu.Parent = gui
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 14)
local mstroke = Instance.new("UIStroke", menu)
mstroke.Thickness = 2

local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, -40, 0, 35)
title.BackgroundTransparency = 1
title.Text = "Aim Menu"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local closeBtn = Instance.new("TextButton", menu)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 2)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 45, 0, 45)
openBtn.Position = UDim2.new(0, 20, 0, 60)
openBtn.BackgroundColor3 = bgColor
openBtn.Text = "A"
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 20
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)
local obstroke = Instance.new("UIStroke", openBtn)
obstroke.Thickness = 2
openBtn.Visible = false

closeBtn.MouseButton1Click:Connect(function() menu.Visible = false; openBtn.Visible = true end)
openBtn.MouseButton1Click:Connect(function() menu.Visible = true; openBtn.Visible = false end)

local pages = {}
local currentPage = nil
local function createPage(name)
    local p = Instance.new("Frame", menu)
    p.Size = UDim2.new(1, 0, 1, -80)
    p.Position = UDim2.new(0, 0, 0, 80)
    p.BackgroundTransparency = 1
    p.Visible = false
    pages[name] = p
    return p
end

local aimPage = createPage("Aim")
local espPage = createPage("ESP")
local settingsPage = createPage("Settings")

local function switchPage(name)
    if currentPage then pages[currentPage].Visible = false end
    currentPage = name
    pages[name].Visible = true
end

local navButtons = {}
local function makeNavButton(text, x, pageName)
    local btn = Instance.new("TextButton", menu)
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = UDim2.new(0, x, 0, 30)
    btn.BackgroundColor3 = btnColor
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 24
    btn.Text = text
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(navButtons) do b.BackgroundColor3 = btnColor end
        btn.BackgroundColor3 = btnActiveColor
        switchPage(pageName)
    end)
    table.insert(navButtons, btn)
end

makeNavButton("🎯", 10, "Aim")
makeNavButton("👁️", 70, "ESP")
makeNavButton("⚙️", 130, "Settings")

local aimBtn = Instance.new("TextButton", aimPage)
aimBtn.Size = UDim2.new(0, 175, 0, 32)
aimBtn.Position = UDim2.new(0, 10, 0, 10)
aimBtn.BackgroundColor3 = btnColor
aimBtn.TextColor3 = Color3.new(1,1,1)
aimBtn.Font = Enum.Font.Gotham
aimBtn.TextSize = 13
aimBtn.Text = "Aim: OFF"
Instance.new("UICorner", aimBtn).CornerRadius = UDim.new(0, 6)
aimBtn.MouseButton1Click:Connect(function()
    config.AimEnabled = not config.AimEnabled
    aimBtn.Text = "Aim: " .. (config.AimEnabled and "ON" or "OFF")
end)

local fovBg = Instance.new("Frame", aimPage)
fovBg.Size = UDim2.new(0, 350, 0, 10)
fovBg.Position = UDim2.new(0, 10, 0, 65)
fovBg.BackgroundColor3 = Color3.fromRGB(40, 60, 80)
Instance.new("UICorner", fovBg).CornerRadius = UDim.new(1, 0)

local fovFill = Instance.new("Frame", fovBg)
fovFill.Size = UDim2.new(config.FOVRadius / 360, 0, 1, 0)
fovFill.BackgroundColor3 = btnActiveColor
Instance.new("UICorner", fovFill).CornerRadius = UDim.new(1, 0)

local fovKnob = Instance.new("Frame", fovBg)
fovKnob.Size = UDim2.new(0, 20, 0, 20)
fovKnob.Position = UDim2.new(config.FOVRadius / 360, -10, 0.5, -10)
fovKnob.BackgroundColor3 = Color3.new(1,1,1)
Instance.new("UICorner", fovKnob).CornerRadius = UDim.new(1, 0)

local isDragging = false
local function updateSlider(input)
    local relX = math.clamp(input.Position.X - fovBg.AbsolutePosition.X, 0, fovBg.AbsoluteSize.X)
    local val = math.floor((relX / fovBg.AbsoluteSize.X) * 360)
    config.FOVRadius = val
    fovFill.Size = UDim2.new(val / 360, 0, 1, 0)
    fovKnob.Position = UDim2.new(val / 360, -10, 0.5, -10)
    fov.Size = UDim2.new(0, val * 2, 0, val * 2)
    fov.Position = UDim2.new(0.5, -val, 0.5, -val)
end

fovBg.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true; updateSlider(i)
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if isDragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
        updateSlider(i)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

local teamBtn = Instance.new("TextButton", aimPage)
teamBtn.Size = UDim2.new(0, 175, 0, 32)
teamBtn.Position = UDim2.new(0, 10, 0, 110)
teamBtn.BackgroundColor3 = btnColor
teamBtn.TextColor3 = Color3.new(1,1,1)
teamBtn.Font = Enum.Font.Gotham
teamBtn.TextSize = 13
teamBtn.Text = "Team Check: ON"
Instance.new("UICorner", teamBtn).CornerRadius = UDim.new(0, 6)
teamBtn.MouseButton1Click:Connect(function()
    config.TeamCheck = not config.TeamCheck
    teamBtn.Text = "Team Check: " .. (config.TeamCheck and "ON" or "OFF")
end)

local targetBtn = Instance.new("TextButton", aimPage)
targetBtn.Size = UDim2.new(0, 175, 0, 32)
targetBtn.Position = UDim2.new(0, 195, 0, 110)
targetBtn.BackgroundColor3 = btnColor
targetBtn.TextColor3 = Color3.new(1,1,1)
targetBtn.Font = Enum.Font.Gotham
targetBtn.TextSize = 13
targetBtn.Text = "Target: All"
Instance.new("UICorner", targetBtn).CornerRadius = UDim.new(0, 6)

local dropdown = Instance.new("Frame", aimPage)
dropdown.Size = UDim2.new(0, 175, 0, 120)
dropdown.Position = UDim2.new(0, 195, 0, 146)
dropdown.BackgroundColor3 = bgColor
dropdown.Visible = false
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

for i, mode in ipairs(targetModes) do
    local opt = Instance.new("TextButton", dropdown)
    opt.Size = UDim2.new(1, 0, 0, 30)
    opt.Position = UDim2.new(0, 0, 0, (i-1)*30)
    opt.BackgroundTransparency = 1
    opt.Text = mode
    opt.TextColor3 = Color3.new(1,1,1)
    opt.Font = Enum.Font.Gotham
    opt.TextSize = 13
    opt.MouseButton1Click:Connect(function()
        config.TargetMode = mode
        targetBtn.Text = "Target: " .. mode
        dropdown.Visible = false
    end)
end
targetBtn.MouseButton1Click:Connect(function() dropdown.Visible = not dropdown.Visible end)

local espBtn = Instance.new("TextButton", espPage)
espBtn.Size = UDim2.new(0, 175, 0, 32)
espBtn.Position = UDim2.new(0, 10, 0, 10)
espBtn.BackgroundColor3 = btnColor
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.Font = Enum.Font.Gotham
espBtn.TextSize = 13
espBtn.Text = "ESP: OFF"
Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0, 6)
espBtn.MouseButton1Click:Connect(function()
    config.ESPEnabled = not config.ESPEnabled
    espBtn.Text = "ESP: " .. (config.ESPEnabled and "ON" or "OFF")
end)

local sizeBtn = Instance.new("TextButton", settingsPage)
sizeBtn.Size = UDim2.new(0, 175, 0, 32)
sizeBtn.Position = UDim2.new(0, 10, 0, 10)
sizeBtn.BackgroundColor3 = btnColor
sizeBtn.TextColor3 = Color3.new(1,1,1)
sizeBtn.Font = Enum.Font.Gotham
sizeBtn.TextSize = 13
sizeBtn.Text = "Menu Size: 1.0"
Instance.new("UICorner", sizeBtn).CornerRadius = UDim.new(0, 6)
local sizes = {1.0, 0.8, 1.2, 1.5}
local sizeIdx = 1
sizeBtn.MouseButton1Click:Connect(function()
    sizeIdx = sizeIdx % #sizes + 1
    local ns = sizes[sizeIdx]
    menu.Size = UDim2.new(0, 380 * ns, 0, 260 * ns)
    sizeBtn.Text = "Menu Size: " .. ns
end)

local bindBtn = Instance.new("TextButton", settingsPage)
bindBtn.Size = UDim2.new(0, 175, 0, 32)
bindBtn.Position = UDim2.new(0, 10, 0, 50)
bindBtn.BackgroundColor3 = btnColor
bindBtn.TextColor3 = Color3.new(1,1,1)
bindBtn.Font = Enum.Font.Gotham
bindBtn.TextSize = 13
bindBtn.Text = "Aim Bind: OFF"
Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0, 6)

local floatBind = Instance.new("TextButton", gui)
floatBind.Size = UDim2.new(0, 90, 0, 45)
floatBind.Position = UDim2.new(0.5, 60, 0.85, 0)
floatBind.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
floatBind.TextColor3 = Color3.new(1,1,1)
floatBind.Font = Enum.Font.GothamBold
floatBind.TextSize = 16
floatBind.Text = "AIM OFF"
floatBind.Visible = false
Instance.new("UICorner", floatBind).CornerRadius = UDim.new(0, 10)

bindBtn.MouseButton1Click:Connect(function()
    config.AimBind = not config.AimBind
    bindBtn.Text = "Aim Bind: " .. (config.AimBind and "ON" or "OFF")
    floatBind.Visible = config.AimBind
end)
floatBind.MouseButton1Click:Connect(function()
    config.AimEnabled = not config.AimEnabled
    floatBind.Text = config.AimEnabled and "AIM ON" or "AIM OFF"
    floatBind.BackgroundColor3 = config.AimEnabled and Color3.fromRGB(40, 200, 40) or Color3.fromRGB(200, 40, 40)
end)

local function makeDraggable(frame, target)
    local dragging, dragStart, startPos = false, nil, nil
    frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging, dragStart, startPos = true, i.Position, target.Position
        end
    end)
    frame.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
            local d = i.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    frame.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end
makeDraggable(title, menu)
makeDraggable(floatBind, floatBind)
makeDraggable(openBtn, openBtn)

local hue = 0
RunService.RenderStepped:Connect(function(dt)
    hue = (hue + dt * 0.1) % 1
    local c = Color3.fromHSV(hue, 1, 1)
    mstroke.Color = c
    obstroke.Color = c
end)

local function getColor(p)
    local n = (p.Team and p.Team.Name:lower()) or ""
    if n:find("guard") or n:find("cop") or n:find("police") then return Color3.fromRGB(0, 100, 255) end
    if n:find("criminal") or n:find("prisoner") then return Color3.fromRGB(255, 0, 0) end
    if n:find("inmate") or n:find("prison") then return Color3.fromRGB(0, 255, 0) end
    if p.TeamColor == BrickColor.new("Really blue") then return Color3.fromRGB(0, 100, 255) end
    if p.TeamColor == BrickColor.new("Really red") then return Color3.fromRGB(255, 0, 0) end
    if p.TeamColor == BrickColor.new("Bright green") then return Color3.fromRGB(0, 255, 0) end
    return Color3.new(1,1,1)
end

local function setupPlayer(p)
    if p == LocalPlayer then return end
    local function apply()
        if not p.Character then return end
        local old = p.Character:FindFirstChild("ESP_Highlight")
        if old then old:Destroy() end
        local h = Instance.new("Highlight", p.Character)
        h.Name = "ESP_Highlight"
        h.FillColor = getColor(p)
        h.OutlineColor = Color3.new(1,1,1)
        h.FillTransparency = 0.3
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Enabled = config.ESPEnabled
    end
    p.CharacterAdded:Connect(function() task.wait(1); apply() end)
    if p.Character then apply() end
end
Players.PlayerAdded:Connect(setupPlayer)
for _, p in ipairs(Players:GetPlayers()) do setupPlayer(p) end

local function isVisible(part)
    if not config.VisibleCheck then return true end
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = {LocalPlayer.Character, part.Parent}
    local res = workspace:Raycast(Camera.CFrame.Position, part.Position - Camera.CFrame.Position, rp)
    return res == nil
end

RunService.RenderStepped:Connect(function()
    if config.AimEnabled and config.AimBind then
        local best, bestDist = nil, config.FOVRadius
        local c = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local head = p.Character:FindFirstChild("Head")
                local hum = p.Character:FindFirstChild("Humanoid")
                if head and hum and hum.Health > 0 then
                    if config.TeamCheck and p.Team == LocalPlayer.Team then continue end
                    local n = (p.Team and p.Team.Name:lower()) or ""
                    local valid = false
                    if config.TargetMode == "All" then valid = true
                    elseif config.TargetMode == "Police" and (n:find("guard") or n:find("cop") or n:find("police")) then valid = true
                    elseif config.TargetMode == "Criminals" and (n:find("criminal") or n:find("prisoner")) then valid = true
                    elseif config.TargetMode == "Inmates" and (n:find("inmate") or n:find("prison")) then valid = true end
                    
                    if valid then
                        local sp, on = Camera:WorldToViewportPoint(head.Position)
                        if on then
                            local d = (Vector2.new(sp.X, sp.Y) - c).Magnitude
                            if d < bestDist and isVisible(head) then bestDist = d; best = head end
                        end
                    end
                end
            end
        end
        if best then Camera.CFrame = CFrame.new(Camera.CFrame.Position, best.Position) end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("ESP_Highlight")
            if h then
                h.Enabled = config.ESPEnabled
                if config.ESPEnabled then h.FillColor = getColor(p) end
            end
        end
    end
end)

navButtons[1].BackgroundColor3 = btnActiveColor
switchPage("Aim")
