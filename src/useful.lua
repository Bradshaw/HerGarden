useful = {}
local ID = 0

function useful.getNumID()
	ID = ID+1
	return ID
end

function useful.getStrID()
	return string.format("%06d",useful.getNumID())
end

function useful.arrayToArgs(func, array, ...)
	if #array==0 then
		func(...)
	else
		local e = array[#array]
		table.remove(array, #array)
		useful.arrayToArgs(func, array, e, ...)
	end
end