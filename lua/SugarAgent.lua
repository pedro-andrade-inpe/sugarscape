local random = Random()

--- The basic behavioral entity of Sugarscape. It has attributes: age, wealth (the amount of sugar), 
-- life-expectancy (the maximum age that can be reached), metabolism (how much sugar an agent eats 
-- each time period), and vision (how many cells ahead an agent can see). 
-- The agent's life-expectancy, metabolism and vision do not change, while age and wealth do change.
-- All the functions of SugarAgent describe its behavior and do not have arguments.
-- @param model.agentWealth A table with two elements, min and max, indicating the minimum and 
-- maximum wealth of each agent in the beginning of the simulation.
-- @param model.agentMetabolism A table with two elements, min and max, indicating the minimum and 
-- maximum metabolism of each agent when they are created.
-- @param model.agentLifeTime A table with two elements, min and max, indicating the minimum and 
-- maximum lifetime of each agent when they are created.
-- @param model.agentVision A table with two elements, min and max, indicating the minimum and 
-- maximum vision of each agent when they are created.
-- @usage SugarAgent(model)
function SugarAgent(model)
	return Agent
	{
		init = function(self)
			self.wealth     = random:integer(model.agentWealth.min,     model.agentWealth.max    )
			self.metabolism = random:integer(model.agentMetabolism.min, model.agentMetabolism.max)
			self.maxage     = random:integer(model.agentLifetime.min,   model.agentLifetime.max  )
			self.vision     = random:integer(model.agentVision.min,     model.agentVision.max    )
			self.age        = 0 
		end,
		--- Default movement rule, following a gradient search.
		-- Look out as far as vision pennits in the four principal lattice directions and 
		-- identify the unoccupied site(s) maximizing the search criteria
		-- If the maximum searched value appears on multiple sites then select the nearest one.
		-- Move to this site and collect all the sugar at this new position.
		-- The maximization criteria is given by the searchMaxRule (model, cell). 
		-- In most cases this function searches for the maximum amount of sugar in the cell.
		-- In some examples, this is changed to a different criteria. In simulation II-8 the
		-- search criteria is changed to the maximum sugar/pollution ratio for the cell. 
		-- @usage agent:gradienSearch()
		gradientSearch = function(self)
			local cell     = self:getCell()           -- cell where the agent is now
			local max      = cell:searchMaxRule(cell) -- function to maximize for the search
			local bestcell = cell                     -- cell where the agent is moving to

			-- agent has a neighborhood depending on its vision (varies between 1 and 6) 
			-- select a pre-computed neighborhood based on the agent's vision
			local name = tostring(self.vision) 

			-- find the vacant cell with the most sugar nearest to the agent
			forEachNeighbor(cell, name, function (cell, neigh)
				if not neigh:isEmpty() then return end

				if neigh:searchMaxRule() > max then  
					max = neigh:searchMaxRule()
					bestcell = neigh
				elseif neigh:searchMaxRule(neigh) == max then
					-- two cells with same sugar, select the closest one 
					-- if the distance is the same, throw a coin
					local dcell  = cell:cityBlockDistance(bestcell)
					local dneigh = cell:cityBlockDistance(neigh) 
					if dneigh < dcell or (dneigh == dcell and random:integer(0, 1) == 1) then
						bestcell = neigh
					end
				end
			end)
			self:move(bestcell)
		end,
		--- A replacement rule, indicating that no agent will replace an agent that dies.
		-- In this case, agents die only by losing their wealth.
		-- @usage agent:noReplacement()
		noReplacement = function(self)
			if self.wealth <= 0 then self:die() end
		end,
		--- A Replacement rule, indicating that a new agent will replace the agent that dies.
		-- In this case, an agent dies when it has no wealth or when it reaches a maximum age.
		-- @usage agent:ageReplacement()
		ageReplacement = function(self)
			self.age = self.age + 1 
			if self.wealth <= 0 or self.age == self.maxage then
				son = self:reproduce()
				son:move(self:getCell().parent:findEmptyRandomCell())
				self:die()
			end
		end,
		--- Eat as much sugar as it is available in the current cell.
		-- @usage agent:eatAllSugar()
		eatAllSugar = function(self)
			local mycell = self:getCell()

			self.wealth = self.wealth - self.metabolism + mycell.sugar

			-- set up the production and consumption values for the cell
			mycell.production  = mycell.sugar 
			mycell.consumption = self.metabolism
			mycell.sugar = 0
		end,
		--- Eat sugar according to its metabolism.
		-- @usage agent:eatWhatNeed()
		eatWhatNeed = function(self)
			local mycell = self:getCell()
			local takes = mycell.sugar

			if self.metabolism <= takes then
				takes = self.metabolism
			end

			mycell.sugar = mycell.sugar - takes
			self.wealth = self.wealth - self.metabolism + takes

			-- set up the production and consumption values for the cell
			mycell.production  = mycell.sugar 
			mycell.consumption = self.metabolism
		end,
		--- Enter in an empty cell of the cellular space it belongs.
		-- @usage agent:enterEmptyCell()
		enterEmptyCell = function(self)
			self:enter(self.placement.parent:findEmptyRandomCell())
		end,
		--- Function used when the model does not have social networks. It does not do anything.
		-- @usage agent:noSocialNetworks()
		noSocialNetworks = function()
			return true
		end,
		--- Build a social network. The neighbor connection network is a directed graph with agents 
		-- as the nodes and edges drawn to the agents who have been their neighbors.
		-- It is constructed as follows: Imagine that agents are positioned on the sugarscape and 
		-- that none has moved. The first agent now executes M, moves to a new site, and then
		-- builds a list of its von Neumann neighbors, which it maintains until its next move. 
		-- The second agent then moves and builds its list of (post-move) neighbors. 
		-- The third agent moves and builds its list, and so on until all agents have moved. 
		-- At this point, lines are drawn from each agent to all agents on its list. 
		-- The resulting graph - a social network of neighbors - is redrawn after every cycle 
		-- through the agent population.
		-- @usage agent:buildSocialNetworks()
		buildSocialNetworks = function(self)
			self:addSocialNetwork(SocialNetwork())
		
			-- agent has a variable neighborhood depending on his vision (varies between 1 and 6) 
			-- select a pre-computed neighborhood based on the agent's vision
			local name = tostring(self.vision) 

			-- find all the agents connected to the agent
			forEachNeighbor(self:getCell(), name, function (cell, neigh)
				if not neigh:isEmpty() then
					self:getSocialNetwork():add(neigh:getAgent())
				end
			end)
		end
	}
end

