local state = {}

function state:init()
end

function colors()
	cols = {}
	table.insert(cols,pltshader)
	table.insert(cols,"colors")
	table.insert(cols,
		{0,0,0,1}
	)
	table.insert(cols,
		{1,1,1,1}
	)
	local greys = math.random(3,10)
	for i=1,greys do
		table.insert(cols,
			{i/greys+math.random()/greys,i/greys+math.random()/greys,i/greys+math.random()/greys,1}
		)
	end
	local others = 14-greys
	for i=1,others do
		table.insert(cols,
			{math.random(),math.random(),math.random(),1}
		)
	end
	useful.arrayToArgs(pltshader.send, cols)
end


function state:enter( pre )
	colors()
	levelJSON = http.request("http://localhost:3000/new/")
	if not levelJSON then
		love.event.push(quit)
	end
	level = JSON:decode(levelJSON)
	area = level.area
	for i,v in ipairs(level.items.rocks) do
		rock.new(v.x, v.y)
	end
	portal.set(level.items.portal.x, level.items.portal.y)
	addtolist(portal)
end


function state:leave( next )
end


function state:update(dt)
	rock.update()
end


function state:draw()
	scrcanv:clear()
	love.graphics.setCanvas(scrcanv)
	love.graphics.setShader()
	love.graphics.push()
	love.graphics.scale(scale,scale)
	--[[]]
	love.graphics.translate(
		math.floor(-portal.x*10+5+sw/2),
		math.floor(-portal.y*8+4+sh/2)
		)
	--]]
	for j = 1,#area[1] do
		for i=1, #area do
			u = area[i][j]
			if u=="g" then
				love.graphics.draw("grass_01",i*10,j*8,0,1,1,10,8)
			end
		end
	end
	drawthelist()
	love.graphics.pop()
	love.graphics.setColor(255,255,255)
	love.graphics.setCanvas()
	love.graphics.setShader(pltshader)
	love.graphics.draw(scrcanv)

	love.graphics.setCanvas()
	love.graphics.setShader()
end


function state:errhand(msg)
end


function state:focus(f)
end


function state:keypressed(key, isRepeat)
	if key=='escape' then
		love.event.push('quit')
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