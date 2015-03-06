require("sugarscape")

--- Animation II-8: Pollution in the sugarscape.
-- Pollution formation rule: when sugar S is gathered from the sugarscape, an amount of 
-- production pollution is generated in quantity ALPHA*S. When sugar amount M is metabolized, 
-- consumption pollution is generated according to BETA*M. 
-- The total pollution on a site at time t, P(T), is the sum of the
-- pollution present at the previous time, plus the pollution
-- resulting from production and consumption activities.
--
-- Pollution diffusion rule: Diffusion on a sugarscape is simply
-- implemented as a local averaging procedure. 
-- That is, diffusion transports pollution from sites of high levels to sites of low levels.
--
-- The new agent movement rule modified for pollution is to
-- look out as far as vision permits in the four principal lattice
-- directions and identify the unoccupied site(s) having the maximum sugar to pollution ratio.
-- @name sc_II_8
-- @class function
sc_II_8 = Sugarscape{
	showNumAgents            = true,
	searchMaxRule            = "maxSugarToPollution",
	pollutionProductionRate  = 1,
	pollutionConsumptionRate = 1,
	pollutionStartTime       = 50,
	diffusionStartTime       = 100,
	pollutionFormationRule   = "pollutionProdCons",
	pollutionDiffusionRule   = "pollutionLocalDiffusion",
	finalTime = 500
} 

sc_II_8:execute()

