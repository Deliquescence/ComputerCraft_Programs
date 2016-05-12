os.loadAPI("JoshAPI")
local tArgs = { ... }

turtle.select(1)

if #tArgs == 1 then
	distance = JoshAPI.parse(tArgs[1])
else
	print("Starts by digging block below")
	print("Enter distance")
	distance=io.read()
end

for i=1, distance do
    while turtle.detectUp() do
        turtle.digUp()
        sleep(0.5)
    end
    turtle.digDown()
    JoshAPI.refuel()
    turtle.down()
    while turtle.detect() do
        turtle.dig()
        sleep(0.5)
    end
    JoshAPI.refuel()
	if not turtle.detectDown() then
		turtle.placeDown()
	end
    turtle.forward()
end