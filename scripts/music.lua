local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- Налаштування шляхів
local folderName = "MyCombatMusic"
local fileName = "Void-Explorer.mp3"
local filePath = folderName .. "/" .. fileName
local githubUrl = "https://raw.githubusercontent.com/larinartom0-pixel/Test/main/Void-Explorer.mp3"

-- 1. ПЕРЕВІРКА ПАПКИ ТА ФАЙЛУ
if not isfolder(folderName) then
    makefolder(folderName)
    print("📁 Папку створено: " .. folderName)
end

if not isfile(filePath) then
    print("⏳ Файл не знайдено. Починаю завантаження з GitHub...")
    local success, result = pcall(function()
        return game:HttpGet(githubUrl)
    end)
    
    if success and result then
        writefile(filePath, result)
        print("✅ Музику успішно завантажено!")
    else
        warn("❌ Помилка завантаження! Перевір посилання або інтернет.")
        return
    end
end

-- 2. ПІДКЛЮЧЕННЯ ЗВУКУ
local sound = Instance.new("Sound", game:GetService("SoundService"))
sound.Looped = true 

local assetSuccess, asset = pcall(function() return getcustomasset(filePath) end)
if assetSuccess and asset then 
    sound.SoundId = asset 
else 
    warn("❌ Не вдалося створити ассет з файлу!")
    return 
end

-- Таймкоди
local NORMAL_START = 0
local BERSERK_START = 220
local isBerserk = false
local needsReset = true

-- 3. ОСНОВНА ЛОГІКА (Твій Реворк)
local function onCharacterAdded(char)
    local hum = char:WaitForChild("Humanoid")
    isBerserk = false
    needsReset = true 
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not hum or not hum.Parent or hum.Health <= 0 then 
            if sound.IsPlaying then sound:Stop() end
            connection:Disconnect() 
            return 
        end

        local hpPercent = hum.Health / hum.MaxHealth
        
        if hpPercent >= 1 then
            if sound.IsPlaying then 
                sound:Stop() 
                isBerserk = false
                needsReset = true 
            end
            return
        end

        if hpPercent <= 0.99 and not sound.IsPlaying then
            if needsReset then
                sound.TimePosition = NORMAL_START
                needsReset = false 
            end
            sound:Play()
        end

        local targetVolume = math.clamp((1 - hpPercent) / 0.7, 0, 1)
        sound.Volume = targetVolume

        if hpPercent <= 0.3 then
            if not isBerserk then
                isBerserk = true
                sound.TimePosition = BERSERK_START
                print("👹 ФАЗА БЕРСЕРК!")
            end
        elseif hpPercent > 0.3 and isBerserk then
            isBerserk = false 
        end
    end)
end

lp.CharacterAdded:Connect(onCharacterAdded)
if lp.Character then onCharacterAdded(lp.Character) end
