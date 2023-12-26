-- General API
-- ...
-- Helper functions and whatnots
-- Mostly by Josh, if not is probably noted
--
-- os.loadAPI("JoshAPI.lua")

version = 0.4 --Very arbitrary

--For prevent and allow termination
osPullEvent = os.pullEvent

math.randomseed(os.time() * os.day() * math.random())
math.random(); math.random(); math.random();

function getVersion()
	return version
end

function refuel() --Turtle
	if not turtle then return false end

	local fuelLevel = turtle.getFuelLevel() --Note this is from built in turtle programs (excavate, tunnel)
	if fuelLevel == "unlimited" or fuelLevel > 0 then
		return
	end

	local function tryRefuel()
		for n=1,16 do
			if turtle.getItemCount(n) > 0 then
				turtle.select(n)
				if turtle.refuel(1) then
					turtle.select(1)
					return true
				end
			end
		end
		turtle.select(1)
		return false
	end

	if not tryRefuel() then
		print( "Add more fuel to continue." )
		while not tryRefuel() do
			sleep(1)
		end
		print( "Resuming." )
	end
end

function cleanTerm()
	term.clear()
	term.setCursorPos(1,1)
end

function forward(num) --Turtle
	if not turtle then return false end

	refuel()
	if num == nil or num <= 0 then num = 1 end
	for x = 1, num do
		if not turtle.forward() then
			print("Obstruction")
			sleep(1)
			forward()
		end
	end
end

function back(num) --Turtle
	if not turtle then return false end

	refuel()
	if num == nil or num <= 0 then num = 1 end
	for x = 1, num do
		if not turtle.back() then
			print("Obstruction")
			sleep(1)
			back()
		end
	end

end

function up(num) --Turtle
	if not turtle then return false end

	refuel()
	if num == nil or num <= 0 then num = 1 end
	for x = 1, num do
		if not turtle.up() then
			print("Obstruction")
			sleep(1)
			up()
		end
	end
end

function down(num) --Turtle
	if not turtle then return false end

	refuel()
	if num == nil or num <= 0 then num = 1 end
	for x = 1, num do
		if not turtle.down() then
			print("Obstruction")
			sleep(1)
			down()
		end
	end
end

function forwardA(num) --Turtle --A for agressive
	if not turtle then return false end

	refuel()
	if num == nil or num <= 0 then num = 1 end
	for x = 1, num do
		if not turtle.forward() then
			if turtle.detect() then
				turtle.dig()
			else
				turtle.attack()
			end
			forwardA()
		end
	end
end

function upA(num) --Turtle --A for agressive
	if not turtle then return false end

	refuel()
	if num == nil or num <= 0 then num = 1 end
	for x = 1, num do
		if not turtle.up() then
			if turtle.detectUp() then
				turtle.digUp()
			else
				turtle.attackUp()
			end
			upA()
		end
	end
end

function downA(num) --Turtle --A for agressive
	if not turtle then return false end

	refuel()
	if num == nil or num <= 0 then num = 1 end
	for x = 1, num do
		if not turtle.down() then
			if turtle.detectDown() then
				turtle.digDown()
			else
				turtle.attackDown()
			end
			downA()
		end
	end
end

function dropThings(from, to) --Turtle
	if not turtle then return false end

	if from == nil or from < 1 then from = 1 end
	if to == nil or to > 16 then to = 16 end
	
	for i=from,to do
		turtle.select(i)
		turtle.drop()
	end
	turtle.select(1)
end

function parse(x)
	--Designed for arguments
	--Basicly change unknown/string type into proper type (bool, int, str)
	if x == nil then --its nothing
		return nil, nil
	elseif tonumber(x) ~= nil then --its a number
		return tonumber(x), "number"
	elseif string.lower(tostring(x)) == "true" then --its boolean true
		return true, "boolean"
	elseif string.lower(tostring(x)) == "false" then --its boolean false
		return false, "boolean"
	else --must be string
		return string.lower(tostring(x)), "string"
	end
end

function preventTermination(a)
	if a == false then --another way of disabling
		allowTermination()
	else
		os.pullEvent = os.pullEventRaw
	end
end

function allowTermination()
	os.pullEvent = osPullEvent
end

