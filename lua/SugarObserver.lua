--- Create model visualizations.
--@param model.showGiniIndex A boolean value indicating whether the SugarSociety:giniIndex()
--will be shown along the simulation.
--@param model.showNumAgents A boolean value indicating whether the number of SugarAgents 
--will be shown along the simulation.
--@param model.society A SugarSociety.
--@param model.agentColor An integer number with the value representing agents in space.
--@param model.cs A SugarCellularSpace.
--@param model.showSocialNetworks A boolean value indicating whether the social networks 
--will be shown along the simulation.
--@usage SugarObserver(model)
function SugarObserver(model)
	if model.showGiniIndex then
		Observer{
			subject     = model.society,
			attributes  = {"giniIndex"},
			title       = "Gini Index - Sugarscape",
			xLabel      = "time",
			yLabel      = "Gini index",
			type        = "chart"
		}
	end

	if model.showNumAgents then
		Observer{
			subject     = model.society,
			title       = "Agents in the model",
			xLabel      = "time",
			yLabel      = "agents",
			type        = "chart"
		} 
	end

	local leg = Legend{
		grouping = "uniquevalue",
		colorBar = {
			{value = 0, color = {255,255,212}},
			{value = 1, color = {218,176,130}},
			{value = 2, color = {218,160, 98}},
			{value = 3, color = {180,117, 49}},
			{value = 4, color = {117, 69, 16}},
			{value = model.agentColor, color = {117, 33, 16}, label = "agent"}
		}
	}

	Observer{
		subject = model.cs,
		attributes = {"color"},
		legends = {leg}
	}

	if model.showSocialNetworks then
		leg = Legend{
			grouping = "uniquevalue",
			colorBar = {
				{value = 0,                        color = {255,255,212}, label = "empty"},
				{value = model.socialNetworkColor, color = {218,176,130}, label = "network"},
				{value = model.agentColor,         color = {117, 33, 16}, label = "agent"}
			}
		}

		Observer{
			subject = model.cs,
			attributes = {"socialNetwork"},
			legends = {leg}
		}
	end
end

