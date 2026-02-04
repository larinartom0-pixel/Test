local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local rawUrl = "https://raw.githubusercontent.com/larinartom0-pixel/Test/main/"
local onlineVersion = game:HttpGet(rawUrl .. "version.txt")

local Window = Rayfield:CreateWindow({
   Name = "🚀 lilhub | v" .. onlineVersion,
   LoadingTitle = "Завантаження конфігурації...",
   LoadingSubtitle = "by Larinssk",
   ConfigurationSaving = { Enabled = true, FolderName = "lilhub_configs", FileName = "Main" }
})

-- Вкладка зі скриптами з Гітхабу
local ScriptsTab = Window:CreateTab("Скрипти", 4483362458)

local function AddOnlineScript(btnName, fileName)
    ScriptsTab:CreateButton({
        Name = btnName,
        Callback = function()
            loadstring(game:HttpGet(rawUrl .. "scripts/" .. fileName))()
        end,
    })
end

-- Додаємо твій iy.lua
AddOnlineScript("Infinite Yield", "iy.lua")

-- Вкладка Info
local InfoTab = Window:CreateTab("User Info", 4483362458)
InfoTab:CreateLabel("Користувач: " .. game.Players.LocalPlayer.Name)
InfoTab:CreateLabel("Версія: " .. onlineVersion)

Rayfield:Notify({Title = "lilhub", Content = "Хаб успішно підключено!", Duration = 3})
