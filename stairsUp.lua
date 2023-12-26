os.loadAPI("JoshAPI.lua")
local tArgs = { ... }

turtle.select(1)

if #tArgs == 1 then
	distance = JoshAPI.parse(tArgs[1])
else
    print("Starts by digging block above")
	print("Enter distance")
	distance=io.read()
end

for i=1, distance do
	while turtle.detectUp() do
		turtle.digUp()
		sleep(0.5)
	end
	JoshAPI.refuel()
	if not turtle.detectDown() then
		turtle.placeDown()
	end
	turtle.up()
	while turtle.detectUp() do
		turtle.digUp()
		sleep(0.5)
	end	
	while turtle.detect() do
		turtle.dig()
		sleep(0.5)
	end
	JoshAPI.refuel()
	
	turtle.forward()
end
