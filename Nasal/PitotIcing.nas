######################################################
# Fail the pitot tude due to icing of the pitot tube #
# Code by Jonathan Redpath 							 #
######################################################

var PitotIcingReset = func {
	setprop("/systems/pitot/icing", 0.0);
	setprop("/systems/pitot/failed", 1);
	pitot_timer.start();
}

PitotIcing = func {
	var icing = getprop("/systems/pitot/icing");
	var failed = getprop("/systems/pitot/failed");

	if( icing > 0.03 ) {
		if( !failed ) {
			setprop("/systems/pitot/failed", 1);
		}
	} else if( icing < 0.03 ) {
		if( failed ) {
			setprop("/systems/pitot/failed", 0);
		}
	}
};

###################
# Update Function #
###################

var update_pitotIcing = func {
	PitotIcing();
}

var pitot_timer = maketimer(0.2, update_pitotIcing);