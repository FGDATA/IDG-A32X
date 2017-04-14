# This file converts the IT-AUTOFLIGHT Mode numbers, and converts them into text strings for the Airbus Style PFD.
# Joshua Davidson (it0uchpods/411)

# Speed or Mach?
var speedmach = func {
	if ((getprop("/it-autoflight/output/vert") == 4) or (getprop("/it-autoflight/output/vert") == 6) or (getprop("/it-autoflight/output/vert") == 7)) {
		# Do nothing because it's in FLCH mode.
	} else {
		if (getprop("/it-autoflight/input/kts-mach") == 0) {
			setprop("/modes/pfd/fma/throttle-mode", "SPEED");
		} else if (getprop("/it-autoflight/input/kts-mach") == 1) {
			setprop("/modes/pfd/fma/throttle-mode", "MACH");
		}
	}
}

# Update Speed or Mach
setlistener("/it-autoflight/input/kts-mach", func {
	speedmach();
});

# Master Thrust
setlistener("/it-autoflight/output/thr-mode", func {
	var thr = getprop("/it-autoflight/output/thr-mode");
	if (thr == 0) {
		speedmach();
	} else if (thr == 1) {
		setprop("/modes/pfd/fma/throttle-mode", "THR IDLE");
	} else if (thr == 2) {
		setprop("/modes/pfd/fma/throttle-mode", "THR CLB");
	}
});

# Master Lateral
setlistener("/it-autoflight/mode/lat", func {
	var lat = getprop("/it-autoflight/mode/lat");
	if (lat == "HDG") {
		setprop("/modes/pfd/fma/roll-mode", "HDG");
	} else if (lat == "LNAV") {
		setprop("/modes/pfd/fma/roll-mode", "NAV");
	} else if (lat == "LOC") {
		setprop("/modes/pfd/fma/roll-mode", "LOC");
	} else if (lat == "ALGN") {
		setprop("/modes/pfd/fma/roll-mode", "LAND");
	} else if (lat == "T/O") {
		setprop("/modes/pfd/fma/roll-mode", "RWY");
	}
});

# Master Vertical
setlistener("/it-autoflight/mode/vert", func {
	var vert = getprop("/it-autoflight/mode/vert");
	if (vert == "ALT HLD") {
		setprop("/modes/pfd/fma/pitch-mode", "ALT");
	} else if (vert == "ALT CAP") {
		setprop("/modes/pfd/fma/pitch-mode", "ALT");
	} else if (vert == "V/S") {
		setprop("/modes/pfd/fma/pitch-mode", "V/S");
	} else if (vert == "G/S") {
		setprop("/modes/pfd/fma/pitch-mode", "G/S");
	} else if (vert == "SPD CLB") {
		setprop("/modes/pfd/fma/pitch-mode", "OP CLB");
	} else if (vert == "SPD DES") {
		setprop("/modes/pfd/fma/pitch-mode", "OP DES");
	} else if (vert == "FPA") {
		setprop("/modes/pfd/fma/pitch-mode", "FPA");
	} else if (vert == "LAND") {
		setprop("/modes/pfd/fma/pitch-mode", "LAND");
	} else if (vert == "FLARE") {
		setprop("/modes/pfd/fma/pitch-mode", "FLARE");
	} else if (vert == "T/O CLB") {
		setprop("/modes/pfd/fma/pitch-mode", "SRS");
	} else if (vert == "G/A CLB") {
		setprop("/modes/pfd/fma/pitch-mode", "SRS");
	}
});

# Master VNAV
setlistener("/it-autoflight/mode/prof", func {
	var prof = getprop("/it-autoflight/mode/prof");
	if (prof == "VNAV HLD") {
		setprop("/modes/pfd/fma/pitch-mode", "ALT");
	} else if (prof == "VNAV CAP") {
		setprop("/modes/pfd/fma/pitch-mode", "ALT");
	} else if (prof == "VNAV SPD") {
		vnav_clbdes();
	} else if (prof == "VNAV PTH") {
		vnav_clbdes();
	}
});

var vnav_clbdes = func {
	var vert = getprop("/it-autoflight/output/vert");
	if (vert == 8) {
		var prof = getprop("/it-autoflight/internal/prof-mode");
		if (prof == "XX") {
			# Do nothing
		} else if (prof == "DES") {
			setprop("/modes/pfd/fma/pitch-mode", "DES");
		} else if (prof == "CLB") {
			setprop("/modes/pfd/fma/pitch-mode", "CLB");
		}
	}
}

# Arm LOC
setlistener("/it-autoflight/output/loc-armed", func {
	var loca = getprop("/it-autoflight/output/loc-armed");
	if (loca) {
		setprop("/modes/pfd/fma/roll-mode-armed", "LOC");
	} else {
		setprop("/modes/pfd/fma/roll-mode-armed", " ");
	}
});

# Arm G/S
setlistener("/it-autoflight/output/appr-armed", func {
	var appa = getprop("/it-autoflight/output/appr-armed");
	if (appa) {
		setprop("/modes/pfd/fma/pitch-mode-armed", "G/S");
	} else {
		setprop("/modes/pfd/fma/pitch-mode-armed", " ");
	}
});

# AP
var ap = func {
	var ap1 = getprop("/it-autoflight/output/ap1");
	var ap2 = getprop("/it-autoflight/output/ap2");
	if (ap1 and ap2) {
		setprop("/modes/pfd/fma/ap-mode", "AP1+2");
	} else if (ap1 and !ap2) {
		setprop("/modes/pfd/fma/ap-mode", "AP1");
	} else if (ap2 and !ap1) {
		setprop("/modes/pfd/fma/ap-mode", "AP2");
	} else {
		setprop("/modes/pfd/fma/ap-mode", " ");
	}
}

# FD
var fd = func {
	var fd1 = getprop("/it-autoflight/output/fd1");
	var fd2 = getprop("/it-autoflight/output/fd2");
	if (fd1 and fd2) {
		setprop("/modes/pfd/fma/fd-mode", "1FD2");
	} else if (fd1 and !fd2) {
		setprop("/modes/pfd/fma/fd-mode", "1FD-");
	} else if (fd2 and !fd1) {
		setprop("/modes/pfd/fma/fd-mode", "-FD2");
	} else {
		setprop("/modes/pfd/fma/fd-mode", " ");
	}
}

# AT
var at = func {
	var at = getprop("/it-autoflight/output/athr");
	if (at) {
		setprop("/modes/pfd/fma/at-mode", "A/THR");
	} else {
		setprop("/modes/pfd/fma/at-mode", " ");
	}
}

# Update AP FD ATHR
setlistener("/it-autoflight/output/ap1", func {
	ap();
});
setlistener("/it-autoflight/output/ap2", func {
	ap();
});
setlistener("/it-autoflight/output/fd1", func {
	fd();
});
setlistener("/it-autoflight/output/fd2", func {
	fd();
});
setlistener("/it-autoflight/output/athr", func {
	at();
});
