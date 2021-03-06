version = "0.4"
package = "sugarscape"
date = "7 November 2014"
authors = "Gilberto Camara and Pedro Andrade"
contact = "gilberto.camara@inpe.br, pedro.andrade@inpe.br"
content = [[
Based on the book J. Epstein and R. Axtell, <i>Growing artificial societies: social science from the bottom up</i>.
<p>
Sugarscape is an abstract agent-based model of artificial societies developed by 
Epstein and Axtell to investigate the emergence of social processes.
The model represents an artificial society in which agents move over a 50x50 cell grid. 
Each cell has a gradually renewable quantity of <i>sugar</i>, which the agent located at that cell can eat. 
However, the amount of sugar at each location varies. Agents have to consume sugar in order to survive.
If they harvest more sugar than they need immediately, they can save it and eat it later 
(or, in more complex variants of the model, can trade it with other agents). 
<p>
Agents can look to the north, south, east and west of their current locations and can see a distance 
which varies randomly, so that some agents can see many cells away while others can only see adjacent cells.
Agents also differ in their <i>metabolic rate</i>, the rate at which they use sugar. 
If their sugar level ever drops to zero, they die. 
In some simulations, new agents replace the dead ones with a random initial allocation of sugar. 
Thus there is an element of the <i>survival of the fittest</i> in the model, since those agents 
that are relatively unsuited to the environment because they have high metabolic rates, 
poor vision, or are in places where there is little sugar for harvesting, die relatively 
quickly of starvation. 
<p>
Epstein and Axtell (1996) present a series of elaborations of this basic model 
in order to illustrate a variety of features of societies. The basic model shows that even 
if agents start with an approximately symmetrical distribution of wealth (the amount of sugar 
each agent has stored), a strongly skewed wealth distribution soon develops. This is because 
a few relatively well-endowed agents are able to accumulate more and more sugar, while the majority 
only barely survive or die.
<p>
<b>To simulate this model, execute the file main.lua</b>. Different scenarios are available and can be chosen
easily in the end of such file.
<p>
This replication assumes you have Epstein and Axtell's book.
Please also read and download Anthony Bigbee MsC thesis 
<a href="http://mason-sugarscape.googlecode.com/svn-history/r22/trunk/docs/ajb_thesis_revised.pdf">
Replication of Sugarscape using MASON</a>.
]]
