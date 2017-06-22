# A3XX ECAM Messages
# Joshua Davidson (it0uchpods)

# It no works yet, so please don't touch a thing until it works. Thanks -JD

##################
# Init Functions #
##################

setprop("/position/gear-agl-ft", 0);
setprop("/ECAM/noupdate", 0);
setprop("/ECAM/donotrevert", 0);

######################################################
# w = White, b = Blue, g = Green, a = Amber, r = Red #
######################################################

var ECAMinit = func {
	MSGclr();
	ECAMloop.start();
}

var MSGclr = func {
	setprop("/ECAM/ecam-checklist-active", 0);
	setprop("/ECAM/left-msg", "NONE");
	setprop("/ECAM/msg/line1", "");
	setprop("/ECAM/msg/line2", "");
	setprop("/ECAM/msg/line3", "");
	setprop("/ECAM/msg/line4", "");
	setprop("/ECAM/msg/line5", "");
	setprop("/ECAM/msg/line6", "");
	setprop("/ECAM/msg/line7", "");
	setprop("/ECAM/msg/line8", "");
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
	var noUpdate = getprop("/ECAM/noupdate");
	var doNotRevert = getprop("/ECAM/donotrevert");
	if (getprop("/FMGC/status/phase") == 0 and getprop("/engines/engine[0]/state") == 3 and getprop("/engines/engine[1]/state") == 3) {
		setprop("/ECAM/left-msg", "TO-MEMO");
	} else if (!doNotRevert) {
		setprop("/ECAM/left-msg", "NONE");
	}
	
	var leftMSG = getprop("/ECAM/left-msg");
	
	if (leftMSG == "TO-MEMO" and !noUpdate) {
		setprop("/ECAM/msg/line1", "     AUTO BRK");
		setprop("/ECAM/msg/line2", "     SIGNS");
		setprop("/ECAM/msg/line3", "     CABIN");
		setprop("/ECAM/msg/line4", "     SPLRS");
		setprop("/ECAM/msg/line5", "     FLAPS");
		setprop("/ECAM/msg/line6", "");
		setprop("/ECAM/msg/line7", "");
		setprop("/ECAM/msg/line8", "");
		setprop("/ECAM/msg/line1c", "g");
		setprop("/ECAM/msg/line2c", "g");
		setprop("/ECAM/msg/line3c", "g");
		setprop("/ECAM/msg/line4c", "g");
		setprop("/ECAM/msg/line5c", "g");
		setprop("/ECAM/msg/line6c", "g");
		setprop("/ECAM/msg/line7c", "g");
		setprop("/ECAM/msg/line8c", "g");
	}
});
