-- Повний фікс для main.lua
local success, Rayfield = pcall(function() 
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))() 
end)

if not success or not Rayfield then 
    warn("Rayfield не завантажився!") 
    return 
end

local HttpService = game:GetService("HttpService")
local user = "larinartom0-pixel"
local repo = "Test"
local rawUrl = "https://raw.githubusercontent.com/" .. user .. "/" .. repo .. "/main/"
local apiUrl = "https://api.github.com/repos/" .. user .. "/" .. repo .. "/contents/scripts"

-- Отримуємо версію
local onlineVersion = "1.0"
pcall(function()
    onlineVersion = game:HttpGet(rawUrl .. "version.txt"):gsub("%s+", "")
end)

local Window = Rayfield:CreateWindow({
   Name = "🚀 lilhub | v" .. onlineVersion,
   LoadingTitle = "Завантаження...",
   LoadingSubtitle = "by Larinssk",
   ConfigurationSaving = { Enabled = false }
})

local ScriptsTab = Window:CreateTab("Скрипти", 4483362458)

-- Функція автозавантаження
local function LoadScripts()
    local ok, response = pcall(function() return game:HttpGet(apiUrl) end)
    if ok then
        local files = HttpService:JSONDecode(response)
        for _, file in pairs(files) do
            if file.name:sub(-4) == ".lua" then
                ScriptsTab:CreateButton({
                    Name = "🚀 " .. file.name:gsub(".lua", ""),
                    Callback = function()
                        loadstring(game:HttpGet(file.download_url))()
                    end,
                })
            end
        end
    else
        ScriptsTab:CreateLabel("Помилка API GitHub")
    end
end

LoadScripts()

local InfoTab = Window:CreateTab("Info", 4483362458)
InfoTab:CreateLabel("Нік: " .. game.Players.LocalPlayer.Name)
InfoTab:CreateLabel("Версія: " .. onlineVersion)

Rayfield:Notify({Title = "lilhub", Content = "Готово!", Duration = 3})

local function AutoLoadScripts()
    local success, response = pcall(function() return game:HttpGet(apiUrl) end)
    if success then
        local files = HttpService:JSONDecode(response)
        local count = 0
        for _, file in pairs(files) do
            if file.type == "file" and file.name:sub(-4) == ".lua" then
                count = count + 1
                ScriptsTab:CreateButton({
                    Name = "🚀 " .. file.name:gsub(".lua", ""),
                    Callback = function()
                        loadstring(game:HttpGet(file.download_url))()
                    end,
                })
            end
        end
        if count == 0 then ScriptsTab:CreateLabel("Папка 'scripts' порожня") end
    else
        ScriptsTab:CreateLabel("Помилка підключення до API GitHub")
    end
end
AutoLoadScripts()

--- ВКЛАДКА 2: USER INFO ---
local InfoTab = Window:CreateTab("User Info", 4483362458)
InfoTab:CreateSection("Статистика")
InfoTab:CreateLabel("Гравець: " .. game.Players.LocalPlayer.Name)
InfoTab:CreateLabel("Поточна версія: " .. onlineVersion)

InfoTab:CreateSection("Що нового (Changelog)")
InfoTab:CreateLabel(changelogText)

--- ФУНКЦІЯ ПЕРЕЗАПУСКУ ---
local function RebootHub()
    if _G.LilHubInstance then 
        _G.LilHubInstance:Destroy() 
        _G.LilHubInstance = nil
    end
    task.wait(0.5)
    loadstring(game:HttpGet(rawUrl .. "main.lua"))() 
end

InfoTab:CreateButton({
    Name = "🔄 Перезапустити хаб",
    Callback = RebootHub
})

--- ЛОГІКА LIVE UPDATE (Кожну хвилину) ---
task.spawn(function()
    while task.wait(60) do -- Перевірка раз на хвилину
        local success, newVer = pcall(function() 
            return game:HttpGet(rawUrl .. "version.txt"):gsub("%s+", "") 
        end)
        
        if success and newVer ~= onlineVersion then
            -- Створюємо термінове сповіщення
            Rayfield:Notify({
                Title = "🔔 ОНОВЛЕННЯ!",
                Content = "Знайдено нову версію: " .. newVer .. ". Перейдіть у вкладку Update!",
                Duration = 20
            })

            -- Додаємо спеціальну вкладку для оновлення
            local UpdateTab = Window:CreateTab("⚠️ UPDATE", 4483362458)
            UpdateTab:CreateSection("Доступна нова версія: " .. newVer)
            UpdateTab:CreateButton({
                Name = "♻️ ОНОВИТИ ТА ПЕРЕЗАПУСТИТИ",
                Callback = RebootHub
            })
            break -- Вимикаємо таймер після виявлення оновлення
        end
    end
end)

Rayfield:Notify({Title = "lilhub", Content = "Хаб готовий до роботи!", Duration = 3})
        for _, file in pairs(files) do
            if file.type == "file" and file.name:sub(-4) == ".lua" then
                count = count + 1
                local cleanName = file.name:gsub(".lua", "") -- Назва без розширення
                
                ScriptsTab:CreateButton({
                    Name = "Запустити: " .. cleanName,
                    Callback = function()
                        local s, err = pcall(function()
                            loadstring(game:HttpGet(file.download_url))()
                        end)
                        if not s then
                            Rayfield:Notify({Title = "Помилка", Content = "Не вдалося запустити " .. cleanName, Duration = 3})
                        end
                    end,
                })
            end
        end
        
        if count == 0 then
            ScriptsTab:CreateLabel("Скриптів у папці не знайдено")
        end
    else
        ScriptsTab:CreateLabel("Помилка з'єднання з GitHub API")
    end
end

-- Запускаємо сканування
AutoLoadScripts()

--- ВКЛАДКА 2: USER INFO ---
local InfoTab = Window:CreateTab("User Info", 4483362458)
InfoTab:CreateSection("Статистика")
InfoTab:CreateLabel("Нік: " .. game.Players.LocalPlayer.Name)
InfoTab:CreateLabel("Версія хабу: " .. onlineVersion)

-- Повідомлення про запуск
Rayfield:Notify({
    Title = "lilhub підключено!",
    Content = "Знайдено скриптів: " .. folder,
    Duration = 3
})
