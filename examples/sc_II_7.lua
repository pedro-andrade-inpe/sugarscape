require("sugarscape")

--- Animation II-7: Seasonal growback rule.
-- Initially it is summer in the top half of the sugarscape and winter in the bottom half.
-- Then, every Y time periods the seasons flip - in the region where it was summer it becomes
-- winter and vice versa. For each site, if the season is summer then sugar grows back at a 
-- rate of A units per time interval; if the season is winter then the growback rate 
-- is A units per B time intervals
-- @name sc_II_7
-- @class function
sc_II_7 = Sugarscape{
	showNumAgents  = true,
	growbackRule   = "seasonalGrowth",
	seasonDuration = 50,
	finalTime      = 500
}

sc_II_7:execute()

