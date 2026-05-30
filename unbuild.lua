---@diagnostic disable-next-line: undefined-field
os.loadAPI("JoshAPI.lua")

local tArgs = { ... }

local function getArg(num)
    local a = JoshAPI.parse(tArgs[num])
    if a == nil then
        print("Arugments error")
        print("Use unbuild with no arguments if you don't know what you're doing")
        error()
    end
    return a
end

local function slot()
    local function slotsHaveSpace()
        for n = 1, 16 do
            if turtle.getItemSpace(n) > 0 then
                return true
            end
        end
        turtle.select(1)
        return false
    end

    if not slotsHaveSpace() then
        print("Empty inventory to continue.")
        while not slotsHaveSpace() do
            sleep(1)
        end
    end
end

local function inputNum()
    local a = io.read()
    a = tonumber(a)
    if a == nil or a <= 0 then
        print("Number error")
        error()
    else
        return a
    end
end

local function inputStr()
    local a = io.read()
    a = tostring(a)
    if a == nil then
        print("String error")
        error()
    else
        return string.lower(a)
    end
end

local function line(L)
    for i = 1, L - 1 do
        slot()
        JoshAPI.forwardA()
    end
end

local function lineUp(H, goDown)
    for i = 1, H - 1 do
        slot()
        JoshAPI.upA()
    end

    if goDown then
        lineDown(H)
    end
end

local function lineDown(H)
    for i = 1, H - 1 do
        slot()
        JoshAPI.downA()
    end
end

local function stairsUp(H)
    for i = 1, H - 1 do
        slot()
        turtle.digDown()
        JoshAPI.upA()
        JoshAPI.forwardA()
    end
    slot()
    turtle.digDown()
end

local function stairsDown(H)
    for i = 1, H - 1 do
        slot()
        turtle.digDown()
        JoshAPI.forwardA()
        JoshAPI.downA()
    end
    slot()
    turtle.digDown()
end

local function wallV(L, H)
    for i = 1, math.floor((L) / 2) do --math.floor((L-1)/2)
        lineUp(H, false)
        JoshAPI.forwardA()
        lineDown(H)
        if i == math.floor((L) / 2) then --on last one
            if L % 2 == 1 then
                JoshAPI.forwardA()
            end
        else
            JoshAPI.forwardA()
        end
    end
    if L % 2 == 1 then
        lineUp(H, true)
    end
end

local function wallH(L, H)
    for i = 1, H - 1 do
        line(L)
        JoshAPI.upA()
        turtle.turnRight()
        turtle.turnRight()
    end
    line(L)
end

local function box(D, W, H, makeRoof)
    local function getDown()
        for x = 1, H - 1 do
            JoshAPI.downA()
        end
    end

    for i = 1, W do
        wallV(D, H)
        if i % 2 == 1 then
            turtle.turnRight()
            JoshAPI.forwardA()
            turtle.turnRight()
        elseif i % 2 == 0 then
            turtle.turnLeft()
            JoshAPI.forwardA()
            turtle.turnLeft()
        end
    end
end

local function platform(D, W)
    for i = 1, W - 1 do
        line(D)
        if i % 2 == 1 then
            turtle.turnRight()
            JoshAPI.forwardA()
            turtle.turnRight()
        elseif i % 2 == 0 then
            turtle.turnLeft()
            JoshAPI.forwardA()
            turtle.turnLeft()
        end
    end
    line(D)
end

JoshAPI.cleanTerm()

local doText
if #tArgs == 0 then
    doText = true
else
    doText = false
end

local choice
if doText then
    print("Shape unmaker")
    print("-----------------------")
    print("What Shape?")
    print("Options:")
    print("line, wallV, wallH, box, platform, stairs, stairsDown, lineUp")

    choice = inputStr()

    term.clear()
    term.setCursorPos(1, 1)
else
    choice = getArg(1)
end

if choice == "line" then
    local l
    if doText then
        print("Place turtle facing build direction.")
        print("------------------------------------")
        print("Length?")
        l = inputNum()
    else
        l = getArg(2)
    end
    line(l)
elseif choice == "stairs" then
    local h
    if doText then
        print("Place turtle facing build direction.")
        print("Stair starts with block below turtle.")
        print("------------------------------------")
        print("Length/height?")
        h = inputNum()
    else
        h = getArg(2)
    end
    stairsUp(h)
elseif choice == "stairsdown" then
    local h
    if doText then
        print("Place turtle facing build direction.")
        print("Stair starts with block below turtle.")
        print("------------------------------------")
        print("Length/height?")
        h = inputNum()
    else
        h = getArg(2)
    end
    stairsDown(h)
elseif choice == "wallv" then
    local l, h
    if doText then
        print("Wall Vertical - build up vertical line by line")
        print("Place turtle facing build direction.")
        print("------------------------------------")
        print("Length?")
        l = inputNum()
        print("Height?")
        h = inputNum()
    else
        l = getArg(2)
        h = getArg(3)
    end
    wallV(l, h)
elseif choice == "wallh" then
    local l, h
    if doText then
        print("Wall Horizontal - start from bottom layer and go up")
        print("Place turtle facing build direction.")
        print("------------------------------------")
        print("Length?")
        l = inputNum()
        print("Height?")
        h = inputNum()
    else
        l = getArg(2)
        h = getArg(3)
    end
    wallH(l, h)
elseif choice == "box" then
    local d, w, h
    if doText then
        print("Place turtle in lower left corner.")
        print("----------------------------------")
        print("Depth? (Sides perpendicular to front of turtle)")
        d = inputNum()
        print("Width? (Sides parallel to front of turtle)")
        w = inputNum()
        print("Height?")
        h = inputNum()
    else
        d = getArg(2)
        w = getArg(3)
        h = getArg(4)
    end

    box(d, w, h)
elseif choice == "platform" then
    local d, w
    if doText then
        print("Place turtle in bottom left corner.")
        print("-----------------------------------")
        print("Depth? (Sides perpendicular to front of turtle)")
        d = inputNum()
        print("Width? (Sides parallel to front of turtle)")
        w = inputNum()
    else
        d = getArg(2)
        w = getArg(3)
    end

    platform(d, w)
elseif choice == "lineup" then
    local h, d
    if doText then
        print("Height?")
        h = inputNum()
        print("Go down after? y/n")
        local r = inputStr()
        if r == "y" or r == "yes" then
            d = true
        elseif r == "n" or r == "no" then
            d = false
        else
            print("Boolean error, will go down")
            d = false
        end
    else
        h = getArg(2)
        d = getArg(3)
    end

    lineUp(h, d)
elseif choice == "linedown" then
    local h
    if doText then
        print("Height (Depth)?")
        h = inputNum()
    else
        h = getArg(2)
    end

    lineDown(h)
else
    if doText then
        print("Not an option")
    else
        print("Arguments error")
        print("Use unbuild with no arguments if you don't know what you're doing")
    end
    error()
end
