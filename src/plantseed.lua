local plantseed_mt = {}
plantseed = {}
plantseed.all = {}

function plantseed.new(plant)
	local self = setmetatable({}, {__index=plantseed_mt})
	self.plant = {}
	for k,v in pairs(plant) do
		self.plant[k] = v
	end
	self.carryable = true
	local a = math.pi*math.random()*2
	local dist = math.random()
	self.x = plant.x+math.cos(a)*dist
	self.y = plant.y+math.sin(a)*dist
	self.z = -math.random(5,10)
	self.dz = 0
	table.insert(plantseed.all, self)
	addtolist(self)
	return self
end

function plantseed.update( dt )
	local i = 1
	while i<=#plantseed.all do
		local v = plantseed.all[i]
		if v.purge then
			table.remove(plantseed.all, i)
		else
			v:update(dt)
			i = i+1
		end

	end
end

function plantseed.draw(  )
	for i,v in ipairs(plantseed.all) do
		v:draw()
	end
end

function plantseed_mt:update( dt )
	if self.carried then
		self.doDrop = true
	elseif self.doDrop then
		self.purge = true
		self.doDrop = false
		--print("OMG")
		--http.request("http://192.168.1.29:3000/move/4/4", "lol")
		for i=1,math.random(2,5) do
			local pl = plant.new(self.plant);
			local a = math.random()*math.pi*2
			local dist = math.random()*3
			pl.x = p.x+dist*math.cos(a)
			pl.y = p.y+dist*math.sin(a)
			pl.energy = 0
			pl.needsend = true
		end
	else
		self.dz = self.dz + dt * 100
		self.z = self.z + self.dz * dt
		if self.z>=0 then
			self.z = 0
			self.dz = -math.abs(self.dz) * 0.8
		end
		if self.z<0.1 and math.abs(self.dz)<1 then
			if math.random()>0.99 then
				self.dz = -math.random(30,50)
			end
		end
	end
end

function plantseed_mt:draw()
	if self.carried then
		love.graphics.setColor(255,255,255)
		love.graphics.draw("seed",math.floor(self.x*10), math.floor(self.y*8)-12,0,1,1,2.5,5)
	else
		love.graphics.setColor(255,255,255,100)
		love.graphics.draw("shadow",self.x*10-0.5,self.y*8-2,0,1.5,0.8,5,4)
		love.graphics.setColor(255,255,255)
		love.graphics.draw("seed",self.x*10, self.y*8+self.z,0,1,1,2.5,5)
	end
end
