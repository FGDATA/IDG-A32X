# Aircraft Config Center
# Joshua Davidson (it0uchpods)

setprop("/systems/acconfig/autoconfig-running", 0);
var main_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/main/dialog", "Aircraft/A320Family/AircraftConfig/main.xml");
var welcome_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/welcome/dialog", "Aircraft/A320Family/AircraftConfig/welcome.xml");
var ps_load_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/psload/dialog", "Aircraft/A320Family/AircraftConfig/psload.xml");
var ps_loaded_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/psloaded/dialog", "Aircraft/A320Family/AircraftConfig/psloaded.xml");
var init_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/init/dialog", "Aircraft/A320Family/AircraftConfig/ac_init.xml");
var help_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/help/dialog", "Aircraft/A320Family/AircraftConfig/help.xml");
var fbw_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/fbw/dialog", "Aircraft/A320Family/AircraftConfig/fbw.xml");
init_dlg.open();

setlistener("/sim/signals/fdm-initialized", func {
	init_dlg.close();
	welcome_dlg.open();
});

################
# Panel States #
################

# Cold and Dark
var colddark = func {
	ps_load_dlg.open();
	setprop("/systems/acconfig/autoconfig-running", 1);
	# Initial shutdown, and reinitialization.
	setprop("/controls/engines/engine-start-switch", 1);
	setprop("/controls/engines/engine[0]/cutoff-switch", 1);
	setprop("/controls/engines/engine[1]/cutoff-switch", 1);
	setprop("/controls/flight/slats", 0.000);
	setprop("/controls/flight/flaps", 0.000);
	setprop("/controls/flight/flap-lever", 0);
	setprop("/controls/flight/flap-pos", 0);
	setprop("/controls/flight/flap-txt", " ");
	A320.flaptimer.stop();
	setprop("/controls/flight/speedbrake-arm", 0);
	setprop("/controls/gear/gear-down", 1);
	systems.elec_init();
	systems.ADIRSreset();
	systems.pneu_init();
	systems.hyd_init();
	itaf.ap_init();
	setprop("/it-autoflight/input/fd1", 1);
	setprop("/it-autoflight/input/fd2", 1);
	if (getprop("/engines/engine[1]/n2") < 2) {
		colddark_b();
	} else {
		var colddark_eng_off = setlistener("/engines/engine[1]/n2", func {
			if (getprop("/engines/engine[1]/n2") < 2) {
				removelistener(colddark_eng_off);
				colddark_b();
			}
		});
	}
}
var colddark_b = func {
	# Continues the Cold and Dark script, after engines fully shutdown.
	setprop("/controls/APU/master", 0);
	setprop("/controls/APU/start", 0);
	setprop("/controls/bleed/OHP/bleedapu", 0);
	setprop("/controls/electrical/switches/gen-apu", 0);
	setprop("/controls/electrical/switches/battery1", 0);
	setprop("/controls/electrical/switches/battery2", 0);
	setprop("/systems/acconfig/autoconfig-running", 0);
	ps_load_dlg.close();
	ps_loaded_dlg.open();
}

