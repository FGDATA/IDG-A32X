# A3XX IESI
# Joshua Davidson (it0uchpods)

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

var IESI = nil;
var IESI_display = nil;
var elapsedtime = 0;
var ASI = 0;
var alt = 0;
var altTens = 0;
var pitch = 0;
var roll = 0;

var canvas_IESI_base = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};
		
		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});
		
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
		
		me.AI_horizon_trans = me["AI_horizon"].createTransform();
		me.AI_horizon_rot = me["AI_horizon"].createTransform();
		
		me.page = canvas_group;
		
		return me;
	},
	getKeys: func() {
		return [];
	},
	update: func() {
		if (getprop("/systems/electrical/bus/dcbat") >= 25 or getprop("/systems/electrical/bus/dc1") >= 25 or getprop("/systems/electrical/bus/dc2") >= 25) {
			if (getprop("/systems/acconfig/autoconfig-running") != 1 and getprop("/instrumentation/iesi/iesi-init") != 1) {
				setprop("/instrumentation/iesi/iesi-init", 1);
				setprop("/instrumentation/iesi/iesi-init-time", getprop("/sim/time/elapsed-sec"));
			} else if (getprop("/systems/acconfig/autoconfig-running") == 1 and getprop("/instrumentation/iesi/iesi-init") != 1) {
				setprop("/instrumentation/iesi/iesi-init", 1);
				setprop("/instrumentation/iesi/iesi-init-time", getprop("/sim/time/elapsed-sec") - 87);
			}
		} else {
			setprop("/instrumentation/iesi/iesi-init", 0);
		}
		
		if (getprop("/systems/electrical/bus/dcbat") >= 25 or getprop("/systems/electrical/bus/dc1") >= 25 or getprop("/systems/electrical/bus/dc2") >= 25) {
			IESI.page.show();
			IESI.update();
		} else {
			IESI.page.hide();
		}
	},
};

var canvas_IESI = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_IESI, canvas_IESI_base]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["IESI","IESI_Init","ASI_scale","ASI_mach","ASI_mach_decimal","AI_center","AI_horizon","AI_bank","AI_slipskid","ALT_scale","ALT_one","ALT_two","ALT_three","ALT_four","ALT_five","ALT_digits","ALT_tens","ALT_meters","QNH_setting","QNH_std"];
	},
	update: func() {
		elapsedtime = getprop("/sim/time/elapsed-sec");
		if (getprop("/instrumentation/iesi/iesi-init-time") + 90 >= elapsedtime) {
			me["IESI"].hide(); 
			me["IESI_Init"].show();
		} else {
			me["IESI_Init"].hide();
			me["IESI"].show();
		}
		
		# Airspeed
		# Subtract 30, since the scale starts at 30, but don"t allow less than 0, or more than 420 situations
		if (getprop("/instrumentation/airspeed-indicator/indicated-speed-kt") <= 30) {
			ASI = 0;
		} else if (getprop("/instrumentation/airspeed-indicator/indicated-speed-kt") >= 420) {
			ASI = 390;
		} else {
			ASI = getprop("/instrumentation/airspeed-indicator/indicated-speed-kt") - 30;
		}
		me["ASI_scale"].setTranslation(0, ASI * 8.295);
		
		if (getprop("/instrumentation/airspeed-indicator/indicated-mach") >= 0.5) {
			me["ASI_mach_decimal"].show();
			me["ASI_mach"].show();
		} else {
			me["ASI_mach_decimal"].hide();
			me["ASI_mach"].hide();
		}
		
		if (getprop("/instrumentation/airspeed-indicator/indicated-mach") >= 0.999) {
			me["ASI_mach"].setText("99");
		} else {
			me["ASI_mach"].setText(sprintf("%2.0f", getprop("/instrumentation/airspeed-indicator/indicated-mach") * 100));
		}
		
		# Attitude
		pitch = getprop("/orientation/pitch-deg") or 0;
		roll =  getprop("/orientation/roll-deg") or 0;
		
		me.AI_horizon_trans.setTranslation(0, pitch * 16.74);
		me.AI_horizon_rot.setRotation(-roll * D2R, me["AI_center"].getCenter());
		
		me["AI_slipskid"].setTranslation(math.clamp(getprop("/instrumentation/slip-skid-ball/indicated-slip-skid"), -7, 7) * -15, 0);
		me["AI_bank"].setRotation(-roll * D2R);
		
		# Altitude
		me.altitude = getprop("/instrumentation/altimeter/indicated-altitude-ft");
		me.altOffset = me.altitude / 500 - int(me.altitude / 500);
		me.middleAltText = roundaboutAlt(me.altitude / 100);
		me.middleAltOffset = nil;
		if (me.altOffset > 0.5) {
			me.middleAltOffset = -(me.altOffset - 1) * 258.5528;
		} else {
			me.middleAltOffset = -me.altOffset * 258.5528;
		}
		me["ALT_scale"].setTranslation(0, -me.middleAltOffset);
		me["ALT_scale"].update();
		me["ALT_five"].setText(sprintf("%03d", abs(me.middleAltText+10)));
		me["ALT_four"].setText(sprintf("%03d", abs(me.middleAltText+5)));
		me["ALT_three"].setText(sprintf("%03d", abs(me.middleAltText)));
		me["ALT_two"].setText(sprintf("%03d", abs(me.middleAltText-5)));
		me["ALT_one"].setText(sprintf("%03d", abs(me.middleAltText-10)));
		
		me["ALT_digits"].setText(sprintf("%s", getprop("/instrumentation/altimeter/indicated-altitude-ft-pfd")));
		me["ALT_meters"].setText(sprintf("%5.0f", getprop("/instrumentation/altimeter/indicated-altitude-ft") * 0.3048));
		altTens = num(right(sprintf("%02d", getprop("/instrumentation/altimeter/indicated-altitude-ft")), 2));
		me["ALT_tens"].setTranslation(0, altTens * 3.16);
		
		# QNH
		if (getprop("/modes/altimeter/std") == 1) {
			me["QNH_setting"].hide();
			me["QNH_std"].show();
		} else {
			me["QNH_setting"].setText(sprintf("%4.0f", getprop("/instrumentation/altimeter/setting-hpa")) ~ "/" ~ sprintf("%2.2f", getprop("/instrumentation/altimeter/setting-inhg")));
			me["QNH_setting"].show();
			me["QNH_std"].hide();
		}
	},
};

setlistener("sim/signals/fdm-initialized", func {
	IESI_display = canvas.new({
		"name": "IESI",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	IESI_display.addPlacement({"node": "iesi.screen"});
	var group_IESI = IESI_display.createGroup();
	
	IESI = canvas_IESI.new(group_IESI, "Aircraft/IDG-A32X/Models/Instruments/IESI/res/iesi.svg");
	
	IESI_update.start();
	if (getprop("/systems/acconfig/options/iesi-rate") > 1) {
		rateApply();
	}
});

var rateApply = func {
	IESI_update.restart(0.07 * getprop("/systems/acconfig/options/iesi-rate"));
}

var IESI_update = maketimer(0.07, func {
	canvas_IESI_base.update();
});

var showIESI = func {
	var dlg = canvas.Window.new([256, 256], "dialog").set("resize", 1);
	dlg.setCanvas(IESI_display);
}

var roundabout = func(x) {
	var y = x - int(x);
	return y < 0.5 ? int(x) : 1 + int(x);
};

var roundaboutAlt = func(x) {
	var y = x * 0.2 - int(x * 0.2);
	return y < 0.5 ? 5 * int(x*0.2) : 5 + 5 * int(x*0.2);
};
