if not game:IsLoaded() then game.Loaded:Wait() end
_G.cfg = { 
    Aim = false, Fov = 150, Kill = true, 
    TargetPolice = false, TargetCriminals = false, TargetInmates = false, 
    Esp = false, EspNames = false, Fullbright = false,
    AutoPunch = false, FastReload = false,
    Speed = 27, JumpPower = 50, InfJump = false, Noclip = false,
    AimBind = false, JumpBind = false, PunchBind = false, EspBind = false, BrightBind = false
}

-- Загружаем UI
local uiCode = game:HttpGet("https://raw.githubusercontent.com/dolmotinecc300-lang/script2/refs/heads/main/ui.lua")
loadstring(uiCode)()

-- Ждем, пока UI создастся, и грузим движок
task.wait(0.5)
local engineCode = game:HttpGet("https://raw.githubusercontent.com/dolmotinecc300-lang/script2/refs/heads/main/engine.lua")
loadstring(engineCode)()

-- Грузим бинды
task.wait(0.2)
local bindsCode = game:HttpGet("https://raw.githubusercontent.com/dolmotinecc300-lang/script2/refs/heads/main/binds.lua")
loadstring(bindsCode)()