# Ready to Start Eng
var beforestart = func {
	ps_load_dlg.open();
	setprop("/systems/acconfig/autoconfig-running", 1);
	# First, we set everything to cold and dark.
	setprop("/controls/engines/engine-start-switch", 1);
	setprop("/controls/engines/engine[0]/cutoff-switch", 1);
	setprop("/controls/engines/engine[1]/cutoff-switch", 1);
	setprop("/controls/flight/slats", 0.000);
	setprop("/controls/flight/flaps", 0.000);
	setprop("/controls/flight/flap-lever", 0);
	setprop("/controls/flight/flap-pos", 0);
	setprop("/controls/flight/flap-txt", " ");
	A320.flaptimer.stop();
	setprop("/controls/flight/speedbrake-arm", 0);
	setprop("/controls/gear/gear-down", 1);
	systems.elec_init();
	systems.ADIRSreset();
	systems.pneu_init();
	systems.hyd_init();
	itaf.ap_init();
	setprop("/it-autoflight/input/fd1", 1);
	setprop("/it-autoflight/input/fd2", 1);
	setprop("/controls/APU/master", 0);
	setprop("/controls/APU/start", 0);
	setprop("/controls/bleed/OHP/bleedapu", 0);
	setprop("/controls/electrical/switches/gen-apu", 0);
	setprop("/controls/electrical/switches/battery1", 0);
	setprop("/controls/electrical/switches/battery2", 0);
	
	# Now the Startup!
	setprop("/controls/electrical/switches/battery1", 1);
	setprop("/controls/electrical/switches/battery2", 1);
	setprop("/controls/APU/master", 1);
	setprop("/controls/APU/start", 1);
	var apu_rpm_chk = setlistener("/systems/apu/rpm", func {
		if (getprop("/systems/apu/rpm") >= 98) {
			removelistener(apu_rpm_chk);
			beforestart_b();
		}
	});
}
var beforestart_b = func {
	# Continue with engine start prep.
	setprop("/controls/electrical/switches/gen-apu", 1);
	setprop("/controls/electrical/switches/galley", 1);
	setprop("/controls/electrical/switches/gen1", 1);
	setprop("/controls/electrical/switches/gen2", 1);
	setprop("/controls/pneumatic/switches/bleedapu", 1);
	setprop("/controls/pneumatic/switches/bleed1", 1);
	setprop("/controls/pneumatic/switches/bleed2", 1);
	setprop("/controls/pneumatic/switches/pack1", 1);
	setprop("/controls/pneumatic/switches/pack2", 1);
	setprop("/controls/pneumatic/switches/hot-air", 1);
	setprop("/controls/hydraulic/eng1-pump", 1);
	setprop("/controls/hydraulic/eng2-pump", 1);
	setprop("/controls/hydraulic/elec-pump-blue", 1);
	setprop("controls/adirs/ir[0]/knob","2");
	setprop("controls/adirs/ir[1]/knob","2");
	setprop("controls/adirs/ir[2]/knob","2");
	setprop("instrumentation/adirs/ir[0]/display/ttn",0);
	setprop("instrumentation/adirs/ir[1]/display/ttn",0);
	setprop("instrumentation/adirs/ir[2]/display/ttn",0);
	setprop("instrumentation/adirs/ir[0]/aligned",1);
	setprop("instrumentation/adirs/ir[1]/aligned",1);
	setprop("instrumentation/adirs/ir[2]/aligned",1);
	setprop("/systems/acconfig/autoconfig-running", 0);
	ps_load_dlg.close();
	ps_loaded_dlg.open();
}

