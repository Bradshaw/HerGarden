local plant_mt = {}
plant = {}
plant.all = {}

function plant.new(values)
	local self = setmetatable({}, {__index=plant_mt})
	for k,v in pairs(values) do
		self[k]=v
	end
	self.isAPlant = true
	self.energy = self.fully
	self.dropSeed = math.random(0,10*#plant.all)
	table.insert(plant.all, self)
	addtolist(self)
	return self
end

function plant.update( dt )
	local i = 1
	while i<=#plant.all do
		local v = plant.all[i]
		if v.purge then
			table.remove(plant.all, i)
		else
			v:update(dt)
			i = i+1
		end

	end
end

function plant.draw(  )
	for i,v in ipairs(plant.all) do
		v:draw()
	end
end

function plant_mt:update( dt )
	if self.needsend then
		local pl = self;
		if not messageThread:isRunning() then
			love.thread.getChannel("http"):push( {url = "plant/"..ldID, post=JSON:encode({
					x = pl.x,
					y = pl.y,
					size = pl.size*(0.8+math.random()*0.4),
					fully = pl.fully*(0.8+math.random()*0.4),
					length = pl.length*(0.8+math.random()*0.4),
					ra = pl.ra*(0.8+math.random()*0.4),
					ma = pl.ma*(0.8+math.random()*0.4),
					min = pl.min,
					max = pl.max,
					ls = pl.ls*(0.8+math.random()*0.4),
					brgb = pl.brgb,
					lrgb = pl.lrgb

			}) })

			messageThread:start()
			self.needsend = false
		end
	end
	drop = self.energy>=self.fully
	if drop then
		self.dropSeed = self.dropSeed-dt
		if self.dropSeed<0 and #plantseed.all<math.min(10,#plant.all/2) then
			self.dropSeed = math.random(0,10*#plant.all)
			if math.random()>0.8 then
				plantseed.new(self)
			end
		end
	end
	self.energy = math.min(self.fully,self.energy+dt*0.1)
end

function plant_mt:draw()
	love.graphics.setColor(255,255,255,100)
	love.graphics.draw("shadow",self.x*10-0.5,self.y*8-2,0,1.5,0.8,5,4)
	love.graphics.setColor(255,255,255)
	self:branch(0,0,self.ra,self.ma,self.length,self.min,self.max,self.energy,0,0)
end

function plant_mt:branch(x,y,ra,ma,l,m,M,e,d,ca)
	local a = (ca*2)+
			ra*(love.math.noise(self.x+l+d,self.y+love.timer.getTime()/5)*2-1)+
			ma*(love.math.noise((self.x*30),(self.y*30)+l+d)*2-1)
	local dx = l*math.cos(-math.pi/2+a)*self.size
	local dy = l*math.sin(-math.pi/2+a)*self.size
	local g = math.max(0.1,math.min(1,e))*self.size
	love.graphics.setColor(self.brgb.r,self.brgb.g,self.brgb.b)
	love.graphics.draw("branch",self.x*10+x,self.y*8+y,a,l/10*g,l/10*g,2.5,10)
	love.graphics.setColor(self.lrgb.r,self.lrgb.g,self.lrgb.b)
	love.graphics.draw("leaf",self.x*10+x+dx,self.y*8+y+dy,math.pi*2*love.math.noise(l,d+love.timer.getTime()*0),l/5*self.ls*g,l/5*self.ls*g,0,2.5)
	if e>0 then
		for i=0,(M-m)*love.math.noise(self.x+d,self.y+l)+m do
			local nl = 0.5+love.math.noise(i,l+i)*0.5
			self:branch(x+dx,y+dy,ra,ma,l*nl,m,M,e-nl*2,d+1,a)
		end
	end
end
