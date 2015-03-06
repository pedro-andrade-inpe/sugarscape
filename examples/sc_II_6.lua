require("sugarscape")

--- Animation II-6: initial distribution of agents in a block.
-- We turn now to a different kind of emergent structure, this one
-- spatial in nature.  Instead of the random initial distribution of agents 
-- on the sugarscape used earlier, suppose they are initially clustered in the dense block.
-- In all other respects the agents and sugarscape are exactly as in animation II-2. 
-- How will this block start affect the dynamics? A succession of coherent waves results, 
-- a phenomenon we did not expect.
--
-- N.B: This animation is not reproducible directly following the descriptions of the E&A book.
-- GROWBACK must be delayed by one time step (sugar does not growback as it is consumed).
-- MIN_VISION must be increased to 5.
-- MAX_VISION must be increased to 15.
-- @name sc_II_6
-- @class function
sc_II_6 = Sugarscape{
	block         = {xmin = 0, xmax = 19, ymin = 30, ymax = 49},
	placementRule = "uniform",
	growbackRule  = "delayedGrowth",
	agentVision   = {min = 5, max = 7},
	finalTime     = 500
}

sc_II_6:execute()

