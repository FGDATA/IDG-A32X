####    A320 Hydraulics System    ####
####    Jonathan Redpath    ####

print("Hydraulics: Initializing");

var hyd_init = func {
	setprop("/hydraulics/greenpump",0);
	setprop("/hydraulics/blueelecpump",0);
	setprop("/hydraulics/yellowpump",0);
	setprop("/hydraulics/yellowelecpump",0);
	setprop("/hydraulics/greenreservoir","14.5"); #MAX 14.5 L -- LO LVL 3.5 L -- NORM is 12L
	setprop("/hydraulics/bluereservoir","6.5"); #MAX 6.5 L -- LO LVL 2.4 L -- NORM is 5L
	setprop("/hydraulics/yellowreservoir","12.5"); #MAX 12.5 L -- LO LVL 3.5 L -- NORM is 10L
	setprop("/hydraulics/greenpumpppb","0"); #0 is off, 1 is fault, 2 is on
	setprop("/hydraulics/bluepumppb","0"); #0 is off, 1 is fault, 2 is auto
	setprop("/hydraulics/yellowpumppb","0"); #0 is off, 1 is fault, 2 is on
	setprop("/hydraulics/blueovrd","0"); #0 is off, 1 is on if blue pump set to AUTO
	print("Hydraulics: Pumps and Reservoirs Initialized");
	setprop("/hydraulics/ptu",0);
	setprop("/hydraulics/ratextended",0);
	setprop("/hydraulics/ratmanguard",0);
	setprop("/hydraulics/ratmanext",0);
	print("Hydraulics: PTU and RAT Initialized");
	setprop("/hydraulics/greenpsi","0");
	setprop("/hydraulics/bluepsi","0");
	setprop("/hydraulics/yellowpsi","0");
	setprop("/hydraulics/greenmaxpsi","3000");
	setprop("/hydraulics/bluemaxpsi","3000");
	setprop("/hydraulics/yellowmaxpsi","3000");
	setprop("/hydraulics/yellowhandpump",0);
	setprop("/hydraulics/greenandyellowdiff","0");
	setprop("/hydraulics/greenaccum","0");
	setprop("/hydraulics/blueaccum","0");
	setprop("/hydraulics/yellowaccum","0");
	print("Hydraulics: System Settings Initialized");
	setprop("/hydraulics/greenfirevalve",0);
	setprop("/hydraulics/blueleakvalve",0); #0 is ON ie normal 1 is OFF ie cutoff
	setprop("/hydraulics/greenleakvalve",0); #0 is ON ie normal 1 is OFF ie cutoff
	setprop("/hydraulics/yellowleakvalve",0); #0 is ON ie normal 1 is OFF ie cutoff
	setprop("/hydraulics/yellowfirevalve",0);
	setprop("/hydraulics/greentemp","0");
	setprop("/hydraulics/bluetemp","0");
	setprop("/hydraulics/yellowtemp","0");
	print("Hydraulics: Valves and Other Stuff Initialized");
	print("Hydraulics: Loaded!");
}

# PTU Operation -- conditions --
# if on ground park brake off AND NWS not in 'tow' position, ie off
# if in flight: both masters ON or OFF
# the above AND 500 psi diff between green and yellow
# cargo door operation and YELLOW P/B OFF inhibits PTU operation. PTU op is not allowed for 40 sec after cargo door opr
# inhibited on first engine start attempt
# self test on second start attempt


# RAT --
# powers blue system if no elec or no engines
# deployed if AC BUS 1 and AC BUS 2 are lost
# also deployed manually
# OHP -- on HYD panel powers the HYD 
# OHP -- on EMER ELEC panel powers EMER GEN
# MX retracts it on ground

# Reservoirs --
# pressurized by ENG 1 BLEED
# if no ENG 1 pressurized by XFEED duct
# 2.4 L -- LO LVL (blue)
# 0.5 L -- LO LVL (yellow / green)

# Yellow sys --
# When cargo door open or closed by manual system it turns off the other yellow system except for altn braking and no 2 reverser
# makes an 'OFF' on the OHP yellow pump switch

# Priority Valves --
# Priority valves are there to shut off HYD availability to anything that uses a lot of HYD power if the fluid becomes low
# GRN - NWS, SLTS, FLPS, L/G
# BLU - EMER GEN, SLTS
# YLW - FLPS

# OHP --
# Pump PBs --
# ENG 1 PUMP
#   Green System
#   OFF -- pump depressurizes
#   ON -- pump pressurizes when eng 1 running
#   FAULT -- over heat, lo lvl, lo reservoir pressure (not enough bleed air), or lo pump pressure (inhibited on ground
# BLUE ELEC PUMP
#   Blue System
#   OFF -- no electricity to blue pump
#   AUTO -- pump pressurizes in flight or when one engine is running (or if BLUE PUMP OVRD on MX panel is pushed)
#   FAULT -- over heat, lo lvl, lo reservoir pressure (not enough bleed air),  pump overheat, or lo pump pressure (inhibited on ground
# ENG 2 PUMP
#   Yellow System
#   OFF -- pump depressurizes
#   ON -- pump pressurizes when eng 1 running
#   FAULT -- over heat, lo lvl, lo reservoir pressure (not enough bleed air), or lo pump pressure (inhibited on ground)
# YELLOW ELEC PUMP
#   Yellow System
#   OFF -- pump depressurizes (reverts to this if AC power is lost and restored)
#   ON -- pump pressurizes if AC power avail
#   FAULT -- over heat, lo lvl, lo reservoir pressure (not enough bleed air), pump overheat, or lo pump pressure (inhibited on ground)
#
# PTU PB
#   AUTO -- pump armed, valves open
#   OFF -- valves closes, pump off
#   FAULT -- either green or yellow reservoir LO AIR PR or OVHT or LOW LVL
# RAT MAN ON PB
#   Push: extend manually
#   Guard: must be removed first


# MX PANEL -- AFT OHP
# BLUE PUMP OVRD --
#   ON -- if BLUE ELEC PUMP AUTO turn on BLUE ELEC pump
#   OFF -- turn off blue elec pump
# LEAK MEASUREMENT VALVES --
#   B G Y
#   ON -- normal
#   OFF -- cut off to relevant flight controls in case of leak by closing electrohydrualic valve
