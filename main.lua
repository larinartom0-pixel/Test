local HttpService = game:GetService("HttpService")
local user = "larinartom0-pixel"
local repo = "Test"
local rawUrl = "https://raw.githubusercontent.com/" .. user .. "/" .. repo .. "/main/"
local scriptsFolderUrl = rawUrl .. "scripts/"
local apiUrl = "https://api.github.com/repos/" .. user .. "/" .. repo .. "/contents/scripts"

-- Назва локального файлу для збереження версії
local VERSION_FILE = "lilhub_local_ver.txt"

-- 1. ФУНКЦІЇ ДЛЯ РОБОТИ З ФАЙЛАМИ
local function saveLocalVersion(ver)
    if writefile then writefile(VERSION_FILE, ver) end
end

local function getLocalVersion()
    if isfile and isfile(VERSION_FILE) then
        return readfile(VERSION_FILE):gsub("%s+", "")
    end
    return "0" -- Якщо файлу немає, вважаємо версію нульовою
end

-- Отримуємо версію з GitHub
local function getRemoteVersion()
    local ok, res = pcall(function() return game:HttpGet(rawUrl .. "version.txt"):gsub("%s+", "") end)
    return ok and res or "0"
end

local remoteVer = getRemoteVersion()
local localVer = getLocalVersion()

-- 2. ВИДАЛЕННЯ СТАРОГО GUI
if game.CoreGui:FindFirstChild("LilHubCustom") then
    game.CoreGui.LilHubCustom:Destroy()
end

-- 3. СТВОРЕННЯ GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LilHubCustom"
ScreenGui.Parent = game.CoreGui

-- Кнопка відкриття (L)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Text = "L"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 12)

-- Головне вікно
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🚀 lilhub | v" .. remoteVer
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Вкладка скриптів
local ScriptsPage = Instance.new("ScrollingFrame")
ScriptsPage.Parent = MainFrame
ScriptsPage.Position = UDim2.new(0, 10, 0, 50)
ScriptsPage.Size = UDim2.new(1, -20, 1, -60)
ScriptsPage.BackgroundTransparency = 1
ScriptsPage.CanvasSize = UDim2.new(0, 0, 0, 0)
local ScriptsLayout = Instance.new("UIListLayout")
ScriptsLayout.Parent = ScriptsPage
ScriptsLayout.Padding = UDim.new(0, 5)

--- ВІКНО ОНОВЛЕННЯ ---
local UpdateFrame = Instance.new("Frame")
UpdateFrame.Parent = ScreenGui
UpdateFrame.Size = UDim2.new(0, 260, 0, 160)
UpdateFrame.Position = UDim2.new(0.5, -130, 0.5, -80)
UpdateFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
UpdateFrame.Visible = false
UpdateFrame.ZIndex = 10
Instance.new("UICorner", UpdateFrame)

local UpdTitle = Instance.new("TextLabel")
UpdTitle.Parent = UpdateFrame
UpdTitle.Size = UDim2.new(1, 0, 0, 40)
UpdTitle.Text = "⚠️ Нова версія!"
UpdTitle.TextColor3 = Color3.new(1, 1, 1)
UpdTitle.Font = Enum.Font.GothamBold
UpdTitle.BackgroundTransparency = 1

local UpdDesc = Instance.new("TextLabel")
UpdDesc.Parent = UpdateFrame
UpdDesc.Position = UDim2.new(0, 10, 0, 45)
UpdDesc.Size = UDim2.new(1, -20, 0, 40)
UpdDesc.Text = "Знайдено оновлення " .. remoteVer .. ". Встановити?"
UpdDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
UpdDesc.BackgroundTransparency = 1
UpdDesc.TextWrapped = true

local RebootBtn = Instance.new("TextButton")
RebootBtn.Parent = UpdateFrame
RebootBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
RebootBtn.Size = UDim2.new(0.8, 0, 0, 35)
RebootBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 0)
RebootBtn.Text = "ОНОВИТИ ТА ПЕРЕЗАПУСТИТИ"
RebootBtn.TextColor3 = Color3.new(1, 1, 1)
RebootBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", RebootBtn)

