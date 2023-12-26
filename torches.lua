os.loadAPI("JoshAPI.lua")
local tArgs = { ... }

function slot()
    function trySlot()
        for n=2,16 do
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

if tArgs == nil then
    print("Usage: torches <length> [every]")
    error()
end

if #tArgs > 2 then
    print("Usage: torches <length> [every]")
    error()
end

length = tonumber(tArgs[1])
e = tonumber(tArgs[2])

if length == nil then
    print("Usage: torches <length> [every]")
    error()
end

if e == nil or e == 0 then
    e = 2
end

--turtle.up()

for l = 0, length do
    if l%e == 0 then
        refuel()
        slot()
        turtle.placeDown()
    end
    JoshAPI.forward()
end
