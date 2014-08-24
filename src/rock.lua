local rock_mt = {}
rock = {}
rock.all = {}

function rock.new(x, y, variant, id)
	local self = setmetatable({}, {__index=rock_mt})
	self.x = x
	self.y = y
	self.id = id
	self.variant = variant
	table.insert(rock.all, self)
	self.carryable = true
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
	if self.carried then
		self.doDrop = true
	elseif self.doDrop then
		self.doDrop = false
		--print("OMG")
		--http.request("http://192.168.1.29:3000/move/4/4", "lol")
		if not messageThread:isRunning() then
			love.thread.getChannel("http"):push("move/"..ldID.."/"..self.id.."/"..math.floor(self.x*10000).."/"..math.floor(self.y*10000))
			messageThread:start()
		end
	end
end

function rock_mt:draw()
	if self.carried then
		love.graphics.setColor(255,255,255)
		love.graphics.draw("stone"..self.variant,math.floor(self.x*10),math.floor(self.y*8)-12,0,1,1,5,12)	
	else
		love.graphics.setColor(255,255,255,100)
		love.graphics.draw("shadow",self.x*10-0.5,self.y*8-2,0,1.5,0.8,5,4)
		love.graphics.setColor(255,255,255)
		love.graphics.draw("stone"..self.variant,self.x*10,self.y*8,0,1,1,5,12)
	end
end
