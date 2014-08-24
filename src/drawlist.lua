drawlist = {}
function drawthelist()
	local i = 1
	while i<=#drawlist do
		local v = drawlist[i]
		if v.purge then
			table.remove(drawlist,i)
			print("prg")
		else
			dodraw(v)
			if i>1 then
				if v.y<drawlist[i-1].y then
					drawlist[i], drawlist[i-1] = drawlist[i-1], drawlist[i]
				end
			end
			i = i+1
		end
	end
end

function addtolist(item)
	table.insert(drawlist, item)
end

function dodraw(item)
	if item.draw then
		item:draw()
	end
end