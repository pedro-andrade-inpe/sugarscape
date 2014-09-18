--[[Util functions]]

--- Find out if an element is one of the values of a table.
--@param element A value of any type.
--@param table A table.
--@usage isOneOf(2, {1, 2, 3, 4, 5})
function isOneOf(element, table)
  	for k, v in ipairs(table) do
    	if v == element then
	      	return true
    	end
  	end
  	return false
end

--- Find path between cells of the same cellular space.
--@param cell1 A Cell.
--@param cell2 A Cell.
--@usage findStraigthPath(cell1, cell2)
function findStraigthPath(cell1, cell2)
	local cs = cell1.parent
	local path = Trajectory{target = cs, build = false}
	if cell1.x == cell2.x then -- same collumn
		local distY = cell2.y - cell1.y
		if distY > 0 then step = 1 else step = -1 end
		for i = step, distY, step do
			local c = {x = cell1.x, y = cell1.y + i}
			path:add(cs:getCell(cell1.x, cell1.y + i))
		end
	else -- same line
		local distX = cell2.x - cell1.x
		if distX > 0 then step = 1 else step = -1 end
		for i = step, distX, step do
			local c = {x = cell1.x + i, y = cell1.y}
			path:add(cs:getCell(cell1.x + i, cell1.y)) --TODO It does not work yet (Bug ticket #974).
		end
	end
	print(#path)
	return path
end

--- Color a cellular space according to a social network. It requires writes
-- the values in the attribute socialNetwork of each cell.
--@param model A Sugarscape model.
--@usage colorSocialNetworks(model)
function colorSocialNetworks(model) -- TODO: Waiting for ticket #949 to remove this function
	forEachCell(model.cs, function(cell) cell.socialNetwork = 0 end)

	forEachAgent(model.society, function(agent)
		forEachConnection(agent, function(agent, connection)
			local cell1 = agent:getCell()
			local cell2 = connection:getCell()
			local path = findStraigthPath(cell1, cell2) 
			forEachCell(path, function(cell)
				cell.socialNetwork = model.socialNetworkColor
			end)
		end)
	end)

	forEachCell(model.cs, function(cell) 
		if not cell:isEmpty() then cell.socialNetwork = model.agentColor end
	end)
end

