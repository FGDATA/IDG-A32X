# A3XX PFD
# Joshua Davidson (it0uchpods)

#########################################
# Copyright (c) it0uchpods Design Group #
#########################################

var PFD_1 = nil;
var PFD_display = nil;
setprop("/it-autoflight/output/ap1", 0);
setprop("/it-autoflight/output/ap2", 0);
setprop("/it-autoflight/output/fd1", 0);
setprop("/it-autoflight/output/fd2", 0);
setprop("/it-autoflight/output/athr", 0);
var state1 = getprop("/systems/thrust/state1");
var state2 = getprop("/systems/thrust/state2");
var ap1 = getprop("/it-autoflight/output/ap1");
var ap2 = getprop("/it-autoflight/output/ap2");
var fd1 = getprop("/it-autoflight/output/fd1");
var fd2 = getprop("/it-autoflight/output/fd2");
var athr = getprop("/it-autoflight/output/athr");
var throttle_mode = getprop("/modes/pfd/fma/throttle-mode");
var pitch_mode = getprop("/modes/pfd/fma/pitch-mode");
var pitch_mode_armed = getprop("/modes/pfd/fma/pitch-mode-armed");
var pitch_mode2_armed = getprop("/modes/pfd/fma/pitch-mode2-armed");
var roll_mode = getprop("/modes/pfd/fma/roll-mode");
var roll_mode_armed = getprop("/modes/pfd/fma/roll-mode-armed");

var canvas_PFD_base = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};

		canvas.parsesvg(canvas_group, file, {'font-mapper': font_mapper});

		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
			var svg_keys = me.getKeys();

			foreach (var key; svg_keys) {
				me[key] = canvas_group.getElementById(key);

				var clip_el = canvas_group.getElementById(key ~ "_clip");
				if (clip_el != nil) {
					clip_el.setVisible(0);
					var tran_rect = clip_el.getTransformedBounds();

					var clip_rect = sprintf("rect(%d,%d, %d,%d)", 
					tran_rect[1], # 0 ys
					tran_rect[2], # 1 xe
					tran_rect[3], # 2 ye
					tran_rect[0]); #3 xs
					#   coordinates are top,right,bottom,left (ys, xe, ye, xs) ref: l621 of simgear/canvas/CanvasElement.cxx
					me[key].set("clip", clip_rect);
					me[key].set("clip-frame", canvas.Element.PARENT);
				}
			}
		}

		me.page = canvas_group;

		return me;
	},
	getKeys: func() {
		return [];
	},
	update: func() {
		if ((getprop("/systems/electrical/bus/ac1") >= 110 or getprop("/systems/electrical/bus/ac2") >= 110) and getprop("/controls/electrical/switches/emer-gen") != 1 and getprop("/options/test-canvas") == 1) {
			PFD_1.page.show();
			PFD_1.update();
		} else {
			PFD_1.page.hide();
		}
	},
};

