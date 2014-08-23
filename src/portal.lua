portal = {x = 0, y=0}

function portal.set(x, y)
	portal.x = x
	portal.y = y
end

function portal.draw()
	love.graphics.draw("portal",portal.x*10,portal.y*8,0,1,1,20,28)
end