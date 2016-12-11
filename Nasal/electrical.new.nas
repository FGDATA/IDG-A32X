# Electrical system for A320 by Joshua Davidson (it0uchpods/411).

var ELEC_UPDATE_PERIOD	= 1;					# A periodic update in secs
var STD_VOLTS_AC	= 115;						# Typical volts for a power source
var MIN_VOLTS_AC	= 110;						# Typical minimum voltage level for generic equipment
var STD_VOLTS_DC	= 28;						# Typical volts for a power source
var MIN_VOLTS_DC	= 25;						# Typical minimum voltage level for generic equipment
var STD_AMPS		= 0;						# Not used yet
var NUM_ENGINES		= 2;

# Set all the stuff I need
setlistener("/sim/signals/fdm-initialized", func {
	# Electrical Buses
	setprop("/electrical/bus/dc-bat", 0);
	setprop("/electrical/bus/dc-bus1", 0);
	setprop("/electrical/bus/dc-bus2", 0);
	setprop("/electrical/bus/dc-ess", 0);
	setprop("/electrical/bus/ac-bus1", 0);
	setprop("/electrical/bus/ac-bus2", 0);
	setprop("/electrical/bus/ac-ess", 0);
	setprop("/electrical/bus/hot-bus1", 0);
	setprop("/electrical/bus/hot-bus2", 0);
	# Electrical Inputs
	setprop("/electrical/input/gen1", 0);
	setprop("/electrical/input/gen2", 0);
	setprop("/electrical/input/apu-gen", 0);
	setprop("/electrical/input/ext-pwr", 0);
	setprop("/electrical/input/bat1", 0);
	setprop("/electrical/input/bat2", 0);
	setprop("/electrical/input/emer-gen", 0);
	# Switches
	setprop("/electrical/switches/gen1", 0);
	setprop("/electrical/switches/gen2", 0);
	setprop("/electrical/switches/apu-gen", 0);
	setprop("/electrical/switches/ext-pwr", 0);
	setprop("/electrical/switches/emer", 0);
	setprop("/electrical/switches/galley", 0);
	setprop("/electrical/switches/ties/apu-ext-ac1", 0);
	setprop("/electrical/switches/ties/apu-ext-ac2", 0);
	setprop("/electrical/switches/ties/ac-ess-ac1", 0);
	setprop("/electrical/switches/ties/ac-ess-ac2", 0);
	setprop("/electrical/switches/ties/ac-ess-dc-ess", 0);
	setprop("/electrical/switches/ties/dc1-dc-bat", 0);
	setprop("/electrical/switches/ties/dc2-dc-bat", 0);
	setprop("/electrical/switches/ties/bat1-dc-bat", 0);
	setprop("/electrical/switches/ties/bat2-dc-bat", 0);
	setprop("/electrical/switches/ties/dc-bat-dc-ess", 0);
	setprop("/electrical/switches/ties/ac-bat-ac-ess", 0);
	setprop("/electrical/switches/ties/emer-dc-ess", 0);
	setprop("/electrical/switches/ties/emer-ac-ess", 0);
});

# Define all the stuff I need for the main elec loop
var master_elec = func {

}



















var update_electrical = func {
  master_elec();
  settimer(update_electrical, ELEC_UPDATE_PERIOD);
}

settimer(update_electrical, 2);

setlistener("/sim/signals/fdm-initialized", func {
	# Below are standard FG Electrical stuff to keep things working when the plane is powered
    setprop("/systems/electrical/outputs/adf", 0);
    setprop("/systems/electrical/outputs/audio-panel", 0);
    setprop("/systems/electrical/outputs/audio-panel[1]", 0);
    setprop("/systems/electrical/outputs/autopilot", 0);
    setprop("/systems/electrical/outputs/avionics-fan", 0);
    setprop("/systems/electrical/outputs/beacon", 0);
    setprop("/systems/electrical/outputs/bus", 0);
    setprop("/systems/electrical/outputs/cabin-lights", 0);
    setprop("/systems/electrical/outputs/dme", 0);
    setprop("/systems/electrical/outputs/efis", 0);
    setprop("/systems/electrical/outputs/flaps", 0);
    setprop("/systems/electrical/outputs/fuel-pump", 0);
    setprop("/systems/electrical/outputs/fuel-pump[1]", 0);
    setprop("/systems/electrical/outputs/gps", 0);
    setprop("/systems/electrical/outputs/gps-mfd", 0);
    setprop("/systems/electrical/outputs/hsi", 0);
    setprop("/systems/electrical/outputs/instr-ignition-switch", 0);
    setprop("/systems/electrical/outputs/instrument-lights", 0);
    setprop("/systems/electrical/outputs/landing-lights", 0);
    setprop("/systems/electrical/outputs/map-lights", 0);
    setprop("/systems/electrical/outputs/mk-viii", 0);
    setprop("/systems/electrical/outputs/nav", 0);
    setprop("/systems/electrical/outputs/nav[1]", 0);
    setprop("/systems/electrical/outputs/pitot-head", 0);
    setprop("/systems/electrical/outputs/stobe-lights", 0);
    setprop("/systems/electrical/outputs/tacan", 0);
    setprop("/systems/electrical/outputs/taxi-lights", 0);
    setprop("/systems/electrical/outputs/transponder", 0);
    setprop("/systems/electrical/outputs/turn-coordinator", 0);
});
