local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local HttpService = game:GetService("HttpService")

-- Твої дані GitHub
local user = "larinartom0-pixel"
local repo = "Test"
local rawUrl = "https://raw.githubusercontent.com/" .. user .. "/" .. repo .. "/main/"
local apiUrl = "https://api.github.com/repos/" .. user .. "/" .. repo .. "/contents/scripts"

-- Отримання версії та тексту оновлень
local onlineVersion = "1.0"
local changelogText = "Завантаження змін..."
pcall(function()
    onlineVersion = game:HttpGet(rawUrl .. "version.txt"):gsub("%s+", "")
    changelogText = game:HttpGet(rawUrl .. "changelog.txt")
end)

local Window = OrionLib:MakeWindow({
    Name = "🚀 lilhub | v" .. onlineVersion, 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "lilhub",
    IntroText = "lilhub"
})

--- ВКЛАДКА СКРИПТІВ ---
local ScriptsTab = Window:MakeTab({ Name = "Скрипти", Icon = "rbxassetid://4483345998" })

-- Автоматичне додавання кнопок з папки scripts
local function LoadScripts()
    local ok, response = pcall(function() return game:HttpGet(apiUrl) end)
    if ok then
        local files = HttpService:JSONDecode(response)
        for _, file in pairs(files) do
            if file.name:sub(-4) == ".lua" then
                ScriptsTab:AddButton({
                    Name = "🚀 " .. file.name:gsub(".lua", ""),
                    Callback = function()
                        loadstring(game:HttpGet(file.download_url))()
                    end
                })
            end
        end
    else
        -- Резервна кнопка на випадок збою API
        ScriptsTab:AddButton({
            Name = "Infinite Yield (Резерв)",
            Callback = function() loadstring(game:HttpGet(rawUrl .. "scripts/iy.lua"))() end
        })
    end
end
LoadScripts()

--- ВКЛАДКА ІНФОРМАЦІЇ ---
local InfoTab = Window:MakeTab({ Name = "Info", Icon = "rbxassetid://4483345998" })
InfoTab:AddLabel("Гравець: " .. game.Players.LocalPlayer.Name)
InfoTab:AddLabel("Версія: " .. onlineVersion)

InfoTab:AddSection({ Name = "Що нового" })
InfoTab:AddLabel(changelogText)

-- Кнопка перезапуску (просто завантажує заново)
InfoTab:AddButton({
    Name = "🔄 Перезапустити хаб",
    Callback = function()
        loadstring(game:HttpGet(rawUrl .. "main.lua"))()
    end
})

--- LIVE UPDATE (Перевірка раз на хвилину) ---
task.spawn(function()
    while task.wait(60) do
        local ok, newVer = pcall(function() return game:HttpGet(rawUrl .. "version.txt"):gsub("%s+", "") end)
        if ok and newVer ~= onlineVersion then
            OrionLib:MakeNotification({
                Name = "Оновлення!",
                Content = "Доступна версія " .. newVer .. ". Натисніть Перезапустити в Info.",
                Time = 10
            })
        end
    end
end)

OrionLib:Init()
