# A320 Bleed System Notes

# Air Cond Press Vent
setlistener("/sim/signals/fdm-initialized", func {
	#System Stuff
	setprop("/controls/bleedair/mixingunithasair",0); #mixing unit which mixes new air and recycled air. Supplied also by groundconnect and ramair
	setprop("/controls/bleedair/ramairswguard",0); #guard of ramair sw pb. 0 is down, 1 is up. 
	setprop("/controls/bleedair/ramairsw",0); #emergency supply of ambient air. If ditching pb not on, opens valve
	setprop("/controls/bleedair/ramairvalve",0); #allows ram air to supply air
	setprop("/controls/bleedair/ramairinlet",0); #supply to valve. Closes at takeoff if TOGA and wheels compressed or at landing if compressed and spd > 70kts. open 20 seconds after speed is less than 70
	setprop("/controls/bleedair/groundconnect",0); #ground supply of cabin air
	setprop("/controls/bleedair/apubleed",0); #APU supply
	setprop("/controls/bleedair/cabfans",1); #ventilation panel, turns on cabin fans
	setprop("/controls/bleedair/hotairsw","0"); #allows supply to trim valves. 0 off 1 on 2 fault
	setprop("/controls/bleedair/packs/flowswitch","1"); #pack flow ctrl switch, one is NORM zero is LOW two is HIGH. 
	#Pack Controls
	setprop("/controls/bleedair/packs/one","0"); #0 off 1 on 2 fault. 
	setprop("/controls/bleedair/packs/two","0"); #0 off 1 on 2 fault
	setprop("/controls/bleedair/packs/flowvalve1","0"); #flow ctrl valve one. Closes due to overheat, engine start, fire pb, or ditching pb
	setprop("/controls/bleedair/packs/flowvalve2","0"); #flow ctrl valve two. Closes due to overheat, engine start, fire pb, or ditching pb
	setprop("/controls/bleedair/packs/compoutlettemp1","50"); #temp before main heat exchanger, air is compressed to heat up. ovht at 230C
	setprop("/controls/bleedair/packs/compoutlettemp2","50"); #temp before main heat exchanger, air is compressed to heat up ovht at 230C
	setprop("/controls/bleedair/packs/packoutlettemp1","24"); #temp after main heat exchanger, cooled to coldest zone temp. Hot air added if some zones are hotter. ovht at 90C
	setprop("/controls/bleedair/packs/packoutlettemp2","24"); #temp after main heat exchanger, cooled to coldest zone temp. Hot air added if some zones are hotter ovht at 90C
	#Hot Air
	setprop("/controls/bleedair/hotair/valve1pos","0"); #adds hot air to pack air. Closes if either cockpit or both cabin trim valves fail or duct overheats
	setprop("/controls/bleedair/hotair/valve1fail",0); #fail valve
	setprop("/controls/bleedair/hotair/valve1overheat",0); #overhat
	setprop("/controls/bleedair/hotair/hotairtemp","50"); #put it at 50, I think it is 50. Overheat at 88, fault goes out at 70.
	#Trim Valves
	setprop("/controls/bleedair/trimvalves/onepos","0"); #trim valve for cockpit. Allows cool / heat. Pack air is constant temp. Changing valve pos allows change of temp
	setprop("/controls/bleedair/trimvalves/twopos","0"); #trim valve for fwd cabin
	setprop("/controls/bleedair/trimvalves/threepos","0"); #trim valve for aft cabin
	setprop("/controls/bleedair/trimvalves/fail1",0); #trim valve for cockpit failure
	setprop("/controls/bleedair/trimvalves/fail2",0); #trim valve for fwd cabin failure
	setprop("/controls/bleedair/trimvalves/fail3",0); #trim valve for aft cabin failure
	#Cabin and Cockpit Temp
	setprop("/controls/bleedair/aircond/zone1temp","24"); #18 min, 30 max. 24 is '12-o-clock'. Cockpit
	setprop("/controls/bleedair/aircond/zone2temp","24"); #18 min, 30 max. 24 is '12-o-clock'. FWD Cabin
	setprop("/controls/bleedair/aircond/zone3temp","24"); #18 min, 30 max. 24 is '12-o-clock'. AFT Cabin
	setprop("/controls/bleedair/aircond/zone1ducttemp","25"); #Cockpit duct temp, ovht at 80
	setprop("/controls/bleedair/aircond/zone2ducttemp","26"); #FWD cabin
	setprop("/controls/bleedair/aircond/zone3ducttemp","27"); #AFT cabin
	print("Bleed System ... Done!")
});

	#Zone controller: If only one pack or APU is supplying supplies HIGH. If LOW and cannot maintain temp supplies NORM. Also if not enough bleed tells engine FADEC to increase minimum idle to increase bleed or APU controller to do same
	#Zone controller: two channels, secondary is backup. If no 2 is lost no effect, just no backup. If no 1 is lost no 2 is active and HOT AIR / TRIM valves close. No more flow setting or optimization via trim valves increasing / decreasing temp
	#Zone controller: if no 1 is lost temp is 24c and pack one is for cockpit only. pack two for cabin. ALTN mode on COND page
	#Zone controller: if both are lost pack one gives 20C and pack two gives 10C, COND is blank except for PACK REG
	
	#Pack controller: two channels. If no 2 is lost no backup and ECAM signals of corresponding pack lost
	#Pack controller: if no 1 lost pack flow is stuck at setting and no optimization. No 2 is now active
	#Pack controller: if both channels lost anti-ice valve stabilizes setting between 5c and 30c within 6 min. ECAM signals of corresponding pack lost
	
	#ACM: if compressor or turbine fails affected pack operates in heat exchanger mode. Warm air enters via pack valve then to prim heat exchanger. Then most of air goes via bypass valve downstream of ACM. Reduces pack flow. Temp regulated
	#ACM: by bypass valve and ram air inlet. Trim valves modulate hot air. Lower hot air supply.
	
	#HOT AIR valve: failed open, no effect. failed close no optimized regulation. Pack one supplies cockpit air temp and pack two supplies averaged cabin temp.
	#TRIM valve: failed stops optimization of associated zone
	
	
	#PACKS:  if pb on pack is on unless ENG START conditions, compressor outlet ovht, fire or ditching, or upstream press blw minimum. FAULT means control valve disagrees with selected pos or pack outlet / compressor outlet ovht
	#ENG start: if xfeed clsd, bleed supply valve on starting engine closes when mode selector goes to IGN or CRK (ie if starting from both off, no pack air)
	#ENG start: valve remains closed while start valve is open, N2 is less than 50, and MASTER is on or MAN START pb is on
	#ENG start: if xfeed open, both valves close even if just starting one engine. Reopening of valves delayed by 30 sec to avoid them closing again for supplementary cycle on second eng start
	
	#PACK flow sel: LO = 80, HI = 120. NORM = 100
	
	#RAM air: has guard
	#RAM air: IF ditching = norm, then ON comes on white and ram inlet opens. If delta P is greater / equals than 1 outflow valve remains closed. If less than 1 and automatic outflow goes to 50% and if manual does not automatically open. RAM goes directly to mixer
	
	#CAB fans on Vent panel: on and off
	
	
	#ECAM -- I will do this when it0uchpods or me makes the system
	# from top to bottom
	
	#BLEED
	#Pack outlet temp: amber above 90C
	#RAM inlet: Inline amber: open fully in flight or normally on ground. In transit amber: partial open. Green crossline: closed
	#Bypass valve pos: C is cold, closed. H is hot, open.
	#Compressor outlet temp: amber above 230C
	#Pack flow: amber if pack flow ctrl valve closed, green if open
	#| in circle, green: not closed
	#| in circle, amber: not closed - disagree
	#- in circle, green: fully closed
	#- in circle, amber: fully closed - disagree
	
	#COND
	#ALTN MODE two lines above cabin temp diagram - primary zone ctrl fault (green)
	#PACK REG same place -- total zone ctrl fail (green). Basic regulation by packs only.
	#FAN just left of cockpit-cabin division, one line above: amber if fault. FAN just right of FWD - AFT division, one line above, amber if fault
	#Zone temp: inside diagram. green
	#zone duct: green, then amber above 80.
	#trim valve ind: amber if trim valve fails. C: fully closed. H: fully open.
	#hot air press reg valve: 
		#inline: green, fully open
		#inline: amber, not closed, disagree with control pos
		#crossline: green, fully closed, PB at auto
		#crossline: amber, closed and PB off or valve disagree closed
	#TEMP: F or C in cyan. Top middle right
	
	#PRESS
	#pack triangles at bottom: triangle green and text white. Both amber when pack flow ctrl valve closed with engine running
	
	#CRUISE
	#shows C or F and zone temp
	
	
	
	#EWD
		#MEMO
			#RAM AIR ON: green if PB on
		#WARNINGS: see smartcockpit for details
	
	
	


