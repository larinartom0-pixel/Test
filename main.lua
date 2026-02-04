local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local user = "larinartom0-pixel"
local repo = "Test"
local rawUrl = "https://raw.githubusercontent.com/" .. user .. "/" .. repo .. "/main/"
local scriptsFolderUrl = rawUrl .. "scripts/"
local apiUrl = "https://api.github.com/repos/" .. user .. "/" .. repo .. "/contents/scripts"

-- Видаляємо старий інтерфейс, якщо він є
local OldGui = game.CoreGui:FindFirstChild("LilHubCustom")
if OldGui then OldGui:Destroy() end

-- 1. СТВОРЕННЯ GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LilHubCustom"
ScreenGui.Parent = game.CoreGui

-- Кнопка відкриття (Міні-іконка)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, -25) -- Зліва по центру
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Text = "L"
ToggleBtn.TextSize = 25
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 12) -- М'які краї

-- Головне вікно
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125) -- Центр екрана
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Visible = false -- Спочатку приховане, поки не вирішимо, що показати
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🚀 lilhub | v1.0"
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

-- Контейнер для кнопок вкладок
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

-- Сторінки (Фрейми)
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
InfoText.Size = UDim2.new(1, 0, 0, 0) -- Авто-розмір
InfoText.BackgroundTransparency = 1
InfoText.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoText.TextWrapped = true
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.TextYAlignment = Enum.TextYAlignment.Top
InfoText.Font = Enum.Font.Code

-- Логіка перемикання вкладок
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

-- Функція додавання скриптів
local function AddScriptButton(name, url)
    local btn = Instance.new("TextButton")
    btn.Parent = ScriptsPage
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = "🚀 " .. name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        loadstring(game:HttpGet(url))()
    end)
    
    ScriptsPage.CanvasSize = UDim2.new(0, 0, 0, ScriptsLayout.AbsoluteContentSize.Y)
end
ScriptsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScriptsPage.CanvasSize = UDim2.new(0, 0, 0, ScriptsLayout.AbsoluteContentSize.Y)
end)

-- 2. ЗАВАНТАЖЕННЯ ДАНИХ (АВТО-ОНОВЛЕННЯ СПИСКУ)
local function LoadData()
    -- Скрипти
    local ok, response = pcall(function() return game:HttpGet(apiUrl) end)
    if ok then
        local files = HttpService:JSONDecode(response)
        for _, file in pairs(files) do
            if file.name:sub(-4) == ".lua" then
                AddScriptButton(file.name:gsub(".lua", ""), file.download_url)
            end
        end
    else
        AddScriptButton("Music (Offline/Error)", rawUrl .. "scripts/music.lua")
    end
    
    -- Changelog (Розумна система)
    local changelogContent = "Не вдалося завантажити."
    pcall(function() changelogContent = game:HttpGet(scriptsFolderUrl .. "changelog.txt") end)
    InfoText.Text = changelogContent
    -- Підганяємо розмір тексту
    local textBounds = game:GetService("TextService"):GetTextSize(changelogContent, 14, Enum.Font.Code, Vector2.new(InfoPage.AbsoluteWindowSize.X, 10000))
    InfoText.Size = UDim2.new(1, 0, 0, textBounds.Y + 20)
    InfoPage.CanvasSize = UDim2.new(0, 0, 0, textBounds.Y + 20)

    -- Перевірка: чи бачив гравець цей чейнджлог?
    local lastSeenLog = ""
    if isfile and isfile("lilhub_last_log.txt") then
        lastSeenLog = readfile("lilhub_last_log.txt")
    end

    if changelogContent ~= lastSeenLog then
        -- Нове оновлення! Показуємо вкладку Інфо
        SwitchTab("Info")
        if writefile then writefile("lilhub_last_log.txt", changelogContent) end
    else
        -- Нічого нового, відразу до скриптів
        SwitchTab("Scripts")
    end
end

-- 3. ФУНКЦІОНАЛ КНОПОК
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Запуск
LoadData()
MainFrame.Visible = true -- Показуємо меню при старті
