require("sugarscape")

--TODO: Waiting for ticket #967 to document this file properly.
--[[ Sugarscape scenarios - parameters and rules that are different from defaults ]]

--TODO: Waiting for ticket #970 to document this table properly
--- Animation II-1: immediate growth, default movement and metabolism.
-- For this first run, we take the initial population to be 400
-- agents arranged in a random spatial distribution. 
-- For the first run, the sugarscape will follow "immediate growback rule".
-- The sugarscape grows back to full capacity immediately.
-- @name sc_II_1
-- @class function
sc_II_1 = Sugarscape{
	growbackRule  = "immediateGrowth",
	showNumAgents = true
}

sc_II_1:execute(500)

