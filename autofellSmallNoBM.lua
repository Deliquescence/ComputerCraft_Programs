os.loadAPI("JoshAPI.lua")

function fell()
	local height = 1
	
	turtle.dig()
	JoshAPI.forward()
	turtle.suck()
	while turtle.detectUp() do
		turtle.digUp()
		JoshAPI.up()
		turtle.suck()
		height = height+1
	end

	while height > 1 do
		turtle.digDown()
		JoshAPI.down()
		turtle.suck()
		height = height - 1
	end 
	
	turtle.suck()
	JoshAPI.back()
end

--Return true if ready to harvest
function detectAndSapling()
	turtle.select(saplingSlot)
	if turtle.getItemCount(saplingSlot) <= 0 then
		print("Fatal: out of saplings")
		error()
	else
		if turtle.detect() then
			return not turtle.compare() --not (block is sapling)
		else
			while not turtle.place() do end --place until succeed
			return false
		end
	end
end

function chest()
	turtle.turnRight()
	turtle.suck()
	turtle.turnRight()
	if turtle.detect() then
		JoshAPI.dropThings(3,16)
	end
	turtle.turnRight()
	turtle.suck()
	turtle.turnRight()
end

JoshAPI.cleanTerm()

saplingSlot = 2
print("Auto Felling (small) Program (no bonemeal)")
print("Fuel in slot 1")
print("Saplings in slot " .. saplingSlot)

local trees = 0
while true do 
	if detectAndSapling() then
		fell()
		trees=trees+1
		print("Harvested " .. trees .. " trees")
		chest()
		detectAndSapling() --Place sapling
	end
	os.sleep(30)
end
