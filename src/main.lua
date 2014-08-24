require("useful")
function love.load(arg)
	math.randomseed(os.time())
	require("drawlist")
	require("portal")
	require("player")
	require("torch")
	require("rock")

	messageThread = love.thread.newThread("threadedMove.lua")

	fudge = require("fudge")
	ts = fudge.new("tileset",{
			npot = true,
			batchSize = 100000
			})
	fudge.set({
		current = ts,
		monkey = true
	})
	ts.image:setFilter("nearest","nearest")
	http = require("socket.http")
	srv = require("httpSettings")
	if (love.filesystem.exists("myWorld.lua")) then
		require("myWorld")
	else 
		myID = http.request("http://"..srv.ip..":"..srv.port.."/new/")
		love.filesystem.write("myWorld.lua", "myID = '"..myID.."'")
	end
	mode = "new"
	scale = 2
	sw = love.graphics.getWidth()/scale
	sh = love.graphics.getHeight()/scale
	scrcanv =love.graphics.newCanvas(love.graphics.getWidth(),love.graphics.getHeight())
	rndcanv =love.graphics.newCanvas(sw,sh)
	litcanv =love.graphics.newCanvas(sw,sh)
	scrcanv:setFilter("nearest","nearest")
	rndcanv:setFilter("nearest","nearest")
	litcanv:setFilter("nearest","nearest")
	lighten = love.graphics.newShader("shaders/lighten.fs")
	pltshader = love.graphics.newShader("shaders/pallettise.fs")
	cols = {}
	table.insert(cols,pltshader)
	table.insert(cols,"colors")
	for i=1,15 do
		table.insert(cols,
			{math.random(),math.random(),math.random(),1}
		)
	end		
	sharecart = {
		pltshader,
		"colors",
		{148/256,146/256,76/256,1},
		{73/256,84/256,65/256,1},
		{4/256,174/256,204/256,1},
		{148/256,74/256,28/256,1},
		{60/256,136/256,38/256,1},
		{252/256,254/256,252/256,1},
		{95/256,57/256,31/256,1},
		{108/256,250/256,220/256,1},
		{144/256,144/256,158/256,1},
		{50/256,45/256,35/256,1},
		{28/256,62/256,68/256,1},
		{220/256,198/256,124/256,1},
		{28/256,70/256,36/256,1},
		{164/256,218/256,196/256,1},
		{4/256,92/256,156/256,1},
		{0,0,0,1}
	}
	local sc = {}
	for i,v in ipairs(sharecart) do
		sc[i] = v
	end
	useful.arrayToArgs(pltshader.send, sc)
	JSON = require("JSON")
	gstate = require "gamestate"
	game = require("game")
	gstate.registerEvents()
	gstate.switch(game)
end