# A340 EFIS controller by Joshua Davidson (it0uchpods/411).

setlistener("sim/signals/fdm-initialized", func {
	setprop("instrumentation/efis/mfd/pnl_mode-num", 3);
	print("EFIS ... FINE!");
});

# Captain

var ctl_func = func(md,val) {
    if(md == "range") {
        var rng = getprop("/instrumentation/efis/inputs/range-nm");
        if(val ==1){
            rng = rng * 2;
            if(rng > 640) rng = 640;
        } else if(val = -1){
            rng = rng / 2;
            if(rng < 10) rng = 10;
        }
		setprop("/instrumentation/efis/inputs/range-nm", rng);
    }
}

var mode_inc = func {
	var mode = getprop("/instrumentation/efis/nd/display-mode");
	if (mode == "ILS") {
		setprop("/instrumentation/efis/nd/display-mode", "VOR");
		setprop("/instrumentation/efis/mfd/pnl_mode-num", 1);
	} else if (mode == "VOR") {
		setprop("/instrumentation/efis/nd/display-mode", "NAV");
		setprop("/instrumentation/efis/mfd/pnl_mode-num", 2);
	} else if (mode == "NAV") {
		setprop("/instrumentation/efis/nd/display-mode", "ARC");
		setprop("/instrumentation/efis/mfd/pnl_mode-num", 3);
	} else if (mode == "ARC") {
		setprop("/instrumentation/efis/nd/display-mode", "PLAN");
		setprop("/instrumentation/efis/mfd/pnl_mode-num", 4);
	} else {
		return 0;
	}
}

var mode_dec = func {
	var mode = getprop("/instrumentation/efis/nd/display-mode");
	if (mode == "PLAN") {
		setprop("/instrumentation/efis/nd/display-mode", "ARC");
		setprop("/instrumentation/efis/mfd/pnl_mode-num", 3);
	} else if (mode == "ARC") {
		setprop("/instrumentation/efis/nd/display-mode", "NAV");
		setprop("/instrumentation/efis/mfd/pnl_mode-num", 2);
	} else if (mode == "NAV") {
		setprop("/instrumentation/efis/nd/display-mode", "VOR");
		setprop("/instrumentation/efis/mfd/pnl_mode-num", 1);
	} else if (mode == "VOR") {
		setprop("/instrumentation/efis/nd/display-mode", "ILS");
		setprop("/instrumentation/efis/mfd/pnl_mode-num", 0);
	} else {
		return 0;
	}
}