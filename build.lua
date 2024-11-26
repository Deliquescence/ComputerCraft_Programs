---@diagnostic disable-next-line: undefined-field
os.loadAPI("JoshAPI.lua")

local tArgs = { ... }

local function getArg(num)
    local a = JoshAPI.parse(tArgs[num])
    if a == nil then
        print("Arugments error")
        print("Use build with no arguments if you don't know what you're doing")
        error()
    end
    return a
end

local function slot()
    local function trySlot()
        for n = 1, 15 do
            if turtle.getItemCount(n) > 0 then
                turtle.select(n)
                return true
            end
        end
        turtle.select(1)
        return false
    end

    if not trySlot() then
        print("Add more blocks to continue.")
        while not trySlot() do
            sleep(1)
        end
    end
end

local function placeUp()
    slot()
    turtle.placeUp()
end

local function placeDown()
    slot()
    turtle.placeDown()
end

local function place()
    slot()
    turtle.place()
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
        placeDown()
        JoshAPI.forward()
    end
    placeDown()
end

local function lineFromBelow(L)
    for i = 1, L - 1 do
        slot()
        placeUp()
        JoshAPI.forward()
    end
    placeUp()
end

local function lineUp(H, goDown)
    for i = 1, H do
        JoshAPI.up()
        placeDown()
    end

    if goDown then
        JoshAPI.forward()
        for i = 1, H do
            JoshAPI.down()
        end
    end
end

local function stairs(H)
    for i = 1, H - 1 do
        placeDown()
        JoshAPI.up()
        JoshAPI.forward()
    end
    placeDown()
end

local function stairsDown(H)
    for i = 1, H - 1 do
        placeDown()
        JoshAPI.forward()
        JoshAPI.down()
    end
    placeDown()
end

local function wallA(L, H)
    for i = 1, L - 1 do
        lineUp(H, true)
    end
    lineUp(H, false)
end

local function wallB(L, H)
    JoshAPI.up()
    for i = 1, H - 1 do
        line(L)
        JoshAPI.up()
        turtle.turnRight()
        turtle.turnRight()
    end
    line(L)
end

local function box(D, W, H, makeRoof)
    local function getDown()
        turtle.turnRight()
        JoshAPI.forward()
        for x = 1, H do
            JoshAPI.down()
        end
    end

    wallA(D, H)
    getDown()

    wallA(W - 1, H)
    getDown()

    wallA(D - 1, H)
    getDown()

    wallA(W - 2, H)
    JoshAPI.forward()
    turtle.turnRight()

    if makeRoof then
        platform(D, W)
    end
end

local function platform(L, W)
    for i = 1, W - 1 do
        line(L)
        if i % 2 == 1 then
            turtle.turnRight()
            JoshAPI.forward()
            turtle.turnRight()
        elseif i % 2 == 0 then
            turtle.turnLeft()
            JoshAPI.forward()
            turtle.turnLeft()
        end
    end
    line(L)
end

local function platformFromBelow(L, W)
    for i = 1, W - 1 do
        lineFromBelow(L)
        if i % 2 == 1 then
            turtle.turnRight()
            JoshAPI.forward()
            turtle.turnRight()
        elseif i % 2 == 0 then
            turtle.turnLeft()
            JoshAPI.forward()
            turtle.turnLeft()
        end
    end
    lineFromBelow(L)
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
    print("Shape maker")
    print("Fuel in slot 1")
    print("Materials in slots 2-16")
    print("-----------------------")
    print("What Shape?")
    print("Options:")
    print("line, wallA, wallB, box, platform, stairs, stairsDown, lineUp, lineFromBelow, platformFromBelow")

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
elseif choice == "linefrombelow" then
    local l
    if doText then
        print("Place turtle facing build direction.")
        print("------------------------------------")
        print("Length?")
        l = inputNum()
    else
        l = getArg(2)
    end
    lineFromBelow(l)
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
    stairs(h)
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
elseif choice == "walla" then
    local l, h
    if doText then
        print("Method A - build vertical line by line")
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
    wallA(l, h)
elseif choice == "wallb" then
    local l, h
    if doText then
        print("Method B - start from bottom layer and go up")
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
    wallB(l, h)
elseif choice == "box" then
    local d, w, h, r
    if doText then
        print("Place turtle in lower left corner.")
        print("----------------------------------")
        print("Depth? (Sides perpendicular to front of turtle)")
        d = inputNum()
        print("Width? (Sides parallel to front of turtle)")
        w = inputNum()
        print("Height?")
        h = inputNum()
        print("Roof? y/n")
        r = inputStr()
        if r == "y" or r == "yes" then
            r = true
        elseif r == "n" or r == "no" then
            r = false
        else
            print("Boolean error, no roof for you!")
            r = false
        end
    else
        d = getArg(2)
        w = getArg(3)
        h = getArg(4)
        r = getArg(5)
    end

    box(d, w, h, r)
elseif choice == "platform" then
    local l, w
    if doText then
        print("Place turtle in bottom left corner.")
        print("-----------------------------------")
        print("Length? (Sides perpendicular to front of turtle)")
        l = inputNum()
        print("Width? (Sides parallel to front of turtle)")
        w = inputNum()
    else
        l = getArg(2)
        w = getArg(3)
    end

    platform(l, w)
elseif choice == "platformfrombelow" then
    local l, w
    if doText then
        print("Place turtle in bottom left corner.")
        print("-----------------------------------")
        print("Length? (Sides perpendicular to front of turtle)")
        l = inputNum()
        print("Width? (Sides parallel to front of turtle)")
        w = inputNum()
    else
        l = getArg(2)
        w = getArg(3)
    end

    platformFromBelow(l, w)
elseif choice == "lineup" then
    local h, d
    if doText then
        print("Verical line")
        print("-----------------------------------")
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
else
    if doText then
        print("Not an option")
    else
        print("Arguments error")
        print("Use build with no arguments if you don't know what you're doing")
    end
    error()
end
