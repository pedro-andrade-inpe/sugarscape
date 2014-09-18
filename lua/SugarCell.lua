--- A Cell representing the smallest spatial partition of sugarscape.
-- @param model.growthRate A positive number indicating the growth rate of sugar.
-- @param model.agentColor A positive number indicating the color of the agents. 
-- @param model.showOriginalSugarscape A boolean value indicating whether the model will 
-- show the maximum sugar (true) or the current sugar (false) in the cells.
-- @param model.searchMaxRule A string with the rule to be used. The string name indicates one 
-- function available in the SugarCell to be called. The maximization criteria is then mapped 
-- to function SugarCell:searchMaxRule().
-- @param model.pollutionProductionRate The rate that pollution grows over time.
-- @param model.pollutionConsumptionRate The rate that pollution is consumed over time.
-- In most cases this function searches for the maximum amount of sugar in the cell.
-- In some examples, this is changed to a different criteria. In simulation II-8 the
-- search criteria is changed to the maximum sugar/pollution ratio for the cell. 
-- @usage cell = SugarCell(model)
function SugarCell(model)
	local cell = Cell{
		init = function(self)
			self.sugar = self.maxsugar
			self.socialNetwork = 0
		end,
		harvestTime   = 0,
		production    = 0,
		consumption   = 0,
		pollution     = 0,
		--- Grow back to maximum sugar value immediately.
		-- @usage cell:immediateGrowth()
		immediateGrowth = function(self)
			self.sugar = self.maxsugar
		end,
		--- Grow back according to a given rate.
		-- @param rate A positive number to increase the amount of sugar.
		-- @usage cell:growSugar(1.0)
		growSugar = function(self, rate)
			self.sugar = self.sugar + rate
			if self.sugar > self.maxsugar then
				self.sugar = self.maxsugar
			end
		end,
		--- Normal growth rule for the sugarscape model.
		-- @usage cell:normalGrowth()
		normalGrowth = function(self)
			self.sugar = self.sugar + model.growthRate
			if self.sugar > self.maxsugar then 
				self.sugar = self.maxsugar
			end
		end,
		--- Delayed growth rule: wait one time step before growing again.
		-- @usage cell:delayedGrowth()
		delayedGrowth = function(self)
			if self.sugar == self.past.sugar then
				self.sugar = self.sugar + model.growthRate
				if self.sugar > self.maxsugar then 
					self.sugar = self.maxsugar
				end
			end
		end,
		--- Return the amount of sugar in the SugarCell.
		-- @usage cell:maxSugar()
		maxSugar = function(self)
			return self.sugar
		end,
		--- Return the amount of sugar that can be eaten according to the current pollution.
		-- In the pollution examples, the agent movement rule is changed to
		-- look out as far as vision permits in the four principal lattice
		-- directions and identify the unoccupied site(s) having the maximum sugar to pollution ratio.
		-- @usage cell:maxSugarToPollution()
		maxSugarToPollution = function(self)
			return self.sugar/(1 + self.pollution)
		end,
		--- Return the Manhattan distance to another cell.
		-- @param cell Another cell.
		-- @usage cell:cityBlockDistance(anothercell)
		cityBlockDistance = function(self, cell)
			return math.abs(self.x - cell.x) + math.abs(self.y - cell.y)
		end,
		--- Compute color of the cell according to its attrihutes.
		-- The color will be different if it contains a SugarAgent.
		-- @usage cell:color()
		color = function(self)
			if self:isEmpty() then  
				if model.showOriginalSugarscape then 
					return self.maxsugar
				else
					return self.sugar
				end
			else
				return model.agentColor --TODO: Waiting for tickets #938 and #940 to remove this. 
			end
		end,
		--- Function to be executed when there is no pollution in the model. It does not do anything.
		-- @usage cell:noPollution()
		noPollution = function()
			return true
		end,
		--- Implement the production/Consumption rule.
		-- Pollution formation rule: when sugar S is gathered from the sugarscape, an amount of 
		-- production pollution is generated in quantity ALPHA*S. When sugar amount M is metabolized, 
		-- consumption pollution is generated according to BETA*M. 
		-- The total pollution on a site at time t, P(T), is the sum of the
		-- pollution present at the previous time, plus the pollution
		-- resulting from production and consumption activities.
		-- @usage cell:pollutionProdCons()
		pollutionProdCons = function(self)
			self.pollution = self.pollution + model.pollutionProductionRate * self.production +
				             model.pollutionConsumptionRate * self.consumption
		end,
		--- Implement the pollution diffusion rule. Diffusion on a sugarscape is simply
		-- implemented as a local averaging procedure. 
		-- That is, diffusion transports pollution from sites of high levels to sites of low levels.
		-- The new agent movement rule modified for pollution is
		-- Look out as far as vision permits in the four principal lattice
		-- directions and identify the unoccupied site(s) having the maximum sugar to pollution ratio.
		-- @usage cell:pollugionLocalDiffusion()
		pollutionLocalDiffusion = function(self)
			local size = cell:getNeighborhood():size()
			local p = self.past.pollution
			forEachNeighbor(self, function (cell, neigh)
				p = p + neigh.past.pollution
			end)
			self.pollution = p/(size + 1)
		end
	}

	--- Return the amount of sugar that can be eaten. It can be SugarCell:maxSugar(), 
	-- SugarCell:maxSugarToPollution(), or another function implemented by the modeller.
	-- @class function
	-- @name searchMaxRule
	-- @usage cell:searchMaxRule()
	cell.searchMaxRule = cell[model.searchMaxRule]
	return cell
end

