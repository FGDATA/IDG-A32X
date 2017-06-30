##################################################################
# A3XX mCDU by Joshua Davidson (it0uchpods) and Jonathan Redpath #
##################################################################

var perfDESInput = func(key) {
	if (key == "L6") {
		setprop("/MCDU[0]/page", "CRZ");
	}
}
