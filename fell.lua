local tArgs = { ... }
---@diagnostic disable-next-line: undefined-field
os.loadAPI("JoshAPI.lua")

local function fell2()
  local height = 1

  turtle.dig()
  JoshAPI.forward()
  while turtle.detectUp() or turtle.detect() do
    turtle.dig()
    turtle.digUp()
    JoshAPI.up()
    height = height + 1
  end
  turtle.turnRight()
  turtle.dig()
  JoshAPI.forward()
  turtle.turnLeft()
  while height > 1 do
    turtle.dig()
    turtle.digDown()
    JoshAPI.down()
    height = height - 1
  end
  turtle.dig()
  JoshAPI.back()
  turtle.turnLeft()
  JoshAPI.forward()
  turtle.turnRight()

  if tostring(tArgs[1]) == "chest" or tostring(tArgs[2]) == "chest" then
    turtle.turnLeft()
    for i = 1, 16 do
      turtle.select(i)
      if turtle.getItemCount(i) > 0 then
        turtle.drop()
      end
    end
    turtle.turnRight()
  end
end

local function fell1()
  local height = 1

  turtle.dig()
  JoshAPI.forward()
  while turtle.detectUp() do
    turtle.digUp()
    JoshAPI.up()
    height = height + 1
  end

  while height > 1 do
    turtle.digDown()
    JoshAPI.down()
    height = height - 1
  end
end

local which = tostring(tArgs[1])
if which == "1" or which == "small" then
  fell1()
elseif which == "2" or which == "chest" then
  fell2()
else
  fell2()
end
