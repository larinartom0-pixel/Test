local HttpService = game:GetService("HttpService")
local user = "larinartom0-pixel"
local repo = "Test"
local rawUrl = "https://raw.githubusercontent.com/" .. user .. "/" .. repo .. "/main/"
local scriptsFolderUrl = rawUrl .. "scripts/"
local apiUrl = "https://api.github.com/repos/" .. user .. "/" .. repo .. "/contents/scripts"

-- Створюємо GUI вручну
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ScriptsList = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local CloseButton = Instance.new("TextButton")

ScreenGui.Name = "LilHubCustom"
ScreenGui.Parent = game.CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "🚀 LILHUB CUSTOM | v1.0"
Title.TextColor3 = Color3.new(1, 1, 1)

CloseButton.Parent = MainFrame
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

ScriptsList.Parent = MainFrame
ScriptsList.Position = UDim2.new(0, 10, 0, 40)
ScriptsList.Size = UDim2.new(1, -20, 1, -50)
ScriptsList.BackgroundTransparency = 1
ScriptsList.CanvasSize = UDim2.new(0, 0, 2, 0)

UIListLayout.Parent = ScriptsList
UIListLayout.Padding = UDim.new(0, 5)

-- Функція створення кнопки
local function CreateButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ScriptsList
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.MouseButton1Click:Connect(callback)
end

-- Завантаження скриптів з GitHub API
local ok, response = pcall(function() return game:HttpGet(apiUrl) end)
if ok then
    local files = HttpService:JSONDecode(response)
    for _, file in pairs(files) do
        if file.name:sub(-4) == ".lua" then
            CreateButton("🚀 Run: " .. file.name, function()
                loadstring(game:HttpGet(file.download_url))()
            end)
        end
    end
else
    -- Резервна кнопка для музики
    CreateButton("🎵 Music (Manual)", function()
        loadstring(game:HttpGet(scriptsFolderUrl .. "music.lua"))()
    end)
end

-- Кнопка для Changelog
CreateButton("📜 Show Changelog", function()
    local text = game:HttpGet(scriptsFolderUrl .. "changelog.txt")
    print("CHANGELOG:\n" .. text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Changelog",
        Text = "Текст виведено в консоль!",
        Duration = 5
    })
end)
