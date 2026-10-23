do
local autoRunning = false
local musicList = {"music1.mp3", "music2.mp3","music3.mp3"}
local stopRunningMessages = {"Are you sure?", "Really!?", "Already bored?", "Just a little bit more, please!", "Push NUM Button, NOW!", "You have reached your destination!"}
local startRunningMessages = {"Now you can go 500miles!", "Walk walk...", "Going somewhere over the moutain?", "Phew that's far. Here is some music to cheer you up on your journey!"}
local addonPath = "Interface\\AddOns\\500miles\\"
local currentMusic
local previousMusicSetting
local leftButtonDown, rightButtonDown = false, false

local function stopMusic()
    if currentMusic then
        StopSound(currentMusic)
        currentMusic = nil
    end
    if previousMusicSetting then
        C_CVar.SetCVar("Sound_EnableMusic", previousMusicSetting)
        previousMusicSetting = nil
    end
end

local function stopRunning()
    if not autoRunning then return end
    autoRunning = false
    stopMusic()
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000 " .. stopRunningMessages[math.random(#stopRunningMessages)] .. "|r")
end

local function startRunning()
    if autoRunning then return end
    autoRunning = true
    local file = addonPath .. musicList[math.random(#musicList)]
    local willPlay, soundHandle = PlaySoundFile(file, "Ambience")
    if willPlay and soundHandle then
        currentMusic = soundHandle
        local setting = C_CVar.GetCVar("Sound_EnableMusic")
        if setting == "1" then
            previousMusicSetting = setting
            C_CVar.SetCVar("Sound_EnableMusic", "0")
        end
    end
    DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00 " .. startRunningMessages[math.random(#startRunningMessages)] .. "|r")
end

hooksecurefunc("ToggleAutoRun", function()
    if autoRunning then stopRunning() else startRunning() end
end)
hooksecurefunc("StartAutoRun", startRunning)
hooksecurefunc("StopAutoRun", stopRunning)
hooksecurefunc("MoveForwardStart", stopRunning)
hooksecurefunc("MoveBackwardStart", stopRunning)
hooksecurefunc("MoveAndSteerStart", stopRunning)
hooksecurefunc("CameraOrSelectOrMoveStart", function()
    leftButtonDown = true
    if rightButtonDown then stopRunning() end
end)
hooksecurefunc("CameraOrSelectOrMoveStop", function()
    leftButtonDown = false
end)
hooksecurefunc("TurnOrActionStart", function()
    rightButtonDown = true
    if leftButtonDown then stopRunning() end
end)
hooksecurefunc("TurnOrActionStop", function()
    rightButtonDown = false
end)

-- Restore only the music setting this addon changed before the client saves settings.
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:SetScript("OnEvent", stopMusic)

DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000 Done Loading 500miles. Now you can go somewhere far away without getting bored!|r")
end