-- ЛОГІКА ПЕРЕЗАПУСКУ
RebootBtn.MouseButton1Click:Connect(function()
    saveLocalVersion(remoteVer) -- Записуємо нову версію у файл
    ScreenGui:Destroy()
    task.wait(0.3)
    loadstring(game:HttpGet(rawUrl .. "main.lua"))() -- Перезапуск
end)

-- 4. ПЕРЕВІРКА ПРИ ЗАПУСКУ
if remoteVer ~= localVer then
    if localVer == "0" then
        -- Перший запуск: просто зберігаємо версію і працюємо
        saveLocalVersion(remoteVer)
        MainFrame.Visible = true
    else
        -- Версія відрізняється: показуємо вікно оновлення
        UpdateFrame.Visible = true
    end
else
    MainFrame.Visible = true
end

-- 5. ЗАВАНТАЖЕННЯ СПИСКУ СКРИПТІВ
local function LoadScripts()
    local ok, response = pcall(function() return game:HttpGet(apiUrl) end)
    if ok then
        local files = HttpService:JSONDecode(response)
        for _, file in pairs(files) do
            if file.name:sub(-4) == ".lua" then
                local btn = Instance.new("TextButton")
                btn.Parent = ScriptsPage
                btn.Size = UDim2.new(1, 0, 0, 35)
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                btn.Text = "🚀 " .. file.name:gsub(".lua", "")
                btn.TextColor3 = Color3.new(1, 1, 1)
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
                btn.MouseButton1Click:Connect(function()
                    loadstring(game:HttpGet(file.download_url))()
                end)
            end
        end
    end
end

ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
LoadScripts()

-- Фонова перевірка (раз на 2 хвилини)
task.spawn(function()
    while task.wait(120) do
        local newest = getRemoteVersion()
        if newest ~= getLocalVersion() then
            UpdateFrame.Visible = true
            break
        end
    end
end)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🚀 lilhub | v" .. CURRENT_VERSION
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Вкладки та контент (Скрипти/Інфо)
local ScriptsPage = Instance.new("ScrollingFrame")
ScriptsPage.Parent = MainFrame
ScriptsPage.Position = UDim2.new(0, 10, 0, 80)
ScriptsPage.Size = UDim2.new(1, -20, 1, -90)
ScriptsPage.BackgroundTransparency = 1
ScriptsPage.CanvasSize = UDim2.new(0, 0, 0, 0)
ScriptsPage.ScrollBarThickness = 2
local ScriptsLayout = Instance.new("UIListLayout")
ScriptsLayout.Parent = ScriptsPage
ScriptsLayout.Padding = UDim.new(0, 5)

--- ВІКНО ОНОВЛЕННЯ (Приховане за замовчуванням) ---
local UpdateFrame = Instance.new("Frame")
UpdateFrame.Parent = ScreenGui
UpdateFrame.Size = UDim2.new(0, 250, 0, 150)
UpdateFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
UpdateFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
UpdateFrame.Visible = false
UpdateFrame.ZIndex = 10
Instance.new("UICorner", UpdateFrame).CornerRadius = UDim.new(0, 15)

local UpdTitle = Instance.new("TextLabel")
UpdTitle.Parent = UpdateFrame
UpdTitle.Size = UDim2.new(1, 0, 0, 40)
UpdTitle.Text = "⚠️ Оновлення!"
UpdTitle.TextColor3 = Color3.new(1, 1, 1)
UpdTitle.Font = Enum.Font.GothamBold
UpdTitle.BackgroundTransparency = 1