# Ready to Taxi
var taxi = func {
	ps_load_dlg.open();
	setprop("/systems/acconfig/autoconfig-running", 1);
	# First, we set everything to cold and dark.
	setprop("/controls/engines/engine-start-switch", 1);
	setprop("/controls/engines/engine[0]/cutoff-switch", 1);
	setprop("/controls/engines/engine[1]/cutoff-switch", 1);
	setprop("/controls/flight/slats", 0.000);
	setprop("/controls/flight/flaps", 0.000);
	setprop("/controls/flight/flap-lever", 0);
	setprop("/controls/flight/flap-pos", 0);
	setprop("/controls/flight/flap-txt", " ");
	A320.flaptimer.stop();
	setprop("/controls/flight/speedbrake-arm", 0);
	setprop("/controls/gear/gear-down", 1);
	systems.elec_init();
	systems.ADIRSreset();
	systems.pneu_init();
	systems.hyd_init();
	itaf.ap_init();
	setprop("/it-autoflight/input/fd1", 1);
	setprop("/it-autoflight/input/fd2", 1);
	setprop("/controls/APU/master", 0);
	setprop("/controls/APU/start", 0);
	setprop("/controls/bleed/OHP/bleedapu", 0);
	setprop("/controls/electrical/switches/gen-apu", 0);
	setprop("/controls/electrical/switches/battery1", 0);
	setprop("/controls/electrical/switches/battery2", 0);
	
	# Now the Startup!
	setprop("/controls/electrical/switches/battery1", 1);
	setprop("/controls/electrical/switches/battery2", 1);
	setprop("/controls/APU/master", 1);
	setprop("/controls/APU/start", 1);
	var apu_rpm_chk = setlistener("/systems/apu/rpm", func {
		if (getprop("/systems/apu/rpm") >= 99) {
			removelistener(apu_rpm_chk);
			taxi_b();
		}
	});
}
var taxi_b = func {
	# Continue with engine start prep, and start engine 2.
	setprop("/controls/electrical/switches/gen-apu", 1);
	setprop("/controls/electrical/switches/galley", 1);
	setprop("/controls/electrical/switches/gen1", 1);
	setprop("/controls/electrical/switches/gen2", 1);
	setprop("/controls/pneumatic/switches/bleedapu", 1);
	setprop("/controls/pneumatic/switches/bleed1", 1);
	setprop("/controls/pneumatic/switches/bleed2", 1);
	setprop("/controls/pneumatic/switches/pack1", 1);
	setprop("/controls/pneumatic/switches/pack2", 1);
	setprop("/controls/pneumatic/switches/hot-air", 1);
	setprop("/controls/hydraulic/eng1-pump", 1);
	setprop("/controls/hydraulic/eng2-pump", 1);
	setprop("/controls/hydraulic/elec-pump-blue", 1);
	setprop("controls/adirs/ir[0]/knob","2");
	setprop("controls/adirs/ir[1]/knob","2");
	setprop("controls/adirs/ir[2]/knob","2");
	setprop("instrumentation/adirs/ir[0]/display/ttn",0);
	setprop("instrumentation/adirs/ir[1]/display/ttn",0);
	setprop("instrumentation/adirs/ir[2]/display/ttn",0);
	setprop("instrumentation/adirs/ir[0]/aligned",1);
	setprop("instrumentation/adirs/ir[1]/aligned",1);
	setprop("instrumentation/adirs/ir[2]/aligned",1);
	settimer(taxi_c, 0.5);
}
var taxi_c = func {
	setprop("/controls/engines/engine-start-switch", 2);
	setprop("/controls/engines/engine[1]/cutoff-switch", 0);
	var eng_two_chk = setlistener("/engines/engine[1]/state", func {
		if (getprop("/engines/engine[1]/state") == 3) {
			removelistener(eng_two_chk);
			taxi_d();
		}
	});
}
var taxi_d = func {
	# Start engine 1.
	setprop("/controls/engines/engine[0]/cutoff-switch", 0);
	var eng_one_chk = setlistener("/engines/engine[0]/state", func {
		if (getprop("/engines/engine[0]/state") == 3) {
			removelistener(eng_one_chk);
			taxi_e();
		}
	});
}
var taxi_e = func {
	# After Start items.
	setprop("/controls/engines/engine-start-switch", 1);
	setprop("/controls/APU/master", 0);
	setprop("/controls/APU/start", 0);
	setprop("/controls/pneumatic/switches/bleedapu", 0);
	setprop("/systems/acconfig/autoconfig-running", 0);
	ps_load_dlg.close();
	ps_loaded_dlg.open();
}

# Ready to Takeoff
var takeoff = func {
	# The same as taxi, except we set some things afterwards.
	taxi();
	var eng_one_chk_c = setlistener("/engines/engine[0]/state", func {
		if (getprop("/engines/engine[0]/state") == 3) {
			removelistener(eng_one_chk_c);
			setprop("/controls/flight/speedbrake-arm", 1);
			setprop("/controls/flight/flaps", 0.290);
			setprop("/controls/flight/slats", 0.666);
			setprop("/controls/flight/flap-lever", 1);
			setprop("/controls/flight/flap-pos", 2);
			setprop("/controls/flight/flap-txt", "1+F");
			A320.flaptimer.start();
			setprop("/controls/flight/elevator-trim", -0.15);
		}
	});
}
