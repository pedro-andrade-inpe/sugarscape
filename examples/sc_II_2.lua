require("sugarscape")

--- Animation II-2: normal growth, default movement and metabolism.
-- For this second run we again take the initial population to be 400
-- agents arranged in a random spatial distribution. 
-- Each agent again executes the default rules for movement and metabolism. 
-- But now let us change the sugarscape growth rule: Every site
-- whose level is less than its capacity grows back at 1 unit per time period. 
-- @name sc_II_2
-- @class function
sc_II_2 = Sugarscape{
	showNumAgents  = true,
	showGiniIndex  = true,
	showWealthDist = true
}

sc_II_2:execute(500)

