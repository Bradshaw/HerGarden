local rock_mt = {}
rock = {}
rock.all = {}

function rock.new(x, y)
	local self = setmetatable({}, {__index=rock_mt})
	self.x = x
	self.y = y
	table.insert(rock.all, self)
	addtolist(self)
	return self
end

function rock.update( dt )
	local i = 1
	while i<=#rock.all do
		local v = rock.all[i]
		if v.purge then
			table.remove(rock.all, i)
		else
			v:update(dt)
			i = i+1
		end

	end
end

function rock.draw(  )
	for i,v in ipairs(rock.all) do
		v:draw()
	end
end

function rock_mt:update( dt )

end

function rock_mt:draw()
	love.graphics.draw("wall",self.x*10,self.y*8,0,1,1,10,12)
end
