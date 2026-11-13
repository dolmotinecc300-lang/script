if not game:IsLoaded() then game.Loaded:Wait() end
_G.cfg = { 
    Aim = false, Fov = 150, Kill = true, 
    TargetPolice = false, TargetCriminals = false, TargetInmates = false, 
    Esp = false, EspNames = false, Fullbright = false,
    AutoPunch = false, FastReload = false,
    Speed = 27, JumpPower = 50, InfJump = false, Noclip = false,
    AimBind = false, JumpBind = false, PunchBind = false, EspBind = false, BrightBind = false
}

local uiCode = game:HttpGet("https://raw.githubusercontent.com/dolmotinecc300-lang/script2/refs/heads/main/scripts/ui.lua")
loadstring(uiCode)()

task.wait(0.5)
local engineCode = game:HttpGet("https://raw.githubusercontent.com/dolmotinecc300-lang/script2/refs/heads/main/scripts/engine.lua")
loadstring(engineCode)()

task.wait(0.2)
local bindsCode = game:HttpGet("https://raw.githubusercontent.com/dolmotinecc300-lang/script2/refs/heads/main/scripts/binds.lua")
loadstring(bindsCode)()
