# A3XX ECAM Messages
# Joshua Davidson (it0uchpods)

# It no works yet, so please don't touch a thing until it works. Thanks -JD

##################
# Init Functions #
##################

setprop("/position/gear-agl-ft", 0);

######################################################
# w = White, b = Blue, g = Green, a = Amber, r = Red #
######################################################

var ECAMinit = func {
	MSGclr();
#	ECAMloop.start();
}

var MSGclr = func {
	setprop("/ECAM/msg/memo", "clear");
	setprop("/ECAM/msg/line1", " ");
	setprop("/ECAM/msg/line2", " ");
	setprop("/ECAM/msg/line3", " ");
	setprop("/ECAM/msg/line4", " ");
	setprop("/ECAM/msg/line5", " ");
	setprop("/ECAM/msg/line6", " ");
	setprop("/ECAM/msg/line7", " ");
	setprop("/ECAM/msg/line8", " ");
	setprop("/ECAM/msg/line1c", "w");
	setprop("/ECAM/msg/line2c", "w");
	setprop("/ECAM/msg/line3c", "w");
	setprop("/ECAM/msg/line4c", "w");
	setprop("/ECAM/msg/line5c", "w");
	setprop("/ECAM/msg/line6c", "w");
	setprop("/ECAM/msg/line7c", "w");
	setprop("/ECAM/msg/line8c", "w");
}

var ECAMloop = maketimer(1, func {
	if (getprop("/FMGC/status/phase") == 0 or getprop("/FMGC/status/phase") == 1) {
		# Activate T.O memo logic
	}
});
