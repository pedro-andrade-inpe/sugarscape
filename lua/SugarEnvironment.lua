--- Place the society of agents in the cell space.
-- @param model.placementRule A string with the placement rule to be used.
-- @param model.block A table with four values, xmin, ymin, xmax, and ymax indicating
-- the box over which agents will be placed.
-- @param model.society A SugarSociety.
-- @param model.cs A SugarCellularSpace.
-- @usage environment = SugarEnvironment(model)
function SugarEnvironment(model) 
	local trajectory = Trajectory{
		target = model.cs,
		select = function(cell)
			return cell.x >= model.block.xmin and cell.x <= model.block.xmax and
			       cell.y >= model.block.ymin and cell.y <= model.block.ymax
		end
	}

	local env = Environment{trajectory, model.society}

	env:createPlacement{
		strategy = model.placementRule,
		max = 1
	}
	return env
end

