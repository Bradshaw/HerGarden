local player_mt = {}
player = {}
player.all = {}
player.cur = nil

function player.new(x, y)
	local self = setmetatable({}, {__index=player_mt})
	self.wait = 1
	self.r = math.random(125,225)
	self.g = math.random(125,225)
	self.b = math.random(125,225)
	self.x = x
	self.y = y
	self.dx = 0
	self.dy = 0
	self.acc = 50
	self.fric = 10
	player.cur = self
	addtolist(self)
	return self
end

function player.update( dt )
	if player.cur then
		player.cur:update(dt)
	end
end

function player_mt:update( dt )
	if love.keyboard.isDown("q", "a", "left") then
		self.dx = self.dx - self.acc * dt
	end
	if love.keyboard.isDown("d", "right") then
		self.dx = self.dx + self.acc * dt
	end
	if love.keyboard.isDown("z", "w", "up") then
		self.dy = self.dy - self.acc * dt
	end
	if love.keyboard.isDown("s", "down") then
		self.dy = self.dy + self.acc * dt
	end
	self.dx = (self.dx - self.dx * self.fric * dt)*(1-self.wait)
	self.dy = (self.dy - self.dy * self.fric * dt)*(1-self.wait)
	self.x = self.x + self.dx*dt
	self.y = self.y + self.dy*dt
	if self.carry then
		self.carry.x = self.x
		self.carry.y = self.y
	end
	self.wait = math.max(0,math.min(1,self.wait-dt))
end

function player_mt:draw()
	local down = math.pi/2 + self.dx/16
	local yoff = -self.dy/8
	local drx = math.floor(self.x*10)
	local dry = math.floor(self.y*8)
	love.graphics.setColor(255,255,255,100)
	love.graphics.draw("shadow",drx-0.5,dry-2,0,1.5,0.8,5,4)
	love.graphics.setColor(self.r*0.5,self.g*0.5,self.b*0.5)
	love.graphics.arc("fill", drx-1, dry-10+yoff, 10+yoff, down-0.3, down+0.3)
	for i=0,5 do
		local l = i /5
		love.graphics.setColor(self.r*(0.8+0.2*l),self.g*(0.8+0.2*l),self.b*(0.8+0.2*l))
		love.graphics.arc("fill", drx, dry-11+yoff, (10+yoff)*(1-l), down-0.3, down+(0.3*(1-l)))
	end

	love.graphics.setColor(self.r*0.5,self.g*0.5,self.b*0.5)
	love.graphics.circle("fill",drx-1, dry-9, 2)
	love.graphics.setColor(self.r,self.g,self.b)
	love.graphics.circle("fill",drx, dry-10, 2)
end

function player_mt:pickup()
	if self.carry then
		self.carry.carried = false
		self.carry = nil
	else
		local it = findClosest()
		if it then
			it.carried = true
			self.carry = it
		end
	end
end
function findClosest()
	local d = math.huge
	local item = nil
	for i,v in ipairs(drawlist) do
		if v.carryable then
			local dx = p.x-v.x
			local dy = p.y-v.y
			local dist = (dx*dx+dy*dy)
			if dist<4 then
				if (dx*dx+dy*dy)<d then
					item = v
					d = dist
				end
			end
		end
	end
	return item
end