local UpdText = Instance.new("TextLabel")
UpdText.Parent = UpdateFrame
UpdText.Position = UDim2.new(0, 10, 0, 40)
UpdText.Size = UDim2.new(1, -20, 0, 50)
UpdText.Text = "Доступна нова версія хабу. Перезапустити зараз?"
UpdText.TextColor3 = Color3.fromRGB(200, 200, 200)
UpdText.TextWrapped = true
UpdText.BackgroundTransparency = 1

local RebootBtn = Instance.new("TextButton")
RebootBtn.Parent = UpdateFrame
RebootBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
RebootBtn.Size = UDim2.new(0.8, 0, 0, 35)
RebootBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
RebootBtn.Text = "ПЕРЕЗАПУСТИТИ"
RebootBtn.TextColor3 = Color3.new(1, 1, 1)
RebootBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", RebootBtn)

-- ФУНКЦІЯ ПОВНОГО ПЕРЕЗАПУСКУ
local function FullReboot()
    ScreenGui:Destroy() -- Видаляємо все
    task.wait(0.1)
    loadstring(game:HttpGet(rawUrl .. "main.lua"))() -- Качаємо наново
end

RebootBtn.MouseButton1Click:Connect(FullReboot)

-- 3. ПЕРЕВІРКА ОНОВЛЕНЬ (Background loop)
task.spawn(function()
    while true do
        local ok, onlineVer = pcall(function() 
            return game:HttpGet(rawUrl .. "version.txt"):gsub("%s+", "") 
        end)
        
        if ok and onlineVer ~= CURRENT_VERSION then
            UpdateFrame.Visible = true -- Показуємо вікно оновлення
            break -- Зупиняємо цикл, бо оновлення знайдено
        end
        task.wait(60) -- Перевірка кожну хвилину
    end
end)

-- 4. ЗАВАНТАЖЕННЯ СКРИПТІВ
local function LoadScripts()
    local ok, response = pcall(function() return game:HttpGet(apiUrl) end)
    if ok then
        local files = HttpService:JSONDecode(response)
        for _, file in pairs(files) do
            if file.name:sub(-4) == ".lua" then
                local btn = Instance.new("TextButton")
                btn.Parent = ScriptsPage
                btn.Size = UDim2.new(1, 0, 0, 35)
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                btn.Text = "🚀 " .. file.name:gsub(".lua", "")
                btn.TextColor3 = Color3.new(1, 1, 1)
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
                btn.MouseButton1Click:Connect(function()
                    loadstring(game:HttpGet(file.download_url))()
                end)
            end
        end
    end
end

ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
LoadScripts()
MainFrame.Visible = true
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Заголовок (Спочатку пише Loading...)
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🚀 lilhub | Loading..." -- Тимчасовий текст
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Кнопка закриття (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18

-- Вкладки
local TabsContainer = Instance.new("Frame")
TabsContainer.Parent = MainFrame
TabsContainer.Position = UDim2.new(0, 10, 0, 40)
TabsContainer.Size = UDim2.new(1, -20, 0, 30)
TabsContainer.BackgroundTransparency = 1

local function CreateTabBtn(name, posInfo, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = TabsContainer
    btn.Size = UDim2.new(0.5, -5, 1, 0)
    if posInfo == "Left" then
        btn.Position = UDim2.new(0, 0, 0, 0)
    else
        btn.Position = UDim2.new(0.5, 5, 0, 0)
    end
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local ScriptsPage = Instance.new("ScrollingFrame")
ScriptsPage.Parent = MainFrame
ScriptsPage.Position = UDim2.new(0, 10, 0, 80)
ScriptsPage.Size = UDim2.new(1, -20, 1, -90)
ScriptsPage.BackgroundTransparency = 1
ScriptsPage.CanvasSize = UDim2.new(0, 0, 0, 0)
ScriptsPage.ScrollBarThickness = 4
local ScriptsLayout = Instance.new("UIListLayout")
ScriptsLayout.Parent = ScriptsPage
ScriptsLayout.Padding = UDim.new(0, 5)

local InfoPage = Instance.new("ScrollingFrame")
InfoPage.Parent = MainFrame
InfoPage.Position = UDim2.new(0, 10, 0, 80)
InfoPage.Size = UDim2.new(1, -20, 1, -90)
InfoPage.BackgroundTransparency = 1
InfoPage.Visible = false
local InfoText = Instance.new("TextLabel")
InfoText.Parent = InfoPage
InfoText.Size = UDim2.new(1, 0, 0, 0)
InfoText.BackgroundTransparency = 1
InfoText.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoText.TextWrapped = true
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.TextYAlignment = Enum.TextYAlignment.Top
InfoText.Font = Enum.Font.Code

local function SwitchTab(tabName)
    if tabName == "Scripts" then
        ScriptsPage.Visible = true
        InfoPage.Visible = false
    else
        ScriptsPage.Visible = false
        InfoPage.Visible = true
    end
end

CreateTabBtn("📜 Скрипти", "Left", function() SwitchTab("Scripts") end)
CreateTabBtn("ℹ️ Інфо", "Right", function() SwitchTab("Info") end)

local function AddScriptButton(name, url)
    local btn = Instance.new("TextButton")
    btn.Parent = ScriptsPage
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = "🚀 " .. name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function() loadstring(game:HttpGet(url))() end)
    ScriptsPage.CanvasSize = UDim2.new(0, 0, 0, ScriptsLayout.AbsoluteContentSize.Y)
end
ScriptsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScriptsPage.CanvasSize = UDim2.new(0, 0, 0, ScriptsLayout.AbsoluteContentSize.Y)
end)

