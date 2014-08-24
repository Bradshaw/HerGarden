local state = {}

function state:init()
end

function colors()
	cols = {}
	table.insert(cols,pltshader)
	table.insert(cols,"colors")
	--[[
	table.insert(cols,
		{0,0,0,1}
	)
	table.insert(cols,
		{1,1,1,1}
	)
	--]]
	local greys = math.random(1,10)
	for i=1,greys do
		table.insert(cols,
			{i/greys+math.random()/greys,i/greys+math.random()/greys,i/greys+math.random()/greys,1}
		)
	end
	local others = 31-greys
	for i=1,others do
		table.insert(cols,
			{math.random(),math.random(),math.random(),1}
		)
	end
	useful.arrayToArgs(pltshader.send, cols)
	baseheat = level.magic.baseheat
	extraheat = level.magic.extraheat
end


function state:enter( pre )
	drawlist = {}
	player.all = {}
	rock.all = {}
	torch.all = {}
	ts.batch:clear()
	baseheat = 20
	extraheat = 40
	if mode=="visit" then
		ldID = http.request("http://"..srv.ip..":"..srv.port.."/visit/"..myID)
	else
		ldID = myID
	end
	print(ldID)
	levelJSON = http.request("http://"..srv.ip..":"..srv.port.."/area/"..ldID)
	if levelJSON=="null" or not levelJSON then
		print("Errors")
		ldID = http.request("http://"..srv.ip..":"..srv.port.."/"..mode.."/")
		if mode=="new" then
			myID = ldID
			love.filesystem.write("myWorld.lua", "myID = '"..myID.."'")
		end
		gstate.switch(game)
		return
	end
	function doLevel()
		level = JSON:decode(levelJSON)
	end
	call, error= pcall(doLevel)
	if call then
		area = level.area
		for i,v in ipairs(level.items.movables) do
			if v.item == "rock" then
				rock.new(v.x, v.y, v.variant, v.id)
			end
			if v.item == "torch" then
				torch.new(v.x, v.y, v.id)
			end
		end
		for i=2,#torch.all do
			--torch.all[i].purge =true
		end
		portal.set(level.items.portal.x, level.items.portal.y)
		p = player.new(level.items.portal.x, level.items.portal.y+2)
		addtolist(portal)
		table.sort(drawlist,function(a,b)
			return a.y<b.y
		end)
			for j = 1,#area[1] do
			for i=1, #area do
				local ppdx = i-portal.x
				local ppdy = j-portal.y
				local ppd = math.sqrt(ppdx*ppdx+ppdy*ppdy)
				local u = area[i][j]
				local heat = math.max(0,math.min(1,(1-ppd/60)))
				ts.batch:setColor(255*heat,255*heat,255*heat)
				if u.tile=="g" then
					ts:addb("grass"..u.variant,i*10,j*8,0,1,1,5,8)
				end
			end
		end
		local cols = level.colors
		table.insert(cols, 1, "colors")
		table.insert(cols, 1, pltshader)
		useful.arrayToArgs(pltshader.send, cols)
	else
		love.errhand(error)
		love.event.push("quit")
		return
	end
	p.dx = 0
	p.dy = 0
end


function state:leave( next )
end


function state:update(dt)
	--pltshader:send("rseed", 1+love.timer.getTime()%1)
	player.update(dt)
	rock.update(dt)
	torch.update(dt)
	portal.update(dt)
end


