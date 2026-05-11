
local fuel = turtle.getFuelLevel()
while fuel < turtle.getFuelLimit() do
    turtle.suck()
    turtle.refuel()
    turtle.drop()
    os.sleep(1.23)
    fuel = turtle.getFuelLevel()
    print(fuel .. " / " .. turtle.getFuelLimit())
end
