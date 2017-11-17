# A3XX EFIS controller by Joshua Davidson (it0uchpods).

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

setlistener("sim/signals/fdm-initialized", func {
	setprop("/instrumentation/efis/nd/display-mode", "NAV");
	setprop("/instrumentation/efis/mfd/pnl_mode-num", 2);
	setprop("/instrumentation/efis/inputs/range-nm", 20);
	setprop("/instrumentation/efis/inputs/tfc", 1);
	setprop("/instrumentation/efis[1]/nd/display-mode", "NAV");
	setprop("/instrumentation/efis[1]/mfd/pnl_mode-num", 2);
	setprop("/instrumentation/efis[1]/inputs/range-nm", 20);
	setprop("/instrumentation/efis[1]/inputs/tfc", 1);
	setprop("/controls/lighting/ndl-norm", "1");
	setprop("/controls/lighting/ndr-norm", "1");
});

# Captain

var ctl_func = func(md,val) {
    if(md == "range") {
        var rng = getprop("/instrumentation/efis/inputs/range-nm");
        if(val ==1){
            rng = rng * 2;
            if(rng > 320) rng = 320;
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

var cpt_efis_btns = func(i) {
	if (i == "cstr") {
		setprop("/instrumentation/efis/inputs/CSTR", 1);
		setprop("/instrumentation/efis/inputs/wpt", 0);
		setprop("/instrumentation/efis/inputs/VORD", 0);
		setprop("/instrumentation/efis/inputs/DME", 0);
		setprop("/instrumentation/efis/inputs/NDB", 0);
		setprop("/instrumentation/efis/inputs/arpt", 0);
	} else if (i == "wpt") {
		setprop("/instrumentation/efis/inputs/CSTR", 0);
		setprop("/instrumentation/efis/inputs/wpt", 1);
		setprop("/instrumentation/efis/inputs/VORD", 0);
		setprop("/instrumentation/efis/inputs/DME", 0);
		setprop("/instrumentation/efis/inputs/NDB", 0);
		setprop("/instrumentation/efis/inputs/arpt", 0);
	} else if (i == "vord") {
		setprop("/instrumentation/efis/inputs/CSTR", 0);
		setprop("/instrumentation/efis/inputs/wpt", 0);
		setprop("/instrumentation/efis/inputs/VORD", 1);
		setprop("/instrumentation/efis/inputs/DME", 1);
		setprop("/instrumentation/efis/inputs/NDB", 0);
		setprop("/instrumentation/efis/inputs/arpt", 0);
	} else if (i == "ndb") {
		setprop("/instrumentation/efis/inputs/CSTR", 0);
		setprop("/instrumentation/efis/inputs/wpt", 0);
		setprop("/instrumentation/efis/inputs/VORD", 0);
		setprop("/instrumentation/efis/inputs/DME", 0);
		setprop("/instrumentation/efis/inputs/NDB", 1);
		setprop("/instrumentation/efis/inputs/arpt", 0);
	} else if (i == "arpt") {
		setprop("/instrumentation/efis/inputs/CSTR", 0);
		setprop("/instrumentation/efis/inputs/wpt", 0);
		setprop("/instrumentation/efis/inputs/VORD", 0);
		setprop("/instrumentation/efis/inputs/DME", 0);
		setprop("/instrumentation/efis/inputs/NDB", 0);
		setprop("/instrumentation/efis/inputs/arpt", 1);
	} else if (i == "off") {
		setprop("/instrumentation/efis/inputs/CSTR", 0);
		setprop("/instrumentation/efis/inputs/wpt", 0);
		setprop("/instrumentation/efis/inputs/VORD", 0);
		setprop("/instrumentation/efis/inputs/DME", 0);
		setprop("/instrumentation/efis/inputs/NDB", 0);
		setprop("/instrumentation/efis/inputs/arpt", 0);
	}
}

# First Officer

var ctl2_func = func(md,val) {
    if(md == "range") {
        var rng = getprop("/instrumentation/efis[1]/inputs/range-nm");
        if(val ==1){
            rng = rng * 2;
            if(rng > 320) rng = 320;
        } else if(val = -1){
            rng = rng / 2;
            if(rng < 10) rng = 10;
        }
		setprop("/instrumentation/efis[1]/inputs/range-nm", rng);
    }
}

var mode2_inc = func {
	var mode = getprop("/instrumentation/efis[1]/nd/display-mode");
	if (mode == "ILS") {
		setprop("/instrumentation/efis[1]/nd/display-mode", "VOR");
		setprop("/instrumentation/efis[1]/mfd/pnl_mode-num", 1);
	} else if (mode == "VOR") {
		setprop("/instrumentation/efis[1]/nd/display-mode", "NAV");
		setprop("/instrumentation/efis[1]/mfd/pnl_mode-num", 2);
	} else if (mode == "NAV") {
		setprop("/instrumentation/efis[1]/nd/display-mode", "ARC");
		setprop("/instrumentation/efis[1]/mfd/pnl_mode-num", 3);
	} else if (mode == "ARC") {
		setprop("/instrumentation/efis[1]/nd/display-mode", "PLAN");
		setprop("/instrumentation/efis[1]/mfd/pnl_mode-num", 4);
	} else {
		return 0;
	}
}

var mode2_dec = func {
	var mode = getprop("/instrumentation/efis[1]/nd/display-mode");
	if (mode == "PLAN") {
		setprop("/instrumentation/efis[1]/nd/display-mode", "ARC");
		setprop("/instrumentation/efis[1]/mfd/pnl_mode-num", 3);
	} else if (mode == "ARC") {
		setprop("/instrumentation/efis[1]/nd/display-mode", "NAV");
		setprop("/instrumentation/efis[1]/mfd/pnl_mode-num", 2);
	} else if (mode == "NAV") {
		setprop("/instrumentation/efis[1]/nd/display-mode", "VOR");
		setprop("/instrumentation/efis[1]/mfd/pnl_mode-num", 1);
	} else if (mode == "VOR") {
		setprop("/instrumentation/efis[1]/nd/display-mode", "ILS");
		setprop("/instrumentation/efis[1]/mfd/pnl_mode-num", 0);
	} else {
		return 0;
	}
}

var fo_efis_btns = func(i) {
	if (i == "cstr") {
		setprop("/instrumentation/efis[1]/inputs/CSTR", 1);
		setprop("/instrumentation/efis[1]/inputs/wpt", 0);
		setprop("/instrumentation/efis[1]/inputs/VORD", 0);
		setprop("/instrumentation/efis[1]/inputs/DME", 0);
		setprop("/instrumentation/efis[1]/inputs/NDB", 0);
		setprop("/instrumentation/efis[1]/inputs/arpt", 0);
	} else if (i == "wpt") {
		setprop("/instrumentation/efis[1]/inputs/CSTR", 0);
		setprop("/instrumentation/efis[1]/inputs/wpt", 1);
		setprop("/instrumentation/efis[1]/inputs/VORD", 0);
		setprop("/instrumentation/efis[1]/inputs/DME", 0);
		setprop("/instrumentation/efis[1]/inputs/NDB", 0);
		setprop("/instrumentation/efis[1]/inputs/arpt", 0);
	} else if (i == "vord") {
		setprop("/instrumentation/efis[1]/inputs/CSTR", 0);
		setprop("/instrumentation/efis[1]/inputs/wpt", 0);
		setprop("/instrumentation/efis[1]/inputs/VORD", 1);
		setprop("/instrumentation/efis[1]/inputs/DME", 1);
		setprop("/instrumentation/efis[1]/inputs/NDB", 0);
		setprop("/instrumentation/efis[1]/inputs/arpt", 0);
	} else if (i == "ndb") {
		setprop("/instrumentation/efis[1]/inputs/CSTR", 0);
		setprop("/instrumentation/efis[1]/inputs/wpt", 0);
		setprop("/instrumentation/efis[1]/inputs/VORD", 0);
		setprop("/instrumentation/efis[1]/inputs/DME", 0);
		setprop("/instrumentation/efis[1]/inputs/NDB", 1);
		setprop("/instrumentation/efis[1]/inputs/arpt", 0);
	} else if (i == "arpt") {
		setprop("/instrumentation/efis[1]/inputs/CSTR", 0);
		setprop("/instrumentation/efis[1]/inputs/wpt", 0);
		setprop("/instrumentation/efis[1]/inputs/VORD", 0);
		setprop("/instrumentation/efis[1]/inputs/DME", 0);
		setprop("/instrumentation/efis[1]/inputs/NDB", 0);
		setprop("/instrumentation/efis[1]/inputs/arpt", 1);
	} else if (i == "off") {
		setprop("/instrumentation/efis[1]/inputs/CSTR", 0);
		setprop("/instrumentation/efis[1]/inputs/wpt", 0);
		setprop("/instrumentation/efis[1]/inputs/VORD", 0);
		setprop("/instrumentation/efis[1]/inputs/DME", 0);
		setprop("/instrumentation/efis[1]/inputs/NDB", 0);
		setprop("/instrumentation/efis[1]/inputs/arpt", 0);
	}
}
