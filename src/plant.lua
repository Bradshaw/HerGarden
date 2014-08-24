local plant_mt = {}
plant = {}
plant.all = {}

function plant.new()
	local self = setmetatable({}, {__index=plant_mt})

	table.insert(plant.all, self)
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

end

function plant_mt:draw()

end
