var nose_wow_sav = 0;
var left_wow_sav = 0;
var right_wow_sav = 0;

var tyresmoke = func() {

	if ((getprop("/sim/replay/time") == 0) or (getprop("/sim/replay/time") == nil)) {

		if (getprop("/position/altitude-agl-ft") < 30) {

			var nose_wow_cur = getprop("/gear/gear/wow");
			var left_wow_cur = getprop("/gear/gear[3]/wow");
			var right_wow_cur = getprop("/gear/gear[4]/wow");
	
			if (nose_wow_cur and !nose_wow_sav)
				setprop("/aircraft/tyresmoke/nose", 1);
			else
				setprop("/aircraft/tyresmoke/nose", 0);
		
			if (left_wow_cur and !left_wow_sav)
				setprop("/aircraft/tyresmoke/left", 1);
			else
				setprop("/aircraft/tyresmoke/left", 0);
		
			if (right_wow_cur and !right_wow_sav)
				setprop("/aircraft/tyresmoke/right", 1);
			else
				setprop("/aircraft/tyresmoke/right", 0);
		
			nose_wow_sav = nose_wow_cur;
			left_wow_sav = left_wow_cur;
			right_wow_sav = right_wow_cur;
				
			if (left_wow_cur and (getprop("/velocities/airspeed-kt") > 70) and (getprop("controls/gear/brake-left") > 0.5)) {
				setprop("/aircraft/tyresmoke/left", 1);
			}
				
			if (right_wow_cur and (getprop("/velocities/airspeed-kt") > 70) and (getprop("controls/gear/brake-right") > 0.5)) {
				setprop("/aircraft/tyresmoke/right", 1);
			}
		
		} else {
	
			setprop("/aircraft/tyresmoke/nose", 0);
			setprop("/aircraft/tyresmoke/left", 0);
			setprop("/aircraft/tyresmoke/right", 0);
	
		}
		
	}

};
