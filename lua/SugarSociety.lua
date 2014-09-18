--- Create a society of agents that will eat sugar and move.
--@param model.agent A SugarAgent describing the agents that will belong to the society.
--@param model.numAgents The number of agents in the beginning of the simulation.
--@param model.movementRule A string with the strategy to simulate the movement of SugarAgents.
--@param model.metabolismRule A string with the strategy to simulate the metabolism of SugarAgents.
--@param model.replacementRule A string with the strategy to simulate how SugarAgents are replaced.
--@param model.socialNetworkRule A string with the strategy to create social networks along the simulation.
--@usage society = SugarSociety(model)
function SugarSociety (model)
	society = Society {
		instance = model.agent, 
		quantity = model.numAgents,
		--- Compute the Gini Index of the society according to the overall distribution of wealth.
		--@usage society:giniIndex()
		giniIndex = function(self)
			local g = Group{
				target = self,
				greater = greaterByAttribute("wealth")
			}

	    	local top = 0
	    	local bot = 0
	    	local num = #self
			forEachAgent(g, function(agent, i)
        		top = top + (num + 1 - i) * agent.wealth
        		bot = bot + agent.wealth
    		end)
    		return (num + 1 - 2 * (top / bot)) / num
		end,
		--- Save the distribution of agents in a csv file.
		--@param filename Name of the file to be saved.
		--@usage society:saveDistributionCSV("result.csv")
		saveDistributionCSV = function(self, filename)
			local g = Group{
				target = self,
				greater = greaterByAttribute("wealth")
			}

    		fh = io.open (filename, "w")

    		fh:write("x, y","\n")
			forEachAgent(g, function(agent, i)
    		    fh:write(i, ", ", agent.wealth,"\n")
			end)
    		fh:close()
		end
	}

	--- Describe how SugarAgents move. It can be SugarAgent:gradientSearch() or i
	--any other function implemented by the modeller in SugarAgents.
	--@class function
	--@name movementRule
	--@usage society:movementRule()
	society.movementRule = society[model.movementRule]
	--- Describe the how agents eat sugar. It can be SugarAgent:eatAllSugar(), 
	--SugarAgent:eatWhatNeed(), or any other function implemented by the modeller in SugarAgents.
	--@class function
	--@name metabolismRule
	--@usage society:metabolismRule()
	society.metabolismRule = society[model.metabolismRule]
	--- Describe how SugarAgents are replaced. It can be SugarAgent:noReplacement(), 
	--SugarAgent:ageReplacement(), or any other function implemented by the modeller in SugarAgents.
	--@class function
	--@name replacementRule
	--@usage society:replacementRule()
	society.replacementRule = society[model.replacementRule]
	--- Describe how SugarAgents are connected. It can be SugarAgent:noSocialNetworks(), 
	--SugarAgent:buildSocialNetworks(), or any other function implemented by the modeller in SugarAgents.
	--@class function
	--@name socialNetworkRule
	--@usage society:socialNetworkRule()
	society.socialNetworkRule = society[model.socialNetworkRule]
	return society
end