function getPeripherals(pType)
	local foundPs = {} --Contains number and side of peripheral
	local foundType = {} --Contains number and side of specific peripherals
	local sides = redstone.getSides() --Top, Right, Front, etc

	--Get peripherals on sides
	for s=1,#sides do
		if peripheral.isPresent(sides[s]) then
			foundPs[#foundPs+1] = sides[s]
		end
	end

	--Get peripherals on wired modems
	for p=1,#foundPs do
		if peripheral.getType(foundPs[p]) == "modem" then
			modem = peripheral.wrap(foundPs[p])
			if not modem.isWireless() then --Wireless modems do not have peripheral abilitys
				local modemPs = modem.getNamesRemote() --Get peripherals on modem
				for x=1, #modemPs do
					foundPs[#foundPs+1] = modemPs[x]
				end
			end
		end
	end

	if pType == nil then --Not looking for specific type
		return foundPs
	else
		for pNum, pName in ipairs(foundPs) do
			if peripheral.getType(foundPs[pNum]) == pType then
				foundType[#foundType + 1] = pName
			end
		end
		return foundType
	end
end

function password(pass)
	print("Enter Password to access controls.")
	t = read("*")
	if t == pass then
		print("Access Granted.")
		sleep(2)
		return true
	else
		print("WRONG!")
		sleep(2)
		return false
	end
end

function cleanMonitors(mons)
	for x=1, #mons do
		if peripheral.isPresent(mons[x]) then --dont crash if monitor was removed
			mon=peripheral.wrap(mons[x])
			local old = term.redirect(mon)

			cleanTerm()
			
			term.redirect(old)
		end
	end
end

function monitorsPrint(mons, text)
	for x=1, #mons do
		if peripheral.isPresent(mons[x]) then --dont crash if monitor was removed
			mon=peripheral.wrap(mons[x])
			monitorPrint(mon, text)
		end
	end
end

function monitorPrint(mon, text)
	local old = term.redirect(mon)

	print(text)
	term.redirect(old)
end

function pause()
	print("Press any key to continue.")
	os.pullEvent("key")
end

function choose(t)
	return t[math.random(#t)]
end

local funMessages = {
	--Robot like
	"Greetings, human.",
	"Awaiting input.",
	"Ready for instructions.",
	"Your wish is my command, assuming it is within normal operational parameters.",
	"How can I help you?",
	"'A robot must obey the orders given to it by human beings'",
	"System Status: Fully functional",
	"System Status: Ok",
	"System Status: Unsure, check later",
	"System Status: Missing some startup messages",
	"System Status: N/A",
	"System Status: Redstone error detected",
	"CraftOS [Version number]",
	"No bootable device -- insert boot disk and press any key",
	"The SMART hard disk check has detected an imminent failure.", --To ensure not data loss, please backup the content immediately and run the Hard Disk Test in System Diagnostics.",
	"F2 - System Diagnostics",
	"ENTER - Continue Startup",
	"Current mode: Safe Mode with Command Prompt",
	"Startup message currently unavailable.",
	"Press 'I' to enter interactive startup.",
	"Done (0.110s)",
	"I/O Buffer error at logical block 6005782",
	"OpenGL Error: 1286 (Invalid framebuffer operation)",
	"57 fps, 133 Chunk updates",
	"Press any key to continue.",
	"-----BEGIN PGP SIGNED MESSAGE-----",

	--Generic/Random
	"Hello.",
	"0110100001101001",
	"How are you today?",
	"The world time is currently " .. os.time(),
	"...!",
	"I've been waiting for you",
	"Behind you!",
	"WARNING: Refrences unlikely to be recognized detected in startup messages.",
	"This is a startup message.",
	"Hoc est satus nuntiante.",
	"Este es un mensaje de inicio.",
	"'12345' is not a secure password.",
	"Ceci n'est pas une startup message!",
	"Cogito ergo sum",
	"Nice to meet you!",
	"We meet again.",
	"3.1415926535",
	math.random(),
	"Press Ctrl+R",
	"You were expecting a message here, wern't you?",
	"2==10",
	"Don't fall!",
	"Can you dig it?",
	"What would you do?",
	"Checkmate.",
	"Where?",
	"Deliquescence is cool!",
	"I'm tired.",

	--Latin
	"Ante meridiem",
	"Post meridiem",
	"In omnia paratus",
	"Corruptissima re publica plurimae leges",
	"Bono malum superate",
	"Barba non facit philosophum",
	"Quidquid Latine dictum sit altum videtur",
	"Quis custodiet ipsos custodes?",

	--References
	"Beam me up, scotty!",
	"Engage.",
	"Make it so.",
	"WARNING - Missile inbound!",
	"Startup messages over 9000! (Not really)",
	"This is not the startup message you are looking for.",
	"Seeking Admin...",
	"0101000101110101011010010111001100100000011000110111010101110011011101000110111101100100011010010110010101110100001000000110100101110000011100110110111101110011001000000110001101110101011100110111010001101111011001000110010101110011",
	"I know!",
	"You know!",
	"I'm not telling the truth!",
	"I know, you know!",
	"They just don't have any proof!",
	"Embrace the deception!",
	"Learn how to bend!",
	"Your worst inhibitions tend to psych you out in the end!",
	"Bazinga!",

	--Harry Potter
	"I will have order.",
	"I must not tell lies.",
	"A lonely, winding road at twilight",

	--Song References
	--Beatles
	--
	"Could you read my book?",
	"It took me years!",
	"Could you take a look?",
	"Based on a novel!",
	"I need a job!",
	"I want to be a paperback writer!",
	"He wants to be a paperback writer!",
	"A thousand pages, give or take a few!",
	"I'll be writing more in a week or two!",
	"You can make a million overnight!",

	--
	"Picture yourself in a boat in a river!",
	"Tangerine trees!",
	"Marmalade skies!",
	"You hear someone call you!",
	"Answer quite slowly!",
	"Kaleidoscope eyes!",
	"Yellow and green!",
	"Towering over your head!",
	"Look for the girl!",
	"She's gone!",
	"In the sky!",
	"With diamonds!",
	"A bridge by a fountain!",
	"Rocking horse people!",

	--
	"Desmond has his barrow in the marketplace",
	"Molly is the singer in a band.",
	"I like your face!",
	"Take a trolley to the jewelry store!",
	"Buy a twenty-carat golden ring!",
	"Desmond lets the children lend a hand.",

	--
	"Sitting on a cornflake!",
	"Get a tan from standing in the english rain!",
	"See how they run!",
	"See how they fly!",
	"Like lucy in the sky!",
	"Don't you think the joker laughs at you?",

	--
	"Look at all the people!",
	"Where do they all come from?",
	"Where do they all belong?",
	"In a jar by the door!",
	"Who is it for?",
	"No one will hear!",
	"No one comes near!",
	"Look at him working!",
	"When there's nobody there!",
	"What does he care?",
	"Nobody came!",
	"No one was saved!",

	--
	"Get back!",
	"Where you once belonged!",
	"Thought he was a loner!",
	"He knew it couldn't last!",
	"Left his home!",

	--
	"Let me tell you how it will be!",
	"There's one for you, nineteen for me!",
	"I'm the taxman!",
	"Does five percent appear too small?",
	"Be thankful I don't take it all!",
	"I'll tax the street!",
	"I'll tax your seat!",
	"I'll tax the heat!",
	"I'll tax your feet!",
	"Don't ask me what I want it for!",

	--
	"What would you think?",
	"I sang out of tune!",
	"Lend me your ears!",
	"I'll sing you a song!",

	--
	"The man of a thousand voices is talking perfectly loud!",
	"Nobody ever hears him!",
	"He never listens to them!",

	--
	"Here comes old flatop!",
	"He come groovin' up slowly!",

	--
	"It's coming to take you away!",

	--
	"Lady Maddonna!",
	"Children at your feet!",
	"Wonder how you manage to make ends meet!",
	"Who finds the money?",
	"Who finds the money when you pay the rent?",
	"Did you think that money was heaven sent?",

	--
	"Lets all get up and dance to a song!",
	"It was a hit before your mother was born!",
	"Your mother should know!",

	--
	"Don't let me down!",



	--Pink Floyd
	--
	
	--Wish You Were Here
	"Welcome, my son!",
	"Welcome to the machine!",
	"Where have you been?",
	"It's alright!",
	"We know where you've been!",
	"You know you're nobody's fool!",

	--
	"Come in here!",
	"Dear boy!",
	"Have a cigar!",
	"You're gonna go far!",
	"You're gonna fly high!",
	"You're never gonna die!",
	"You're gonna make it if you try!",
	"They're gonna love you!",
	"I've always had a deep respect!",
	"Most sincerely!",
	"The band is just fantastic!",
	"That is really what I think!",
	"Oh, by the way...",
	"Which ones pink?",
	"The name of the game!",
	"Riding the gravy train!",

	--
	"Wish you were here!",
	"So...",
	"You think you can tell?",
	"Blue skys!",
	"A green field!",
	"A cold steel rail!",
	"Did you exchange?",
	"Two lost souls!",
	"Swimming in a fishbowl!",
	"Year after year!",
	"The same old ground!",
	"What have we found?",

	--The Dark Side of the Moon
	--
	"Ticking away!",
	"The moments!",
	"A dull day!",
	"Fritter and waste!",
	"The hours!",
	"An offhand way!",
	"Kicking around!",
	"A piece of ground!",
	"Your hometown!",
	"Ten years have gone behind you",
	"No one told you when to run",
	"You missed the starting gun!",
	"You run and you run!",
	"Catch up to the sun!",
	"It's sinking!",
	"The time is gone!",
	"The song is over!",
	"I like to be here when I can",
	"Beside the fire!",
	
	--
	"Money!",
	"It's a gas!",
	"Grab that cash!",
	"Make a stash!",
	"New car, caviar!",
	"Think I'll buy me a football team!",
	"So they say!",
	"I need a lear jet!",
	
	--
	"Us and them!",
	"We're only ordinary men!",
	"Me and you!",
	"Not what we would choose!",
	"Forward, he cried!",
	"The front rank died!",
	"The general sat!",
	"The lines on the map!",
	"From side to side!",
	"Black and blue!",
	"Who knows which is which?",
	"Who is who?",
	"Up and down!",
	"Round and round!",
	"Haven't you heard?",
	"Its a battle of words!",
	"Listen, son!",
	"There's room for you inside!",
	"Out of my way!",
	"It's a busy day!",
	"I've got things on my mind!",
	
	--
	"Any colour you like!",
	"You can have any color you like, as long as it's black!",
	"You can have any color you like, but they're all blue!",
	
	--The Wall
	--
	"You! Yes, you!",
	"Stand still laddie!",
	
	--
	"What shall we use to fill the empty spaces?",
	"Where we used to talk!",
	"How shall I fill the final spaces?",
	"How should I complete the wall!",
	
	--
	"I am just a new boy!",
	"A stranger in this town!",
	"Where are all the good times?",
	"Who's gonna show this stranger around?",
	
	--
	"Run to the bedroom!",
	"The suitcase on the left!",
	"My favorite axe!",
	"Don't look so frightened!",
	"This is just a passing phase!",
	"One of my bad days!",
	"Why are you running away?",
	
	--
	"Don't leave me now!",
	
	--
	"Hey you...",
	"Out there in the cold!",
	"Getting lonly!",
	"Getting old!",
	"Can you feel me?",
	"Standing in the aisles!",
	"Itchy feet!",
	"Fading smiles!",
	"Don't give in without a fight!",

	--
	"Is there anybody out there?",
	
	--
	"Time to go!",
	
	--
	"Is there anybody in there?",
	"Just nod if you can hear me!",
	"Is there anyone home?",
	"Come on, now!",
	"I hear you're feeling down.",
	"I can ease your pain!",
	"On your feet again!",
	"Relax.",
	"I need some information first!",
	"Just the basic facts!",
	"Can you show me where it hurts?",
	"When I was a child!",
	
	--
	"The show must go on!",
	
	--
	"I've got some bad news for you sunshine...",
	"Pink isn't well, he stayed back at the hotel!",
	
	--
	"Good evening!",
	"Caught red-handed!",
	"Showing feelings!",
	"An almost human nature!",
	"This will not do.",
	"They must have taken my marbles away!",
	"Crazy!",
	"Toys in the attic!",



	--Talking Heads
	--
	
	--Stop Making Sense
	"Face up to the facts!",
	"Can't relax!",
	"Don't touch me!",
	"I'm a live wire!",
	"Qu'est-ce que c'est?",

	--
	"Nothing ever happens!",

	--
	"You can talk just like me!",
	"Show me what you can do!",

	--
	"What a bad picture!",
	"Don't get upset!",
	"It's not a major disaster!",
	"I don't know whats the matter!",
	"I don't know why you bother!",
	"The way it seems to me...",
	"Making up their own shows!",
	"Putting them on TV!",

	--
	"You must be having fun!",
	"What's the matter with him?",

	--
	"Watch out!",
	"You might get what you're after!",
	"Cool babies!",
	"Strange but not a stranger!",
	"I'm an ordinary guy!",
	"Hold tight!",
	"Wait 'til the party's over!",
	"We're in for nasty weather!",
	"There has got to be a way!",
	"Heres your ticket, pack your bag!",
	"Transportation is here!",
	"I don't know what you expect!",
	"Staring into the TV set!",
	"Fighting fire with fire!",

	--
	"Packed up and ready to go!",
	"A place where nobody knows!",
	"I'm getting used to it now!",
	"This ain't no party!",
	"This ain't no disco!",
	"This ain't no foolin' around!",
	"I ain't got time for that now!",
	"Transmit the message!",
	"To the receiver!",
	"Don't even know my real name!",
	"Everything's ready to roll!",
	"Ain't got no speakers!",
	"Ain't got no headphones!",
	"Ain't got no records to play!",
	"Don't get exhausted!",
	"I'll do some driving!",
	"You ought to get you some sleep!",

	--
	"Wait a minute!",
	"Everybody!",
	"Get in line!",
	"Nothing can come between us!",
	"Nothing gets you down!",
	"Nothing strikes your fancy!",
	"We don't have to wait!",
	"Everything looks impressive!",
	"Do not be deceived!",
	"No one makes a monkey out of me!",
	"Lie on our backs!",
	"Feet in the air!",
	"Rest and relaxation!",
	"Snap into position!",
	"Step out of line!",
	"Check this out!",
	"Don't be so slick!",
	"We have nothing in our pockets!",
	"Makin' flippy floppy!",
	"Tryin' to do my best!",
	"Lock the door!",
	"We kill the beast!",
	"Kill it!",

	--
	"Let me tell you a story!",
	"No dust!",
	"No rocks!",
	"Let's go!",
	"Click Click!",
	"See ya later!",
	"No time to rest!",
	"Risky business!",

	--
	"I'm dressed up so nice!",
	"I'm doing my best!",
	"I'm starting over!",
	"Starting over in another place!",
	"Big chief with a golden crown!",
	"Rings on his fingers!",

	--
	"Home is where I want to be!",
	"I love the passing of time!",
	"Did I find you or you find me?",
	"You got a face with a view!",

	---
	"Letting the days go by!",
	"How do I work this?",
	"Same as it ever was!",

	--
	"I'm gonna have some fun!",

	--
	"Who took the money?",
	"Who took the money away?",
	"It's always showtime!",
	"Here at the edge of the stage!",
	"Wake up and wonder!",
	"What was the place?",
	"What was the name?",

	--
	"I don't know why you treat me so bad!",

	--
	"Lost my shape!",
	"Trying to act casual!",

	--Remain in Light
	--
	"Hands of a government man!",
	"I'm a tumbler!",
	
	--
	"The overload!",

	--77
	--
	"I wanna talk!",
	"I wanna talk as much as I want!",
	"It's a hard logic!",

	--Naked
	--
	"If this is paradise, I wish I had a lawnmower!",
	"As things fell apart, nobody paid much attention!",
	"We used to microwave!",
	"I can't get used to this lifestyle!",
	
	--
	"Chilly willy!",
	"Mommy Daddy You and I!",
	"Driving!",
	"Keep driving!",
	"Driving with all of our might!",
	"Saying it don't make it so!",
	
	--
	"Falling!",
	"Gonna drop like a stone!",
	"Falling through the atmosphere!",
	"A warm afternoon!",
	"Please hold me!",
	"It's a dangerous life!",
	"Let's get out of here!",
	"I'm scared!",
	"Nighttime in New York!",
	"It's weird!",
	"If you're looking for trouble, that's what you will find!",
	"Kills you in your sleep!",
	"Criminals that never broke no laws!",
	"Furniture with legs!",
	"Going home!",
	"Back where I belong!",
	"To stay!",
	"Rays of light!",
	"Birds travel together!",
	"Brids follow the sun!",

	--Fear of music
	--
	"I need something to change your mind!",
	
	--
	"Find myself a city!",
	"Find myself a city to live in!",

	--True Stories
	--
	"I'm wearking fur pajamas!",
	"Speak up!",
	"I can't hear you!",
	"Up on this mountain top!",
	"Check out mister businessman!",
	"On the way to the stock exchange!",
	"Things fall apart!",
	"It's scientific!",
	"Spending all of my money and time!",
	"Wild Wild Life!",
	
	--Little Creatures
	--
	"We know where we're going!",
	"We don't know where we've been!",
	"We know what we're knowing!",
	"We can't say what we've seen!",
	"We're not little children!",
	"We know what we want!",
	"The future is certain!",
	"Give us time to work it out!",
	"We're on a road to nowhere!",
	"Come on inside!",
	"Takin' that ride to nowhere!",
	"We'll take that ride!",
	"Feeling okay this morning!",
	"You know!",
	"We're on the road to paradise!",
	"Here we go!",
	"There's a city in my mind1",
	"Come along and take that ride!",
	"It's alright!",
	"It's very far away!",
	"Growing day by day!",
	"They'll make a fool of you!",
	
	
	
	--David Bowie
	--
	"It's no game!",

	--
	"Scary monsters!",
	"Super creeps!",

	--
	"Fashion!",
	"Beep Beep!",

	--
	"Take your protein pills!",
	"Put your helmet on!",
	"Commencing countdown!",
	"Engines on!",
	"You've really made the grade!",
	"Whose shirts do you wear?",
	"Far above the world!",

	--
	"I'm an alligator!",
	"I'm a moma-papa coming for you!",

	--
	"Hang on to yourself!",

	--
	"I look into your eyes and I know you won't kill me!",
	
	--
	"You remind me of the babe!",
	"What babe?",
	"The babe with the power!",
	"What power?",
	"The power of voodoo!",
	"Who do?",
	"You do!",
	"Do what?",
	"I saw my baby!",
	"Crying hard as babe could cry!",
	"What could I do?",
	"Nobody knew!",
	
	--
	"Fame!",
	
	--
	"Put on your red shoes!",
	"Dance the blues!",
	
	--
	"Lost my job!",
	"I think she's dancing!",
	"I am a DJ!",
	"I am what I play!",



	--Jethro Tull
	--
	"Walking though forests!",
	"Palm tree apartments!",
	"Scoff at the monkeys!",
	"Dark tents!",
	"Down by the waterhole!",
	"Saving their rasins for Sunday!",
	"They're fast but they're lazy!",
	"Thats alright by me!",

	--
	"The shuffling madness!",
	"The all-time loser!",
	"Headlong to his death!",
	"Feel the piston scraping!",
	"Steam breaking on his brow!",
	"He stole the handle!",
	"The train!",
	"It won't stop going!",
	"No way to slow down!",
	"The train, it won't stop going!",

	--
	"Sitting on the park bench!",
	"Greasy fingers smearing shabby clothes!",
	"Drying in the cold sun!",
	"Feeling like a dead duck!",
	"Do you still remember?",
	"Decembers foggy freeze!",
	"The ice that clings on to your beard!",
	"Deep sea diver sounds!",
	"The flowers bloom like madness in the spring!",
	"Sun steaking cold!",
	"An old man wandering lonely!",
	"Taking time the oly way he knows!",
	"Leg hurting bad!",
	"He bends to pick a dog end!",
	"Feeling alone!",
	"The armys up the road!",
	"Salvation a la mode!",
	"A cup of tea!",
	"Aqualung, my friend!",
	"Don't you start away uneasy!",
	"You poor old sod!",

	--
	"Really don't mind if you sit this one out!",
	"My words are a whisper!",
	"I may make you feel, but I can't make you think!",
	"The youngest of the famliy!",
	"Moving with authority!",
	"Rings upon your fingers!",

	--
	"Nothing is easy!",



	--Elton John
	--
	"Hey, kids!",
	"Share the news together!",
	"Known to change the weather!",
	"Solid walls of sound!",
	"Have you seen them yet?",
	
	--
	"It's like trying to find gold in a silver mine!",
	"It's like trying to drink whiskey from a bottle of wine!",
	
	--
	"Can't lock me in your penthouse!",
	
	--
	"Mars isn't the kind of place to raise your kids!",



	--Queen
	--
	"Is this the real life?",
	"Look up to the sky!",

	--
	"I want to ride my bicicle!",
	"Where I like!",

	--
	"Listen to the wise man!",

	--
	"Tonight!",
	"Im gonna have myself a real good time!",

	--
	"Do you feel good?",
	"Are you satisfied?",
	"Is your conscience all right?",
	"Does it plague you at night?",



	--ELO
	--
	"Mr. Blue Sky!",
	"Please tell us why!",
	"You had to hide away!",
	"For so long!",
	"Where did we go wrong!",
	"Hey you with the pretty face!",
	"Welcome to the human race!",

	--
	"She cried to the southern wind!",
	"Headin' for a Showdown!",
	"It's raining!",
	"All over the world!",
	
	--
	"You're looking good!",
	"Just like a snake in the grass!",



	--Black Sabbath
	--
	"What is this?",
	"Figure in black!",
	"Points at me!",
	"Turn round quick!",
	"Start to run!",
	"I'm the chosen one!",
	"Oh no!",
	"Big black shape!",
	"Eyes of fire!",
	"Telling people their desire!",

	--
	"Misty morning, clouds in the sky!",
	"Without warning!",
	"A wizard walks by!",
	"Casting his shadow!",
	"Weaving his spell!",
	"Funny clothes!",
	"Tinkining bell!",
	"Never talking!",
	"Just keeps walking!",
	"Spreading his magic!",

	--
	"Late last night!",
	"I got a fright!",
	"You gotta believe me!",



	--Billy Joel
	--
	"It's nine o' clock on a Saturday!",
	"The regular crowd shuffles in!",
	"He's quick with a joke!",

	
	
	--The Moody Blues
	--
	"Why do we never get an answer?",
	"It's not the say that you say it...",
	"It's more the way that you mean it!",
	"I'm looking for someone to change my life!",
	"I'm looking for a miricale in my life!",
	
	--
	"How is it we are here?",
	"On this path we walk!",
	"Mens mighty mine machines!",
	"Digging in the ground!",
	"Stealing rare minerals!",
	"Where they can be found!",

	--
	"Ask the mirror on the wall!",
	"Whos the biggest fool of all!",
	
	--
	"Its alright!",
	
	--
	"It's up to you!",
	
	--
	"A beam of light will fill your head!",
	
	
	--The Eagles
	--
	"A dark desert highway!",
	"Cool wind in my hair!",
	"Rising up through the air!",
	"Up ahead in the distance!",
	"I saw a shimmering light!",
	"My head grew heavy and my sight grew dim!",
	"I had to stop for the night!",
	"There she stood in the doorway!",
	"I heard the mission bell!",
	"This could be heaven or this could be hell!",
	"She light up a candle!",
	"She showed me the way!",
	"Voices down the corridor!",
	"I thought I heard them!",
	"Welcome to the Hotel California!",
	"Such a lovey place!",
	"Any time of year!",
	"You can find it here!",
	"She got the Mercedes bends!",
	"They dance in the courtyard!",
	"Some dance to remember!",
	"Some dance to forget!",
	"Please bring me my wine!",
	"We haven't had that spirit here since nineteen sixty nine!",
	"Wake you up in the middle of the night!",
	"We are all just prisioners here!",
	"Of our own device!",
	"In the master's chambers!",
	"They gather for the feast!",
	"Stab it with their steely knives!",
	"Just can't kill the beast!",
	"Running for the door!",
	"Find the passage back!",
	"The place I was before!",
	"'Relax', said the night man!",
	"We are programmed to receive!",
	"You can check-out any time you like!",
	"You can never leave!",
	
	--Other
	--
	"Kinghts in armor!",
	"Something about a queen!",

	--
	"Is it any wonder I'm not crazy?",
	"Is it any wonder I'm not a criminal?",
	"Is it any wonder I'm not in jail?",
	"Is it any wonder I'm not the president?",
	"Is it any wonder I've got too much time on my hands!",
	"Ticking away with my sanity!",
	"I can solve all the world's problems, without even trying!",
	"The fun never ends!",
	
	--
	"A modern day warrior!",
	"Mean, mean stride!",
	"Mean, mean pride!",
	"His mind is not for rent!",
	"Don't put him down as arrogant!",

	--
	"I feel free!",

	--
	"Bird is the word!",

	--
	"The rain exploded with a mighty crash!",
	"We fell into the sun!",

	--
	"Writing on the wall!",

	--
	"Could you go along with someone like me?",
	"I did before!"
}

function getFunMessages()
	return funMessages
end
