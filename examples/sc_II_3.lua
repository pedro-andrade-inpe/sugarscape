require("sugarscape")

--- Animation II-3: normal growth, agent replacement, default movement and metabolism.
-- Shows how giniIndex and wealth distribution evolve.
-- 
-- We set each agent's maximum achievable age- beyond which it cannot live - 
-- to a random number drawn from some interval [a,b]. Of course, agents can still die 
-- of starvation,as before.
-- Given that agents are to have finite lifetimes, the second modification
-- that must be implemented is a rule of agent replacement. 
-- However, to ensure a stationary wealth distribution it is desirable to use a 
-- replacement rule that produces a constant population .
--
-- When an agent dies it is replaced by an agent of age 0 having random genetic attributes, 
-- random wealth and position on the sugarscape, and a maximum age randomly selectedfrom the range [a,b].
--
-- We want to track the distribution of wealth, and we show a histogram of wealth. 
-- While initially quite symmetrical, the distribution ends up highly skewed.
-- Such skewed wealth distributions are produced for wide ranges of agent and environment 
-- specifications. They seem to be characteristic
-- of heterogeneous agents extracting resources from a landscape of fixed capacity.
--
-- The animation also displays a real-time computation of the Gini coefficient. 
-- Note that it starts out quite small (about 0.230) and ends up fairly large (0.500). 
-- @name sc_II_3
-- @class function
sc_II_3 = Sugarscape{
	numAgents       = 250,
	growbackRule    = "normalGrowth",
	replacementRule = "ageReplacement",         
	agentLifetime   = {min = 60, max = 100},
	showNumAgents   = false,
	showGiniIndex   = true,
	showWealthDist  = true,
	finalTime       = 500
}

sc_II_3:execute()

