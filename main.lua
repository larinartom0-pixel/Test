local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local HttpService = game:GetService("HttpService")

-- Твої дані GitHub
local user = "larinartom0-pixel"
local repo = "Test"
local folder = "scripts"
local rawUrl = "https://raw.githubusercontent.com/" .. user .. "/" .. repo .. "/main/"
local apiUrl = "https://api.github.com/repos/" .. user .. "/" .. repo .. "/contents/" .. folder

-- Отримуємо версію
local onlineVersion = "1.0"
pcall(function()
    onlineVersion = game:HttpGet(rawUrl .. "version.txt"):gsub("%s+", "")
end)

local Window = Rayfield:CreateWindow({
   Name = "🚀 lilhub | v" .. onlineVersion,
   LoadingTitle = "Завантаження хмарних скриптів...",
   LoadingSubtitle = "by Larinssk",
   ConfigurationSaving = { Enabled = true, FolderName = "lilhub_configs", FileName = "Main" }
})

--- ВКЛАДКА 1: СКРИПТИ (АВТОМАТИЧНА) ---
local ScriptsTab = Window:CreateTab("Скрипти", 4483362458)
ScriptsTab:CreateSection("Всі знайдені .lua файли")

local function AutoLoadScripts()
    local success, response = pcall(function()
        return game:HttpGet(apiUrl)
    end)

    if success then
        local files = HttpService:JSONDecode(response)
        local count = 0
        
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
