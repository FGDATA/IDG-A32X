# Custom Flap/Slat System by Joshua Davidson (it0uchpods)
# In air, flaps 1 is slats only. On ground, it is slats and flaps.

setprop("/controls/flight/flap-lever", 0);
setprop("/controls/flight/flap-txt", " ");

controls.flapsDown = func(step) {
	if (step == 1) {
		if (getprop("/controls/flight/flap-lever") == 0) {
			if (getprop("/velocities/airspeed-kt") <= 100) {
				setprop("/controls/flight/flaps", 0.290);
				setprop("/controls/flight/slats", 0.666);
				setprop("/controls/flight/flap-lever", 1);
				setprop("/controls/flight/flap-txt", "1+F");
				return;
			} else {
				setprop("/controls/flight/flaps", 0.000);
				setprop("/controls/flight/slats", 0.666);
				setprop("/controls/flight/flap-lever", 1);
				setprop("/controls/flight/flap-txt", "1");
				return;
			}
		} else if (getprop("/controls/flight/flap-lever") == 1) {
			setprop("/controls/flight/flaps", 0.596);
			setprop("/controls/flight/slats", 0.814);
			setprop("/controls/flight/flap-lever", 2);
			setprop("/controls/flight/flap-txt", "2");
			return;
		} else if (getprop("/controls/flight/flap-lever") == 2) {
			setprop("/controls/flight/flaps", 0.645);
			setprop("/controls/flight/slats", 0.814);
			setprop("/controls/flight/flap-lever", 3);
			setprop("/controls/flight/flap-txt", "3");
			return;
		} else if (getprop("/controls/flight/flap-lever") == 3) {
			setprop("/controls/flight/flaps", 1.000);
			setprop("/controls/flight/slats", 1.000);
			setprop("/controls/flight/flap-lever", 4);
			setprop("/controls/flight/flap-txt", "4");
			return;
		}
	} else if (step == -1) {
		if (getprop("/controls/flight/flap-lever") == 4) {
			setprop("/controls/flight/flaps", 0.645);
			setprop("/controls/flight/slats", 0.814);
			setprop("/controls/flight/flap-lever", 3);
			setprop("/controls/flight/flap-txt", "3");
			return;
		} else if (getprop("/controls/flight/flap-lever") == 3) {
			setprop("/controls/flight/flaps", 0.596);
			setprop("/controls/flight/slats", 0.814);
			setprop("/controls/flight/flap-lever", 2);
			setprop("/controls/flight/flap-txt", "2");
			return;
		} else if (getprop("/controls/flight/flap-lever") == 2) {
			if (getprop("/velocities/airspeed-kt") <= 100) {
				setprop("/controls/flight/flaps", 0.290);
				setprop("/controls/flight/slats", 0.666);
				setprop("/controls/flight/flap-lever", 1);
				setprop("/controls/flight/flap-txt", "1+F");
				return;
			} else {
				setprop("/controls/flight/flaps", 0.000);
				setprop("/controls/flight/slats", 0.666);
				setprop("/controls/flight/flap-lever", 1);
				setprop("/controls/flight/flap-txt", "1");
				return;
			}
		} else if (getprop("/controls/flight/flap-lever") == 1) {
			setprop("/controls/flight/flaps", 0.000);
			setprop("/controls/flight/slats", 0.000);
			setprop("/controls/flight/flap-lever", 0);
			setprop("/controls/flight/flap-txt", " ");
			return;
		}
	} else {
		return 0;
	}
}