script_name("Auto Fish Mod")
script_author("Ryu S. Yamaguchi (Discord: ryu.sql)")
script_version("2.2")

-- ==========================
-- REQUIREMENTS
-- ==========================
local success, sampev = pcall(require, "samp.events")
if not success then
    print("Failed to load samp.events library")
    return
end

-- ==========================
-- CONFIGURATION
-- ==========================
local autoFishing = false
local waitingForCatch = false
local minWeight = 20           -- minimum weight to keep
local castDelay = 1000         -- /fish delay in ms
local throwbackDelay = 700     -- delay before using /throwback

-- ==========================
-- UTILITIES
-- ==========================
local function castFish()
    lua_thread.create(function()
        wait(castDelay)
        sampSendChat("/fish")
        waitingForCatch = true
    end)
end

local function throwbackFish()
    lua_thread.create(function()
        wait(throwbackDelay)
        sampSendChat("/throwback")
        wait(throwbackDelay)
        castFish()
    end)
end

local function startAutoFish()
    autoFishing = true
    waitingForCatch = false

    sampAddChatMessage(
        "{00FFFF}[AutoFish]: {FFFFFF}Auto-fishing {00FF00}started! {FFFFFF}| Use {00FFFF}(/afish) {FFFFFF}to stop.",
        -1
    )
    castFish()
end

local function stopAutoFish(reason)
    autoFishing = false
    waitingForCatch = false

    sampAddChatMessage(
        "{00FFFF}[AutoFish]: {AA0000}Stopped. {FFFFFF}" .. reason,
        -1
    )
end

-- ==========================
-- CHAT COMMAND
-- ==========================
sampRegisterChatCommand("afish", function()
    if autoFishing then
        stopAutoFish("Manually stopped.")
    else
        startAutoFish()
    end
end)

-- ==========================
-- EVENT HANDLERS
-- ==========================
function sampev.onServerMessage(color, text)
    if not autoFishing then return end
    local clean = text:gsub("{.-}", "") -- remove formatting

    -- Not in fishing area
    if clean:find("You are not at the Santa Maria Pier") then
        stopAutoFish("Not in fishing area.")
        return
    end

    -- Fishing break
    if clean:find("You have caught enough fish for now") then
        stopAutoFish("Fishing break.")
        return
    end

    -- Inventory full and fish caught
    if clean:find("can't carry more than five fish") then
        sampAddChatMessage(
            "{00FFFF}[AutoFish]: {FFFFFF}All fish are good! You may now sell or release them.",
            -1
        )
        stopAutoFish("")
        return
    end

    -- Bad catch
    local badCatch = clean:find("line snapped")
                     or clean:find("threw it away")
                     or clean:find("You caught a bag filled with money")
    if waitingForCatch and badCatch then
        waitingForCatch = false
        castFish()
        return
    end

    -- Successful catch
    if waitingForCatch and clean:find("You have caught a") then
        waitingForCatch = false
        local weight = tonumber(clean:match("Weight:%s*(%d+%.?%d*)"))
        if weight and weight < minWeight then
            throwbackFish()
        else
            castFish()
        end
        return
    end
end

function main()
    repeat wait(0) until isSampAvailable()
    sampAddChatMessage(
        "{00FF00}[AutoFish]: {FFFFFF}Author: {AA0000}Ryu S. Yamaguchi {FFFFFF}| Use {00FFFF}(/afish) {FFFFFF}to toggle auto-fishing.",
        -1
    )
end