-- 2. ОСНОВНА ЛОГІКА ЗАВАНТАЖЕННЯ
local function LoadData()
    -- А. Отримуємо ВЕРСІЮ з GitHub (щоб виправити баг із назвою)
    local onlineVer = "1.0"
    local hasVersionFile = pcall(function()
        local v = game:HttpGet(rawUrl .. "version.txt")
        if v and #v > 0 then
            onlineVer = v:gsub("%s+", "") -- Видаляємо пробіли
        end
    end)
    -- Оновлюємо заголовок вікна реальною версією
    Title.Text = "🚀 lilhub | v" .. onlineVer

    -- Б. Завантажуємо скрипти
    local ok, response = pcall(function() return game:HttpGet(apiUrl) end)
    if ok then
        local files = HttpService:JSONDecode(response)
        for _, file in pairs(files) do
            if file.name:sub(-4) == ".lua" then
                AddScriptButton(file.name:gsub(".lua", ""), file.download_url)
            end
        end
    else
        AddScriptButton("Music (Error Mode)", rawUrl .. "scripts/music.lua")
    end
    
    -- В. Ченджлог і авто-відкриття
    local changelogContent = "Не вдалося завантажити."
    pcall(function() changelogContent = game:HttpGet(scriptsFolderUrl .. "changelog.txt") end)
    
    -- Додаємо версію в текст ченджлогу для краси
    InfoText.Text = "Версія хабу: " .. onlineVer .. "\n\n" .. changelogContent
    
    local textBounds = game:GetService("TextService"):GetTextSize(InfoText.Text, 14, Enum.Font.Code, Vector2.new(InfoPage.AbsoluteWindowSize.X, 10000))
    InfoText.Size = UDim2.new(1, 0, 0, textBounds.Y + 20)
    InfoPage.CanvasSize = UDim2.new(0, 0, 0, textBounds.Y + 20)

    -- Перевірка: чи змінилась версія або текст?
    local lastSeenLog = ""
    if isfile and isfile("lilhub_last_log.txt") then
        lastSeenLog = readfile("lilhub_last_log.txt")
    end

    -- Якщо текст ченджлогу змінився - відкриваємо Інфо
    if changelogContent ~= lastSeenLog then
        SwitchTab("Info")
        if writefile then writefile("lilhub_last_log.txt", changelogContent) end
    else
        SwitchTab("Scripts")
    end
end

ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

LoadData()
MainFrame.Visible = true
