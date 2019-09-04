do
-- Declare variables --
local autoRunning = 0
local musicList = {"Interface\\AddOns\\500miles\\music1.mp3", "Interface\\AddOns\\500miles\\music2.mp3","Interface\\AddOns\\500miles\\music3.mp3"}
local stopRunningMessages = {"Are you sure?", "Really!?", "Already bored?", "Just a little bit more, please!", "Push NUM Button, NOW!"}
local startRunningMessages = {"Now you can go 500miles!", "Walk walk...", "Going somewhere over the moutain?", "Phew that's far. Here is some music to cheer you up on your journey!"}
local currentMusic = null
local LeftButtonDown, RightButtonDown = false, false
local ForwardButtonDown, BackwardButtonDown = false, false

-- End declarations --

-- Autorun logic --
hooksecurefunc("ToggleAutoRun",function()
    if autoRunning==1 then
		stopRunning()
	else 
		startRunning()
	end
end)

hooksecurefunc("MoveForwardStart", function()
    	ForwardButtonDown = true
        if ForwardButtonDown and autoRunning==1 then
		stopRunning()
	end
end)
 
hooksecurefunc("MoveBackwardStart", function()
	BackwardButtonDown = true
	if BackwardButtonDown and autoRunning==1 then
		stopRunning()
	end
end)

hooksecurefunc("CameraOrSelectOrMoveStart", function()
    	LeftButtonDown = true
    	if RightButtonDown and autoRunning==1 then
		stopRunning()
	end
end)

hooksecurefunc("CameraOrSelectOrMoveStop", function()
	LeftButtonDown = false
end)

hooksecurefunc("TurnOrActionStart", function()
	RightButtonDown = true
	if LeftButtonDown and autoRunning==1 then
		stopRunning()
	end
end)

hooksecurefunc("TurnOrActionStop", function()
	RightButtonDown = false
end)

function stopRunning()
	autoRunning=0
	stop()
	DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000 " .. stopRunningMessages[math.random(1, #stopRunningMessages)])
end

function startRunning()
	autoRunning=1
	play()
	DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00 " .. startRunningMessages[math.random(1, #startRunningMessages)])
end
-- End Autorun logic --

-- Player --
function play()
	SetCVar("Sound_EnableMusic", 0);
	local file = getRandomFile();
	local willplay, soundHandle = PlaySoundFile(file, "Ambience")
	currentMusic = soundHandle
end

function stop()
	SetCVar("Sound_EnableMusic", 1);
	StopSound(currentMusic)
end

function getRandomFile()
	local randomNumber=math.random(1, #musicList);
	return musicList[randomNumber];
end
-- End Player --

-- Announce end of loading in chat frame --
DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000 Done Loading 500miles. Now you can go somewhere far away without getting bored!")
-- End Announce in chat frame --

end