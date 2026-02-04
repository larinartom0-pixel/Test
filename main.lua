-- ОЧИЩЕННЯ: Видаляємо старе вікно перед завантаженням (щоб не було дублікатів)
if _G.LilHubInstance then
    pcall(function() _G.LilHubInstance:Destroy() end)
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local HttpService = game:GetService("HttpService")

-- ДАНІ GITHUB
local user = "larinartom0-pixel"
local repo = "Test"
local folder = "scripts"
local rawUrl = "https://raw.githubusercontent.com/" .. user .. "/" .. repo .. "/main/"
local apiUrl = "https://api.github.com/repos/" .. user .. "/" .. repo .. "/contents/" .. folder

-- 1. ЗАВАНТАЖЕННЯ ДАНИХ (ВЕРСІЯ ТА CHANGELOG)
local onlineVersion = "1.0"
local changelogText = "Не вдалося завантажити список змін."

pcall(function()
    onlineVersion = game:HttpGet(rawUrl .. "version.txt"):gsub("%s+", "")
    changelogText = game:HttpGet(rawUrl .. "changelog.txt")
end)

local Window = Rayfield:CreateWindow({
   Name = "🚀 lilhub | v" .. onlineVersion,
   LoadingTitle = "Синхронізація з сервером...",
   LoadingSubtitle = "by Larinssk",
   ConfigurationSaving = { Enabled = true, FolderName = "lilhub_configs", FileName = "Main" }
})

_G.LilHubInstance = Window -- Зберігаємо вікно для подальшого видалення

--- ВКЛАДКА 1: СКРИПТИ (АВТОМАТИЧНА) ---
local ScriptsTab = Window:CreateTab("Скрипти", 4483362458)
ScriptsTab:CreateSection("Знайдені хмарні файли")

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
