# A3XX ND Canvas
# Joshua Davidson (it0uchpods) and Nikolai V. Chr.

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

io.include('A3XX_ND.nas');

io.include('A3XX_ND_drivers.nas');
canvas.NDStyles['Airbus'].options.defaults.route_driver = A3XXRouteDriver.new();

var nd_nd = nil;
var nd_nd2 = nil;

var nd_display = {};

var ND = canvas.NavDisplay;

var myCockpit_switches = {
	'toggle_range': {path: '/inputs/range-nm', value:40, type:'INT'},
	'toggle_weather': {path: '/inputs/wxr', value:0, type:'BOOL'},
	'toggle_airports': {path: '/inputs/arpt', value:0, type:'BOOL'},
	'toggle_ndb': {path: '/inputs/NDB', value:0, type:'BOOL'},
	'toggle_stations': {path: '/inputs/sta', value:0, type:'BOOL'},
	'toggle_vor': {path: '/inputs/VORD', value:0, type:'BOOL'},
	'toggle_dme': {path: '/inputs/DME', value:0, type:'BOOL'},
	'toggle_cstr': {path: '/inputs/CSTR', value:0, type:'BOOL'},
	'toggle_waypoints': {path: '/inputs/wpt', value:0, type:'BOOL'},
	'toggle_position': {path: '/inputs/pos', value:0, type:'BOOL'},
	'toggle_data': {path: '/inputs/data',value:0, type:'BOOL'},
	'toggle_terrain': {path: '/inputs/terr',value:0, type:'BOOL'},
	'toggle_traffic': {path: '/inputs/tfc',value:0, type:'BOOL'},
	'toggle_centered': {path: '/inputs/nd-centered',value:0, type:'BOOL'},
	'toggle_lh_vor_adf': {path: '/input/lh-vor-adf',value:0, type:'INT'},
	'toggle_rh_vor_adf': {path: '/input/rh-vor-adf',value:0, type:'INT'},
	'toggle_display_mode': {path: '/nd/canvas-display-mode', value:'NAV', type:'STRING'},
	'toggle_display_type': {path: '/nd/display-type', value:'LCD', type:'STRING'},
	'toggle_true_north': {path: '/nd/true-north', value:0, type:'BOOL'},
	'toggle_track_heading': {path: '/trk-selected', value:0, type:'BOOL'},
	'toggle_wpt_idx': {path: '/inputs/plan-wpt-index', value: -1, type: 'INT'},
	'toggle_plan_loop': {path: '/nd/plan-mode-loop', value: 0, type: 'INT'},
	'toggle_weather_live': {path: '/nd/wxr-live-enabled', value: 0, type: 'BOOL'},
	'toggle_chrono': {path: '/inputs/CHRONO', value: 0, type: 'INT'},
	'toggle_xtrk_error': {path: '/nd/xtrk-error', value: 0, type: 'BOOL'},
	'toggle_trk_line': {path: '/nd/trk-line', value: 0, type: 'BOOL'},
};

var canvas_nd_base = {
	init: func(canvas_group, file = nil) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};

		if (file != nil) {
			canvas.parsesvg(canvas_group, file, {'font-mapper': font_mapper});

			var svg_keys = me.getKeys();
			foreach(var key; svg_keys) {
				me[key] = canvas_group.getElementById(key);
			}
		}
		me.page = canvas_group;

		return me;
	},
	getKeys: func() {
		return [];
	},
	update: func() {
		if (getprop("/systems/electrical/bus/ac1") >= 110 and getprop("/systems/electrical/ac1-src") != "RAT" and getprop("/systems/electrical/bus/ac2") >= 110 and getprop("/systems/electrical/ac2-src") != "RAT" and getprop("/controls/lighting/DU/du2") > 0) {
			nd_nd.page.show();
			nd_nd.NDCpt.update();
		} else {
			nd_nd.page.hide();
		}
		if (getprop("/systems/electrical/bus/ac1") >= 110 and getprop("/systems/electrical/ac1-src") != "RAT" and getprop("/systems/electrical/bus/ac2") >= 110 and getprop("/systems/electrical/ac2-src") != "RAT" and getprop("/controls/lighting/DU/du5") > 0) {
			nd_nd2.page.show();
			nd_nd2.NDFo.update();
		} else {
			nd_nd2.page.hide();
		}
	},
};

