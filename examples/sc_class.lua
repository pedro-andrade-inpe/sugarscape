require("sugarscape")

--- Animation class: Eat what the agent needs and show agents, gini index, and wealth distribution.
-- @name sc_class
-- @class function
sc_class = Sugarscape{
	metabolismRule = "eatWhatNeed",
	showNumAgents  = true,
	showGiniIndex  = true,
	showWealthDist = true
}

sc_class:execute(500)