function state:draw()
	local ppdx = p.x-portal.x
	local ppdy = p.y-portal.y
	local ppd = math.sqrt(ppdx*ppdx+ppdy*ppdy)
	local heat = 1--math.max(0,math.min(1,(1-ppd/60)))
	scrcanv:clear()
	rndcanv:clear()
	litcanv:clear()
	love.graphics.setCanvas(rndcanv)
	love.graphics.setShader()
	love.graphics.push()
	--[[]]
	local trx = math.floor(-p.x*10+5+sw/2)
	local try = math.floor(-p.y*8+4+sh/2)
	pltshader:send("rseed",love.math.noise( trx, try ))
	love.graphics.translate(
		trx,
		try
		)
	--]]

	love.graphics.draw(ts)

	drawthelist()
	love.graphics.pop()
	love.graphics.setCanvas(litcanv)
	love.graphics.setColor(baseheat*heat,baseheat*heat,baseheat*heat)
	love.graphics.setBlendMode("additive")
	love.graphics.rectangle("fill",0,0,sw,sh)
	love.graphics.setColor(extraheat*heat,extraheat*heat,extraheat*heat)
	love.graphics.draw(rndcanv)
	love.graphics.setShader(lighten)
	love.graphics.setColor(100,100,100)
	for i,v in ipairs(torch.all) do
		local rmult =
			love.math.noise(i,love.timer.getTime()*1)+0.125+
			love.math.noise(i,love.timer.getTime()*0.5)*0.25+
			love.math.noise(i,love.timer.getTime()*0.25)*0.5
		love.graphics.setColor(100,100,100,100+50*rmult)
		local lx = (trx+(v.x*10))
		local ly = (try+(v.y*8))
		lighten:send("lightX",lx)
		lighten:send("lightY",ly)
		lighten:send("lightmult",2.5+0.5*rmult)
		--love.graphics.setColor(v.r,v.g,v.b)
		love.graphics.draw(rndcanv)
		love.graphics.setColor(100,100,100,100+50*rmult)
		lighten:send("lightX",lx)
		lighten:send("lightY",ly)
		lighten:send("lightmult",5+0.5*rmult)
		--love.graphics.setColor(v.r,v.g,v.b)
		love.graphics.setColor(200,200,200,100+50*rmult)
		love.graphics.draw(rndcanv)
		lighten:send("lightX",lx)
		lighten:send("lightY",ly)
		lighten:send("lightmult",7.5+0.5*rmult)
		--love.graphics.setColor(v.r,v.g,v.b)
		love.graphics.draw(rndcanv)
	end
	local portalBright = math.max(0,math.min(255,(1-ppd/20)*255))

	love.graphics.setColor(100,100,100)
	local lx = (trx+(p.x*10))
	local ly = (try+(p.y*8))
	lighten:send("lightX",lx)
	lighten:send("lightY",ly)
	lighten:send("lightmult",10)
	--love.graphics.setColor(v.r,v.g,v.b)
	love.graphics.draw(rndcanv)
	love.graphics.setColor(portalBright,portalBright,portalBright)
	lx = (trx+(portal.x*10))
	ly = (try+(portal.y*8))
	lighten:send("lightX",lx)
	lighten:send("lightY",ly)
	lighten:send("lightmult",3)
	--love.graphics.setColor(v.r,v.g,v.b)
	love.graphics.draw(rndcanv)


	love.graphics.push()
	love.graphics.translate(
		trx,
		try
		)
	love.graphics.setColor(255,255,255)
	--love.graphics.draw("portal_godray",portal.x*10,portal.y*8,0,1,1,15,90)
	love.graphics.setBlendMode("alpha")
	love.graphics.pop()


	love.graphics.setCanvas(scrcanv)
	love.graphics.setShader(pltshader)
	love.graphics.draw(litcanv)
	love.graphics.push()
	love.graphics.translate(
		trx,
		try
		)
	portalBright = math.max(0,math.min(255,(1-ppd/5)*255))*(0.75+(love.math.noise(love.timer.getTime()/3,love.timer.getTime()/5)/4))
	love.graphics.setColor(portalBright,portalBright,portalBright,portalBright)
	love.graphics.setBlendMode("additive")
	love.graphics.draw("portal_godray",portal.x*10,portal.y*8,0,1,1,15,80)
	love.graphics.setBlendMode("alpha")
	love.graphics.pop()
	love.graphics.setColor(255,255,255)

	love.graphics.setCanvas()
	love.graphics.setShader()
	love.graphics.push()
	love.graphics.scale(scale, scale)
	love.graphics.draw(scrcanv)
	love.graphics.pop()

	love.graphics.setCanvas()
	love.graphics.setShader()
	--love.graphics.draw(ts.image)
end


function state:errhand(msg)
end


function state:focus(f)
end


function state:keypressed(key, isRepeat)
	if key=='escape' then
		love.event.push('quit')
	end
	if key==" " then
		if not p.carrying then
			local ppdx = p.x-portal.x
			local ppdy = p.y-portal.y
			local ppd = math.sqrt(ppdx*ppdx+ppdy*ppdy)
			if ppd<2 then
				if mode == "visit" then
					mode = "new"
				else
					mode = "visit"
				end
				gstate.switch(game)
			else
				p:pickup()
			end
		else
			p:pickup()
		end
	end
end


function state:keyreleased(key, isRepeat)
end


function state:mousefocus(f)
end


function state:mousepressed(x, y, btn)
end


function state:mousereleased(x, y, btn)
end


function state:quit()
end


function state:resize(w, h)
end


function state:textinput( t )
end


function state:threaderror(thread, errorstr)
end


function state:visible(v)
end


function state:gamepadaxis(joystick, axis)
end


function state:gamepadpressed(joystick, btn)
end


function state:gamepadreleased(joystick, btn)
end


function state:joystickadded(joystick)
end


function state:joystickaxis(joystick, axis, value)
end


function state:joystickhat(joystick, hat, direction)
end


function state:joystickpressed(joystick, button)
end


function state:joystickreleased(joystick, button)
end


function state:joystickremoved(joystick)
end

return state