var canvas_nd_nd = {
	new: func(canvas_group) {
		var m = {parents: [canvas_nd_nd, canvas_nd_base]};
		m.init(canvas_group);

		# here we make the ND:
		me.NDCpt = ND.new("instrumentation/efis", myCockpit_switches, 'Airbus');
		me.NDCpt.newMFD(canvas_group);
		me.NDCpt.update();

		return m;
	},
	getKeys: func() {
		return [];
	},
	update: func() {

	},
};

var canvas_nd_nd_r = {
	new: func(canvas_group) {
		var m = {parents: [canvas_nd_nd_r, canvas_nd_base]};
		m.init(canvas_group);

		# here we make the ND:
		me.NDFo = ND.new("instrumentation/efis[1]", myCockpit_switches, 'Airbus');
		me.NDFo.newMFD(canvas_group);
		me.NDFo.update();

		return m;
	},
	getKeys: func() {
		return [];
	},
	update: func() {

	},
};

setlistener("sim/signals/fdm-initialized", func {
	setprop("instrumentation/efis[0]/inputs/plan-wpt-index", -1);
	setprop("instrumentation/efis[1]/inputs/plan-wpt-index", -1);

	nd_display.main = canvas.new({
		"name": "ND1",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});

	nd_display.right = canvas.new({
		"name": "ND2",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});

	nd_display.main.addPlacement({"node": "ND.screen"});
	nd_display.right.addPlacement({"node": "ND_R.screen"});
	var group_nd = nd_display.main.createGroup();
	var group_nd2 = nd_display.right.createGroup();

	nd_nd = canvas_nd_nd.new(group_nd);
	nd_nd2 = canvas_nd_nd_r.new(group_nd2);

	nd_update.start();
});

var nd_update = maketimer(0.05, func {
	canvas_nd_base.update();
});

for (i = 0; i < 2; i = i + 1 ) {
	setlistener("/instrumentation/efis["~i~"]/nd/display-mode", func(node) {
		var par = node.getParent().getParent();
		var idx = par.getIndex();
		var canvas_mode = "/instrumentation/efis["~idx~"]/nd/canvas-display-mode";
		var nd_centered = "/instrumentation/efis["~idx~"]/inputs/nd-centered";
		var mode = getprop("/instrumentation/efis["~idx~"]/nd/display-mode");
		var cvs_mode = "NAV";
		var centered = 1;
		if (mode == "ILS") {
			cvs_mode = "APP";
		}
		else if (mode == "VOR") {
			cvs_mode = "VOR";
		}
		else if (mode == "NAV"){
			cvs_mode = "MAP";
		}
		else if (mode == "ARC"){
			cvs_mode = "MAP";
			centered = 0;
		}
		else if (mode == "PLAN"){
			cvs_mode = "PLAN";
		}
		setprop(canvas_mode, cvs_mode);
		setprop(nd_centered, centered);
	});
}

setlistener("/instrumentation/efis[0]/nd/terrain-on-nd", func{
	var terr_on_hd = getprop("/instrumentation/efis[0]/nd/terrain-on-nd");
	var alpha = 1;
	if (terr_on_hd) {
		alpha = 0.5;
	}
	nd_display.main.setColorBackground(0,0,0,alpha);
});

setlistener("/flight-management/control/capture-leg", func(n) {
	var capture_leg = n.getValue();
	setprop("instrumentation/efis[0]/nd/xtrk-error", capture_leg);
	setprop("instrumentation/efis[1]/nd/xtrk-error", capture_leg);
	setprop("instrumentation/efis[0]/nd/trk-line", capture_leg);
	setprop("instrumentation/efis[1]/nd/trk-line", capture_leg);
}, 0, 0);

var showNd = func(nd = nil) {
	if(nd == nil) nd = 'main';
	var dlg = canvas.Window.new([512, 512], "dialog");
	dlg.setCanvas(nd_display[nd]);
}
