# A3XX mCDU by Joshua Davidson (it0uchpods) and Jonathan Redpath

#########################################
# Copyright (c) it0uchpods Design Group #
#########################################

var perfCRZInput = func(key) {
	if (key == "L6") {
		setprop("/MCDU[0]/page", "CLB");
	}
	if (key == "R6") {
		setprop("/MCDU[0]/page", "DES");
	}
}
