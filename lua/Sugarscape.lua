--- Sugarscape Model, with its parameters and execution. It contains a SugarAgent, a SugarCell, 
-- a SugarCellularSpace, a SugarSociety, a SugarObserver, a SugarEnvironment, and a SugarTimer.
-- @class function
-- @param attrTab.sugarscapeFile Name of the file with the initial values of the sugarscape. 
-- The only possible value so far is "sugar-map.csv". 
-- @param attrTab.numAgents Quantity of agents in the beginning of the simulation.
-- @param attrTab.agentWealth A table with the initial random sugar available per agent. 
-- Default is {min = 5, max = 25}.
-- @param attrTab.agentMetabolism A table with the consumption per agent per time step. 
-- Default is {min = 1, max = 4}.
-- @param attrTab.agentVision A table with the vision of agents in horizontal and vertical 
-- directions. Default is {min = 1, max = 6}.
-- @param attrTab.agentLifetime A table (min, max) describing the lifetime of the agents 
-- (by default, agents have no lifetime limits).
-- @param attrTab.growthRate The growth rate of sugar per time step. The default value is 1. 
-- @param attrTab.pollutionProductionRate Rate of pollution production. The default value is 0.
-- @param attrTab.pollutionConsumptionRate Rate of pollution consumption. The default value is 0.
-- @param attrTab.pollutionStartTime A number indicating when the pollution will start taking 
-- place along the simulation. Default value is math.huge (no pollution).
-- @param attrTab.diffusionStartTime A number indicating when the pollution diffusion will start 
-- taking place along the simulation. Default value is math.huge (no pollution).
-- @param attrTab.seasonDuration The duration of each season. Default value is math.huge, 
-- meaning that there are no seasons.
-- @param attrTab.summerGrowthRate Growth rate during summer. The default value is 1.
-- @param attrTab.winterGrowthRate Growth rate during winter. The default value is 0.125.
-- @param attrTab.block A block where the agents will be placed. It is a table with four values: 
-- xmin (default 0), xmax (math.huge), ymin (0) and ymax (math.huge).
-- @param attrTab.placementRule How agents are placed in the cell space. There are two options: 
-- "random" (default) or "uniform".
-- @param attrTab.movementRule How agents move in the cell space. There is only one option: 
-- "gradientSearch". See SugarSociety:movementRule().
-- @param attrTab.searchMaxRule Search maximization criteria. There are two options: "maxSugar" 
-- (default) or "maxSugarToPollution". See SugarCell:searchMaxRule().
-- @param attrTab.metabolismRule How agents' metabolism works. There are two options: 
-- "eatAllSugar" (default) "eatWhatNeed". See SugarSociety:metabolismRule().
-- @param attrTab.replacementRule How agents are replaced if the die. There are two options: 
-- "noReplacement" (default) or "ageReplacement". See SugarSociety:replacementRule().
-- @param attrTab.pollutionFormationRule How the agents pollute the space. There are two options:
-- "noPollution" (default) or "pollutionProdCons". See SugarCellularSpace:pollutionFormationRule().
-- @param attrTab.pollutionDiffusionRule How the diffusion of the pollution takes place. There are two 
-- options: "noPollution" or "pollutionLocalDiffusion". See SugarCellularSpace:pollutionDiffusionRule().
-- @param attrTab.growbackRule How sugar grows back in the cell space. There are four options: 
-- "normalGrowth" (default), "immediateGrowth", "delayedGrowth", or "seasonalGrowth". See 
-- SugarCellularSpace:growbackRule(). See SugarCellularSpace:growbackRule().
-- @param attrTab.socialNetworkRule How social networks are handled. There are two options: 
-- "noSocialNetworks" (default) or "buildSocialNetworks". See SugarSociety:socialNetworkRule().
-- @param attrTab.showNumAgents Show the number of agents? Default is false.
-- @param attrTab.showGiniIndex Show Gini coefficient? Default is false.
-- @param attrTab.showSocialNetworks Show social networks? Default is false.
-- @param attrTab.showWealthDist Show wealth distribution?Default is false.
-- @param attrTab.agentColor How to show the agents in the sugarscape? Default is 5.
-- @param attrTab.socialNetworkColor How to show the social network in the sugarscape (Default is 1).
-- @param attrTab.showOriginalSugarscape Show the original sugar distribution in the map?  (Default is true).
-- @param attrTab.distFile Name of a file to save a histogram. Different histograms are saved along 
-- the simulation. The default value is "sugarscape_dist". 
-- @param attrTab.viewWait Time in seconds to wait before next iteration. It is useful when the 
-- simulation runs very fast. The devault value is zero.
-- @name Sugarscape
-- @usage model = Sugarscape()
-- model:run()
Sugarscape = Model{
	mapFile                    = "sugar-map.csv",
	distFile                   = "sugarscape_dist",
	numAgents                  = Choice{min = 10},
	agentWealth                = {min = 5, max = 25},
	agentMetabolism            = {min = 1, max = 4},
	agentVision                = {min = 1, max = 6},
	agentLifetime              = {min = 5, max = math.huge},
	growthRate                 = Choice{min = 1},
	finalTime                  = Choice{min = 100},
	pollution = {
		active                 = false,
		productionRate         = Choice{min = 0},
		consumptionRate        = Choice{min = 0},
		pollutionStartTime     = math.huge,
		diffusionStartTime     = math.huge,
		pollutionFormation     = Choice{"noPollution", "pollutionProdCons"},
		pollutionDiffusion     = Choice{"noPollution", "pollutionLocalDiffusion"}
	},
	season = {
		active                 = false,
		duration               = math.huge,
		summerGrowthRate       = 1,
		winterGrowthRate       = 0.125
	},
	block = {
		active                 = false,
		xmin                   = 0,
		xmax                   = math.huge,
		ymin                   = 0,
		ymax                   = math.huge
	},
	rules = {
		placement              = Choice{"random", "uniform"},
		movement               = Choice{"gradientSearch"},
		searchMax              = Choice{"maxSugar", "maxSugarToPollution"},
		metabolism             = Choice{"eatAllSugar", "eatWhatNeed"},
		replacement            = Choice{"noReplacement", "ageReplacement"},
		growback               = Choice{"normalGrowth", "immediateGrowth", "delayedGrowth", "seasonalGrowth"},
		socialNetwork          = Choice{"noSocialNetworks", "buildSocialNetworks"}
	},
	display = {
		numAgents              = false,
		giniIndex              = false,
		socialNetworks         = false,
		wealthDist             = false, 
		showOriginalSugarscape = true,
		agentColor             = Choice{min = 1, max = 5, step = 1},
		socialNetworkColor     = Choice{min = 1, max = 4, step = 1},
		viewWait               = Choice{min = 0}
	},
	init = function(model)
		model.cell        = SugarCell(model)
		model.cs          = SugarCellularSpace(model)
		model.agent       = SugarAgent(model)
		model.society     = SugarSociety(model)
		model.environment = SugarEnvironment(model)
		model.timer       = SugarTimer(model)
		SugarObserver(model)
	end,
	interface = function()
		return {
			{"string", "agentWealth", "agentVision", "block"},
			{"Choice", "rules", "season"},
			{"display", "pollution"}
		}
	end,
	check = function(model)
		verify(model.block.xmax > model.block.xmin, "xMax should be greater than xMin.")
		verify(model.block.ymax > model.block.ymin)
		local blocksize = (model.block.xmax - model.block.xmin + 1)*(model.block.ymax - model.block.ymin + 1)
		verify(model.numAgents <= blocksize, "block not big enough to contain all agents")
		verify(model.agentVision.min >= 1)
		verify(model.agentVision.max >= model.agentVision.min)
		verify(model.agentWealth.max >= model.agentWealth.min)
		verify(model.agentLifetime.max >= model.agentLifetime.min)
		verify(model.agentMetabolism.max >= model.agentMetabolism.min)
		verify(model.numAgents > 0)
		verify(model.growthRate > 0)
		verify(model.season.summerGrowthRate > model.season.winterGrowthRate)
		verify(model.season.winterGrowthRate > 0)
	end
}

