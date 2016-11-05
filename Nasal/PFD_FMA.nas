# This file converts the IT-AUTOFLIGHT Mode numbers, and converts them into text strings for the Airbus Style PFD.
# Joshua Davidson (it0uchpods/411)

# Speed or Mach?
var speedmach = func {
  if (getprop("/it-autoflight/apvertmode") == 4) {
    # Do nothing because it's in FLCH mode.
  } else {
    if (getprop("/it-autoflight/apthrmode") == 0) {
      setprop("/modes/pfd/fma/throttle-mode", "SPEED");
    } else if (getprop("/it-autoflight/apthrmode") == 1) {
      setprop("/modes/pfd/fma/throttle-mode", "MACH");
    }
  }
}

# Update Speed or Mach
setlistener("/it-autoflight/apthrmode", func {
  speedmach();
});

# Master Thrust
setlistener("/it-autoflight/apthrmode2", func {
  var latset = getprop("/it-autoflight/apthrmode2");
  if (latset == 0) {
	speedmach();
  } else if (latset == 1) {
	setprop("/modes/pfd/fma/throttle-mode", "THR IDLE");
	flch();
  } else if (latset == 2) {
	setprop("/modes/pfd/fma/throttle-mode", "THR CLB");
	flch();
  }
});

# Master Lateral
setlistener("/it-autoflight/aplatmode", func {
  var latset = getprop("/it-autoflight/aplatmode");
  if (latset == 0) {
	setprop("/modes/pfd/fma/roll-mode", "HDG");
  } else if (latset == 1) {
	setprop("/modes/pfd/fma/roll-mode", "NAV");
  } else if (latset == 2) {
	setprop("/modes/pfd/fma/roll-mode", "LOC");
  }
});

# Master Vertical
setlistener("/it-autoflight/apvertmode", func {
  var latset = getprop("/it-autoflight/apvertmode");
  if (latset == 0) {
	setprop("/modes/pfd/fma/pitch-mode", "ALT HLD");
  } else if (latset == 1) {
	setprop("/modes/pfd/fma/pitch-mode", "V/S");
  } else if (latset == 2) {
	setprop("/modes/pfd/fma/pitch-mode", "G/S");
  } else if (latset == 4) {
	flch();
  } else if (latset == 6) {
	setprop("/modes/pfd/fma/pitch-mode", "LAND");
  }
});

var flch = func {
  var calt = getprop("/instrumentation/altimeter/indicated-altitude-ft");
  var alt = getprop("/it-autoflight/settings/target-altitude-ft-actual");
  if (calt < alt) {
	  setprop("/modes/pfd/fma/pitch-mode", "OP CLB");
    } else if (calt > alt) {
	  setprop("/modes/pfd/fma/pitch-mode", "OP DES");
    }
}

# Arm LOC
setlistener("/it-autoflight/loc-armed", func {
  var loca = getprop("/it-autoflight/loc-armed");
  if (loca) {
    setprop("/modes/pfd/fma/roll-mode-armed", "LOC");
  } else {
    setprop("/modes/pfd/fma/roll-mode-armed", " ");
  }
});

# Arm G/S
setlistener("/it-autoflight/appr-armed", func {
  var appa = getprop("/it-autoflight/appr-armed");
  if (appa) {
    setprop("/modes/pfd/fma/pitch-mode-armed", "G/S");
  } else {
    setprop("/modes/pfd/fma/pitch-mode-armed", " ");
  }
});

# AP
var ap = func {
  var ap1 = getprop("/it-autoflight/ap_master");
  var ap2 = getprop("/it-autoflight/ap_master2");
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
  var fd1 = getprop("/it-autoflight/fd_master");
  var fd2 = getprop("/it-autoflight/fd_master2");
  if (fd1 and fd2) {
    setprop("/modes/pfd/fma/fd-mode", "1FD2");
  } else if (fd1 and !fd2) {
    setprop("/modes/pfd/fma/fd-mode", "FD1");
  } else if (fd2 and !fd1) {
    setprop("/modes/pfd/fma/fd-mode", "FD2");
  } else {
    setprop("/modes/pfd/fma/fd-mode", " ");
  }
}

# AT
var at = func {
  var at = getprop("/it-autoflight/at_master");
  if (at) {
    setprop("/modes/pfd/fma/at-mode", "A/THR");
  } else {
    setprop("/modes/pfd/fma/at-mode", " ");
  }
}

# Update AP or FD
setlistener("/it-autoflight/ap_master", func {
  ap();
});
setlistener("/it-autoflight/ap_master2", func {
  ap();
});
setlistener("/it-autoflight/fd_master", func {
  fd();
});
setlistener("/it-autoflight/fd_master2", func {
  fd();
});
setlistener("/it-autoflight/at_master", func {
  at();
});

