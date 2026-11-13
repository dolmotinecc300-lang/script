if not game:IsLoaded() then game.Loaded:Wait() end
local url = "https://raw.githubusercontent.com/dolmotinecc300-lang/script2/refs/heads/main/engine.lua"
local success, code = pcall(function() return game:HttpGet(url) end)
if success and code then
    local func = loadstring(code)
    if func then pcall(func) end
else
    warn("Не удалось загрузить движок. Проверь ссылку.")
end
