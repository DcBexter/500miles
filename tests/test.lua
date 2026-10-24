local addonFile = (arg and arg[1]) or "500miles.lua"
local hooks, events, played, stopped, settings, writes
local playbackSucceeds, returnedHandle
local env = setmetatable({}, { __index = _G })
local sentinel = function() end
env.play, env.stop = sentinel, sentinel
env.DEFAULT_CHAT_FRAME = { AddMessage = function() end }
env.C_CVar = {
    GetCVar = function(name) assert(name == "Sound_EnableMusic"); return settings end,
    SetCVar = function(name, value)
        assert(name == "Sound_EnableMusic")
        settings = value
        writes = writes + 1
    end,
}
env.PlaySoundFile = function(file, channel)
    assert(file:match("^Interface\\AddOns\\500miles\\music[123]%.mp3$"))
    assert(channel == "Ambience")
    played = played + 1
    return playbackSucceeds, returnedHandle
end
env.StopSound = function(handle)
    assert(handle == 42, "Must only stop owned, non-nil handle")
    stopped = stopped + 1
end
env.CreateFrame = function(kind)
    assert(kind == "Frame")
    return {
        RegisterEvent = function(_, event) events[event] = true end,
        SetScript = function(_, script, callback)
            assert(script == "OnEvent")
            events.callback = callback
        end,
    }
end
local names = {
    "ToggleAutoRun", "StartAutoRun", "StopAutoRun", "MoveForwardStart",
    "MoveBackwardStart", "MoveAndSteerStart", "CameraOrSelectOrMoveStart",
    "CameraOrSelectOrMoveStop", "TurnOrActionStart", "TurnOrActionStop",
}
for _, name in ipairs(names) do env[name] = sentinel end
env.hooksecurefunc = function(name, callback)
    assert(env[name] == sentinel, "Unexpected movement API: " .. name)
    hooks[name] = callback
end
local function reset(initial, succeeds, handle)
    hooks, events, played, stopped, writes = {}, {}, 0, 0, 0
    settings, playbackSucceeds, returnedHandle = initial, succeeds, handle
    local chunk = assert(loadfile(addonFile))
    setfenv(chunk, env)
    chunk()
    assert(env.play == sentinel and env.stop == sentinel, "Addon must not overwrite other addons' globals")
    assert(env.startRunning == nil and env.stopRunning == nil and env.getRandomFile == nil)
    for _, name in ipairs(names) do assert(hooks[name], "Missing hook: " .. name) end
end

reset("1", true, 42)
hooks.ToggleAutoRun()
assert(played == 1 and settings == "0")
hooks.ToggleAutoRun()
assert(stopped == 1 and settings == "1")

reset("0", true, 42)
hooks.StartAutoRun()
hooks.StartAutoRun()
assert(played == 1 and settings == "0" and writes == 0, "Repeated start must not duplicate sound")
hooks.StopAutoRun()
hooks.StopAutoRun()
assert(stopped == 1 and settings == "0" and writes == 0, "Disabled game music must stay disabled")

for _, result in ipairs({ { false, nil }, { true, nil } }) do
    reset("1", result[1], result[2])
    hooks.StartAutoRun()
    hooks.StopAutoRun()
    assert(stopped == 0 and settings == "1" and writes == 0, "Playback failure must not mute music or stop nil")
end

for _, name in ipairs({ "MoveForwardStart", "MoveBackwardStart", "MoveAndSteerStart" }) do
    reset("1", true, 42)
    hooks[name]()
    assert(stopped == 0 and writes == 0)
    hooks.StartAutoRun()
    hooks[name]()
    assert(stopped == 1 and settings == "1", name .. " must stop owned music")
end

for _, pair in ipairs({
    { "CameraOrSelectOrMoveStart", "TurnOrActionStart" },
    { "TurnOrActionStart", "CameraOrSelectOrMoveStart" },
}) do
    reset("1", true, 42)
    hooks.StartAutoRun()
    hooks[pair[1]]()
    assert(stopped == 0, "One mouse button must not cancel autorun")
    hooks[pair[2]]()
    assert(stopped == 1 and settings == "1", "Both mouse buttons must cancel music")
    hooks.CameraOrSelectOrMoveStop()
    hooks.TurnOrActionStop()
    hooks.StartAutoRun()
    hooks[pair[1]]()
    assert(stopped == 1, "Mouse release must clear held state")
end

reset("1", true, 42)
hooks.StartAutoRun()
assert(events.PLAYER_LOGOUT, "Logout must restore game music setting")
events.callback()
events.callback()
assert(stopped == 1 and settings == "1", "Logout cleanup must be idempotent")
print("PASS: autorun toggle/start/stop, movement and both mouse orders, idempotence, failed/nil playback, music preference, logout, global isolation")