var canvas_PFD_1 = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_PFD_1, canvas_PFD_base]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["FMA_thrust","FMA_pitch","FMA_pitcharm","FMA_pitcharm2","FMA_roll","FMA_rollarm","FMA_combined","FMA_catmode","FMA_cattype","FMA_nodh","FMA_dh","FMA_dhn","FMA_ap","FMA_fd","FMA_athr","FMA_thrust_box","FMA_pitch_box","FMA_pitcharm_box",
		"FMA_roll_box","FMA_rollarm_box","FMA_combined_box","FMA_catmode_box","FMA_cattype_box","FMA_cat_box","FMA_dh_box","FMA_ap_box","FMA_fd_box","FMA_athr_box","ALT_digits","ALT_tens"];
	},
	update: func() {
		state1 = getprop("/systems/thrust/state1");
		state2 = getprop("/systems/thrust/state2");
		ap1 = getprop("/it-autoflight/output/ap1");
		ap2 = getprop("/it-autoflight/output/ap2");
		fd1 = getprop("/it-autoflight/output/fd1");
		fd2 = getprop("/it-autoflight/output/fd2");
		athr = getprop("/it-autoflight/output/athr");
		throttle_mode = getprop("/modes/pfd/fma/throttle-mode");
		pitch_mode = getprop("/modes/pfd/fma/pitch-mode");
		pitch_mode_armed = getprop("/modes/pfd/fma/pitch-mode-armed");
		pitch_mode2_armed = getprop("/modes/pfd/fma/pitch-mode2-armed");
		roll_mode = getprop("/modes/pfd/fma/roll-mode");
		roll_mode_armed = getprop("/modes/pfd/fma/roll-mode-armed");
	
		# FMA Thrust
		if (athr == 1 and ((state1 == "MAN" or state1 == "CL") and (state2 == "MAN" or state2 == "CL"))) {
			me["FMA_thrust"].show();
			if (getprop("/modes/pfd/fma/throttle-mode-box") == 1) {
				me["FMA_thrust_box"].show();
			} else {
				me["FMA_thrust_box"].hide();
			}
		} else {
			me["FMA_thrust"].hide();
			me["FMA_thrust_box"].hide();
		}
		
		me["FMA_thrust"].setText(sprintf("%s", throttle_mode));
		
		# FMA Pitch Roll Common
		me["FMA_combined"].setText(sprintf("%s", pitch_mode));
		
		if (pitch_mode == "LAND" or pitch_mode == "FLARE" or pitch_mode == "ROLL OUT") {
			me["FMA_pitch"].hide();
			me["FMA_roll"].hide();
			me["FMA_pitch_box"].hide();
			me["FMA_roll_box"].hide();
			me["FMA_pitcharm_box"].hide();
			me["FMA_rollarm_box"].hide();
			me["FMA_combined"].show();
			if (getprop("/modes/pfd/fma/pitch-mode-box") == 1) {
				me["FMA_combined_box"].show();
			} else {
				me["FMA_combined_box"].hide();
			}
		} else {
			me["FMA_combined"].hide();
			me["FMA_combined_box"].hide();
			if (ap1 or ap2 or fd1 or fd2) {
				me["FMA_pitch"].show();
				me["FMA_roll"].show();
			} else {
				me["FMA_pitch"].hide();
				me["FMA_roll"].hide();
			}
			if (getprop("/modes/pfd/fma/pitch-mode-box") == 1 and pitch_mode != " " and (ap1 or ap2 or fd1 or fd2)) {
				me["FMA_pitch_box"].show();
			} else {
				me["FMA_pitch_box"].hide();
			}
			if (pitch_mode_armed == " " and pitch_mode2_armed == " ") {
				me["FMA_pitcharm_box"].hide();
			} else {
				if ((getprop("/modes/pfd/fma/pitch-mode-armed-box") == 1 or getprop("/modes/pfd/fma/pitch-mode2-armed-box") == 1) and (ap1 or ap2 or fd1 or fd2)) {
					me["FMA_pitcharm_box"].show();
				} else {
					me["FMA_pitcharm_box"].hide();
				}
			}
			if (getprop("/modes/pfd/fma/roll-mode-box") == 1 and roll_mode != " " and (ap1 or ap2 or fd1 or fd2)) {
				me["FMA_roll_box"].show();
			} else {
				me["FMA_roll_box"].hide();
			}
			if (getprop("/modes/pfd/fma/roll-mode-armed-box") == 1 and roll_mode_armed != " " and (ap1 or ap2 or fd1 or fd2)) {
				me["FMA_rollarm_box"].show();
			} else {
				me["FMA_rollarm_box"].hide();
			}
		}
		
		if (ap1 or ap2 or fd1 or fd2) {
			me["FMA_pitcharm"].show();
			me["FMA_pitcharm2"].show();
			me["FMA_rollarm"].show();
		} else {
			me["FMA_pitcharm"].hide();
			me["FMA_pitcharm2"].hide();
			me["FMA_rollarm"].hide();
		}
		
		# FMA Pitch
		me["FMA_pitch"].setText(sprintf("%s", pitch_mode));
		me["FMA_pitcharm"].setText(sprintf("%s", pitch_mode_armed));
		me["FMA_pitcharm2"].setText(sprintf("%s", pitch_mode2_armed));
		
		# FMA Roll
		me["FMA_roll"].setText(sprintf("%s", roll_mode));
		me["FMA_rollarm"].setText(sprintf("%s", roll_mode_armed));
		
		# FMA CAT DH
		me["FMA_catmode"].hide();
		me["FMA_cattype"].hide();
		me["FMA_catmode_box"].hide();
		me["FMA_cattype_box"].hide();
		me["FMA_cat_box"].hide();
		me["FMA_nodh"].hide();
		me["FMA_dh_box"].hide();
		
		# FMA AP FD ATHR
		me["FMA_ap"].setText(sprintf("%s", getprop("/modes/pfd/fma/ap-mode")));
		me["FMA_fd"].setText(sprintf("%s", getprop("/modes/pfd/fma/fd-mode")));
		me["FMA_athr"].setText(sprintf("%s", getprop("/modes/pfd/fma/at-mode")));
		
		if (getprop("/modes/pfd/fma/ap-mode-box") == 1) {
			me["FMA_ap_box"].show();
		} else {
			me["FMA_ap_box"].hide();
		}
		
		if (getprop("/modes/pfd/fma/fd-mode-box") == 1) {
			me["FMA_fd_box"].show();
		} else {
			me["FMA_fd_box"].hide();
		}
		
		if (getprop("/modes/pfd/fma/athr-mode-box") == 1) {
			me["FMA_athr_box"].show();
		} else {
			me["FMA_athr_box"].hide();
		}
		
		# Altitude
		me["ALT_digits"].setText(sprintf("%s", getprop("/instrumentation/altimeter/indicated-altitude-ft-pfd")));
	},
};

setlistener("sim/signals/fdm-initialized", func {
	PFD_display = canvas.new({
		"name": "PFD",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	PFD_display.addPlacement({"node": "pfd1.screen"});
	var group_pfd1 = PFD_display.createGroup();

	PFD_1 = canvas_PFD_1.new(group_pfd1, "Aircraft/IDG-A32X/Models/Instruments/PFD-WIP/res/pfd.svg");
	
	PFD_update.start();
});

var PFD_update = maketimer(0.05, func {
	canvas_PFD_base.update();
});

var showPFD1 = func {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(PFD_display);
}
