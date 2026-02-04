local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local HttpService = game:GetService("HttpService")

local user = "larinartom0-pixel"
local repo = "Test"
local rawUrl = "https://raw.githubusercontent.com/" .. user .. "/" .. repo .. "/main/"
local scriptsFolderUrl = rawUrl .. "scripts/"
local apiUrl = "https://api.github.com/repos/" .. user .. "/" .. repo .. "/contents/scripts"

-- 1. Завантаження Changelog
local changelogText = "Не вдалося завантажити список змін."
pcall(function()
    changelogText = game:HttpGet(scriptsFolderUrl .. "changelog.txt")
end)

local Window = OrionLib:MakeWindow({
    Name = "🚀 lilhub | v1.0", -- Версія тепер просто текстом
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "lilhub",
    IntroText = "lilhub"
})

--- ВКЛАДКА СКРИПТІВ ---
local ScriptsTab = Window:MakeTab({ Name = "Скрипти", Icon = "rbxassetid://4483345998" })

local function LoadScripts()
    local ok, response = pcall(function() return game:HttpGet(apiUrl) end)
    if ok then
        local files = HttpService:JSONDecode(response)
        for _, file in pairs(files) do
            -- Додаємо тільки .lua файли (music.lua з'явиться тут автоматично)
            if file.name:sub(-4) == ".lua" then
                ScriptsTab:AddButton({
                    Name = "🚀 " .. file.name:gsub(".lua", ""),
                    Callback = function()
                        loadstring(game:HttpGet(file.download_url))()
                    end
                })
            end
        end
    end
end
LoadScripts()

--- ВКЛАДКА ІНФОРМАЦІЇ ---
local InfoTab = Window:MakeTab({ Name = "Info", Icon = "rbxassetid://4483345998" })
InfoTab:AddLabel("Гравець: " .. game.Players.LocalPlayer.Name)
InfoTab:AddSection({ Name = "Що нового" })
InfoTab:AddLabel(changelogText) -- Тут буде текст із твого файлу

-- Кнопка перезапуску
InfoTab:AddButton({
    Name = "🔄 Перезапустити хаб",
    Callback = function()
        loadstring(game:HttpGet(rawUrl .. "main.lua"))()
    end
})

OrionLib:Init()
        for _, file in pairs(files) do
            -- Додаємо кнопку тільки якщо це .lua файл
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
        -- Резерв, якщо API не відповідає
        ScriptsTab:AddButton({
            Name = "Запустити Music (Резерв)",
            Callback = function() loadstring(game:HttpGet(scriptsFolderUrl .. "music.lua"))() end
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

-- Кнопка перезапуску
InfoTab:AddButton({
    Name = "🔄 Перезапустити хаб",
    Callback = function()
        loadstring(game:HttpGet(rawUrl .. "main.lua"))()
    end
})

OrionLib:Init()
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
