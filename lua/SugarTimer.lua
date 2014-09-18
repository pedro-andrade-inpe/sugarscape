--- Creates the timer and defines how the model is executed.
--@param model.pollutionStartTime Time where pollution formation will execute for the first time.
--@param model.pollutionDiffusionStartTime Time where pollution diffusion will execute for the first time.
--@param model.distFile A file name to save information about the society in a csv file. This 
--string is only the prefix of the file. It will add "_" then the current simulation time and then ".csv".
--@param model.showSocialNetworks A boolean value indicating whether the social networks will be 
--shown along the simulation.
--@usage timer = SugarTimer(model)
function SugarTimer(model)
	return Timer{
		Event{action = function(event)
			model.cs:synchronize()
			model.society:movementRule()
			model.society:metabolismRule()
			model.society:replacementRule()
			model.society:socialNetworkRule()
			model.cs:growbackRule(event:getTime())
			delay_s(model.viewWait) -- TODO: Waiting #937 to change its name and #875 to put as argument of Timer
		end},
		Event{time = model.pollutionStartTime, action = function()
			model.cs:pollutionFormationRule()
		end},
		Event{time = model.diffusionStartTime, action = function()
			model.cs:pollutionDiffusionRule()
		end},
		Event{period = 50, priority = 2, action = function(event)
			if model.showWealthDist then
				filename = model.distFile.."_"..event:getTime()..".csv"
				model.society:saveDistributionCSV(filename)
			end 
		end},
		Event{action = function(event)
			if model.showSocialNetworks then
				colorSocialNetworks(model)
			end
			model.society:notify(event)
			model.cs:notify(event)
		end}
	}
end

