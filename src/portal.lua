portal = {x = 0, y=0}

function portal.set(x, y)
	portal.x = x
	portal.y = y
	portal.time = 0
end

function portal.draw()
	local ppdx = p.x-portal.x
	local ppdy = p.y-portal.y
	local ppd = math.sqrt(ppdx*ppdx+ppdy*ppdy)
	love.graphics.setColor(255,255,255)
	love.graphics.draw("shadow",portal.x*10-0.5,portal.y*8-2,0,3,1.6,5,4)
	love.graphics.setColor(255,255,255)
	love.graphics.draw("portal",portal.x*10,portal.y*8,0,1,1,15,28)
	--love.graphics.setBlendMode("additive")
	love.graphics.draw("portal_effect",portal.x*10,portal.y*8,0,1,1,15,28)
	love.graphics.setBlendMode("alpha")
end

function portal.update(dt)
	local ppdx = p.x-portal.x
	local ppdy = p.y-portal.y
	local ppd = math.sqrt(ppdx*ppdx+ppdy*ppdy)
	if ppd<0.5 then
		if mode == "visit" then
			mode = "new"
		else
			mode = "visit"
		end
		gstate.switch(game)
	end
end