require("sugarscape")

--- Animation II-5: normal growth, default movement and metabolism, showing socialnetworks.
--	We want to keep track of each agent's neighbors.
--	In what follows we shall always employ the von Neumann neighborhood.
--	When an agent moves to a new position on the sugarscape it has
--	from zero to four neighbors. Each agent keeps track of these neighboring
--	agents internally until it moves again, when it replaces its old neighbors 
--	with its new neighbors.
--	@name sc_II_5
--	@class function
sc_II_5 = Sugarscape{
	growbackRule       = "normalGrowth",
	showNumAgents      = true,
	showSocialNetworks = true,
	socialNetworkRule  = "buildSocialNetworks"
}

sc_II_5:execute(500)

