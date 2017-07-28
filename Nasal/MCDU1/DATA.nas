# A3XX mCDU by Joshua Davidson (it0uchpods) and Jonathan Redpath

#######################################
# Copyright (c) A3XX Development Team #
#######################################

var dataInput = func(key) {
	if (key == "L1") {
		setprop("/MCDU[0]/page", "POSMON");
	}
}
