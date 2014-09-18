---	Create the cell space from the file containing the sugarscape and define the 
--  neighborhoods. Note that this cellular space also contains the functions of its 
--  SugarCells that call the respective function for each of them.
--@param model.seasonDuration The duration of each season (summer and winter).
--@param model.winterGrowthRate The growth rate of sugar during the winter season.
--@param model.summerGrowthRate The growth rate of sugar during the summer season.
--@param model.pollutionFormationRule A string with the strategy used to simulate pollution formation.
--@param model.pollutionDiffusionRule A string with the strategy used to simulate pollution diffusion.
--@param model.growbackRule A string with the strategy to simulate how SugarCells produce sugar.
--@param model.cell A cell that is going to be used to create each cell of the SugarCellularSpace.
--@param model.agentVision A named table that contains two values, min and max, indicating the 
--minimum and maximum number of cells that an agent can see in each direction.
--@param model.seasonDuration A number indicating how long a season lasts.
--@usage cs = SugarCellularSpace(model)
function SugarCellularSpace (model)
	local mfile = data(model.sugarscapeFile, "sugarscape")

	local cs = CellularSpace {
		database = mfile, -- TODO: waiting for bug #975
		instance = model.cell,
		sep      = ";",
		--- Get a random cell in the cell space that is not occupied by any SugarAgent.
		--@usage cs:findEmptyRandomCell()
		findEmptyRandomCell = function(self)
			local found = false
			local cell

			while not found do
				cell = self:sample()
				if cell:isEmpty() then
					found = true
				end
			end
			return cell
		end,
		--- Seasonal growth rule. Seasons have different growth rates, according to the parameters 
		--  summerGrowthRate and winterGrowthRate.
		--@param time The current simulation time.
		--@usage cs:seasonalGrowth(time)
		seasonalGrowth = function(self, time)
			if (math.floor(time / model.seasonDuration) % 2) == 0 then
				-- summer in the North, winter in the South
				self.north:growSugar(model.summerGrowthRate) 
				self.south:growSugar(model.winterGrowthRate)
			else
				-- winter in the North, summer in the South
				self.north:growSugar(model.winterGrowthRate) 
				self.south:growSugar(model.summerGrowthRate)
			end
		end
	}

	assert(2 * model.agentVision.max < (#cs) ^ 0.5, "Neighboorhood size is greater then cellspace dimension.")

	for i = model.agentVision.min, model.agentVision.max do
		cs:createNeighborhood{
			strategy = "mxn",
			name = tostring(i), -- choose a name associated with the length 
			m = i,
			n = i,
			filter = function(cell, neigh)
				return (cell.x == neigh.x or cell.y == neigh.y) and cell ~= neigh
			end
		}
	end

	if model.seasonDuration ~= math.huge then
		local split = cs:split(function(cell) 
			if cell.y < cs.maxRow/2 then
				return "north"
			else
				return "south" 
			end
		end)
		cs.north = split.north
		cs.south = split.south
	end
	
	--- Describe how sugar grows along the simulation. It can be SugarCell:normalGrowth(), 
	--  SugarCell:immediateGrowth(), SugarCell:delayedGrowth(), 
	--  SugarCellularSpace:seasonalGrowth(), or another function implemented by the modeller.
	--@class function
	--@name growbackRule
	--@usage cs:growbackRule()
	cs.growbackRule = cs[model.growbackRule]
	--- Describe how pollution is created. It can be SugarCell:noPollution(), 
	--  SugarCell:maxSugarToPollution(), or another function implemented by the modeller.
	--@class function
	--@name pollutionFormationRule
	--@usage cs:pollutionFormationRule()
	cs.pollutionFormationRule = cs[model.pollutionFormationRule]
	--- Return the amount of sugar that can be eaten. It can be SugarCell:noPollution(), 
	--  SugarCell:pollutionLocalDiffusion(), or another function implemented by the modeller.
	--@class function
	--@name pollutionDiffusionRule
	--@usage cs:pollutionDiffusionRule()
	cs.pollutionDiffusionRule = cs[model.pollutionDiffusionRule]
	return cs
end

