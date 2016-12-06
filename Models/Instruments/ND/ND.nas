    var nd_display = {};
 
    setlistener("sim/signals/fdm-initialized", func() {
	
		setprop("instrumentation/efis/nd/display-mode", "ARC");
		setprop("instrumentation/efis/inputs/tfc", 1);
		setprop("instrumentation/efis/inputs/wpt", 0);
		setprop("instrumentation/efis/inputs/wxr", 0);
		setprop("instrumentation/efis/inputs/sta", 0);
		setprop("instrumentation/efis/inputs/arpt", 0);
		setprop("instrumentation/efis/mfd/true-north", 0);
		
        var toggle_listeners = {
            # symbolic alias : relative property (as used in bindings), initial value, type
            'toggle_range':     {path: '/inputs/range-nm', value:40, type:'INT'},
            'toggle_weather':   {path: '/inputs/wxr', value:0, type:'BOOL'},
            'toggle_airports':  {path: '/inputs/arpt', value:0, type:'BOOL'},
            'toggle_ndb':       {path: '/inputs/NDB', value:0, type:'BOOL'},
            'toggle_stations':     {path: '/inputs/sta', value:0, type:'BOOL'},
            'toggle_vor':       {path: '/inputs/VORD', value:0, type:'BOOL'},
            'toggle_cstr':      {path: '/inputs/CSTR', value:0, type:'BOOL'},
            'toggle_waypoints':         {path: '/inputs/wpt', value:0, type:'BOOL'},
            'toggle_position':  {path: '/inputs/pos', value:0, type:'BOOL'},
            'toggle_data':              {path: '/inputs/data',value:0, type:'BOOL'},
            'toggle_terrain':   {path: '/inputs/terr',value:0, type:'BOOL'},
            'toggle_traffic':           {path: '/inputs/tfc',value:0, type:'BOOL'},
            'toggle_centered':          {path: '/inputs/nd-centered',value:0, type:'BOOL'},
            'toggle_lh_vor_adf':        {path: '/input/lh-vor-adf',value:0, type:'INT'},
            'toggle_rh_vor_adf':        {path: '/input/rh-vor-adf',value:0, type:'INT'},
            'toggle_display_mode':      {path: '/nd/canvas-display-mode', value:'NAV', type:'STRING'},
            'toggle_display_type':      {path: '/mfd/display-type', value:'LCD', type:'STRING'},
            'toggle_true_north':        {path: '/mfd/true-north', value:0, type:'BOOL'},
            'toggle_track_heading':     {path: '/trk-selected', value:0, type:'BOOL'},
            'toggle_fplan': {path: '/nd/route-manager-active', value:0, type: 'BOOL'}, # flight plan active
            'toggle_lnav': {path: '/nd/lnav', value:0, type: 'BOOL'},                  # LNAV active
            'toggle_vnav': {path: '/nd/vnav', value:0, type: 'BOOL'},                  # VNAV active
            'toggle_wpt_idx': {path: '/inputs/plan-wpt-index', value: -1, type: 'INT'},# WPT Index to be used in PLAN
            'toggle_plan_loop': {path: '/nd/plan-mode-loop', value: 0, type: 'INT'},   # Not used
            'toggle_app_mode': {path: '/nd/app-mode', value:'', type: 'STRING'},       # Approach mode string (ie. 'ILS APP')
            'toggle_cur_td': {path: '/nd/current-td', value: 0, type: 'INT'},          # Top of Desc dist. along route
            'toggle_cur_tc': {path: '/nd/current-tc', value: 0, type: 'INT'},          # Top of Climb dist. along route
            'toggle_cur_sc': {path: '/nd/current-sc', value: 0, type: 'INT'},          # Start of Climb dist. along route
            'toggle_cur_ed': {path: '/nd/current-ed', value: 0, type: 'INT'},          # End of Desc dist. along route
            'toggle_cur_sd': {path: '/nd/current-sd', value: 0, type: 'INT'},          # Start of Desc dist. along route
            'toggle_cur_ec': {path: '/nd/current-ec', value: 0, type: 'INT'},          # End of Climb dist. along route
            'toggle_lvl_off_at': {path: '/nd/level-off-at', value: 0, type: 'INT'},     # Level-off point along route
            'toggle_man_spd': {path: '/nd/managed-spd', value: 0, type: 'INT'},         # Managed Speed Mode
            'toggle_athr': {path: '/nd/athr', value: 0, type: 'INT'},                   # Auto-thrust engaged
            'toggle_spd_point_100': {path: '/nd/spd-change-raw-100', value: 0, type: 'INT'}, # Speed limit change point FL100
            'toggle_spd_point_140': {path: '/nd/spd-change-raw-140', value: 0, type: 'INT'}, # Speed limit change point FL140
            'toggle_spd_point_250': {path: '/nd/spd-change-raw-250', value: 0, type: 'INT'}, # Speed limit change point FL250
            'toggle_spd_point_260': {path: '/nd/spd-change-raw-260', value: 0, type: 'INT'}, # Speed limit change point FL260
            'toggle_nav1_frq': {path: '/nd/nav1_frq', value: 0, type: 'INT'}, # Nav1 Freq. Listener
            'toggle_nav2_frq': {path: '/nd/nav2_frq', value: 0, type: 'INT'}, # Nav2 Freq. Listener
            'toggle_adf1_frq': {path: '/nd/adf1_frq', value: 0, type: 'INT'}, # ADF1 Freq. Listener
            'toggle_adf2_frq': {path: '/nd/adf2_frq', value: 0, type: 'INT'}, # ADF2 Freq. Listener
            'toggle_hold_init': {path: '/nd/hold_init', value: 0, type: 'INT'}, # HOLD pattern init Listener
            'toggle_hold_update': {path: '/nd/hold_update', value: 0, type: 'INT'}, # HOLD pattern update Listener
            'toggle_hold_wp': {path: '/nd/hold_wp', value: '', type: 'STRING'}, # HOLD pattern waypoint
            'toggle_route_num': {path: '/nd/route_num', value: 0, type: 'INT'}, # Route waypoint count
            'toggle_cur_wp': {path: '/nd/cur_wp', value: 0, type: 'INT'}, # Current Waypoint (TO Waypoint) index
            'toggle_ap1': {path: '/nd/ap1', value: '', type: 'STRING'}, # AP1 engaged
            'toggle_ap2': {path: '/nd/ap2', value: '', type: 'STRING'}, # AP2 engaged
            'toggle_dep_rwy': {path: '/nd/dep_rwy', value: '', type: 'STRING'}, # Departure runway
            'toggle_dest_rwy': {path: '/nd/dest_rwy', value: '', type: 'STRING'}, # Destination runway
        };
 
        var ND = canvas.NavDisplay;
        var NDCpt = ND.new("instrumentation/efis", toggle_listeners, 'Airbus');
 
        nd_display.main = canvas.new({
            "name": "ND",
            "size": [1024, 1024],
            "view": [1024, 1024],
            "mipmapping": 1
        });
 
        nd_display.main.addPlacement({"node": "ND.screen"});
        var group = nd_display.main.createGroup();
 
        NDCpt.newMFD(group);
       
        NDCpt.update();
 
        setprop("instrumentation/efis/inputs/plan-wpt-index", -1);
 
        print("ND Canvas Initialized!");
    }); # fdm-initialized listener callback
 
    # Create Listeners to update the ND, change the property map values to fit
    # the properties you use in your own aircraft
 
    var property_map = {
        des_apt: "/autopilot/route-manager/destination/airport",
        dep_apt: "/autopilot/route-manager/departure/airport",
        des_rwy: "/autopilot/route-manager/destination/runway",
        dep_rwy: "/autopilot/route-manager/departure/runway",
        fplan_active: 'autopilot/route-manager/active',
        athr: '/flight-management/control/a-thrust',
        cur_wp: "/autopilot/route-manager/current-wp",
        vnav_node: "/autopilot/route-manager/vnav/",
        spd_node: "/autopilot/route-manager/spd/",
        holding: "/flight-management/hold",
        holding_points: "/flight-management/hold/points",
        adf1_frq: 'instrumentation/adf/frequencies/selected-khz',
        adf2_frq: 'instrumentation/adf[1]/frequencies/selected-khz',
        nav1_frq: 'instrumentation/nav/frequencies/selected-mhz',
        nav2_frq: 'instrumentation/nav[1]/frequencies/selected-mhz',
        lat_ctrl: 'flight-management/control/lat-ctrl',
        ver_ctrl: "flight-management/control/ver-ctrl",
        spd_ctrl: "flight-management/control/spd-ctrl",
    };
 
    setlistener("instrumentation/efis/nd/display-mode", func{
        var canvas_mode = "instrumentation/efis/nd/canvas-display-mode";
        var nd_centered = "instrumentation/efis/inputs/nd-centered";
        var mode = getprop("instrumentation/efis/nd/display-mode");
        var cvs_mode = 'NAV';
        var centered = 1;
        if(mode == 'ILS'){
            cvs_mode = 'APP';
        }
        elsif(mode == 'VOR') {
            cvs_mode = 'VOR';
        }
        elsif(mode == 'NAV'){
            cvs_mode = 'MAP';
        }
        elsif(mode == 'ARC'){
            cvs_mode = 'MAP';
            centered = 0;
        }
        elsif(mode == 'PLAN'){
            cvs_mode = 'PLAN';
        }
        setprop(canvas_mode, cvs_mode);
        setprop(nd_centered, centered);
    });
 
    setlistener(property_map.fplan_active, func{
        var actv = getprop(property_map.fplan_active);
        setprop('instrumentation/efis/nd/route-manager-active', actv);
    });
 
    setlistener(property_map.athr, func{
        var athr = getprop(property_map.athr);
        setprop('instrumentation/efis/nd/athr', (athr == 'eng'));
    });
 
    setlistener(property_map.ver_ctrl, func{
        var verctrl = getprop(property_map.ver_ctrl);
        setprop('instrumentation/efis/nd/vnav', (verctrl == 'fmgc'));
    });
 
    setlistener(property_map.spd_ctrl, func{
        var spdctrl = getprop(property_map.spd_ctrl);
        setprop('instrumentation/efis/nd/managed-spd', (spdctrl == 'fmgc'));
    });
 
    setlistener(property_map.lat_ctrl, func{
        var latctrl = getprop(property_map.lat_ctrl);
        setprop('instrumentation/efis/nd/lnav', (latctrl == 'fmgc'));
    });
 
    setlistener("/instrumentation/mcdu/f-pln/disp/first", func{
        var first = getprop("/instrumentation/mcdu/f-pln/disp/first");
        if(typeof(first) == 'nil') first = -1;
        if(getprop('autopilot/route-manager/route/num') == 0) first = -1;
        setprop("instrumentation/efis/inputs/plan-wpt-index", first);
    });
 
    setlistener('/instrumentation/efis/nd/terrain-on-nd', func{
        var terr_on_hd = getprop('/instrumentation/efis/nd/terrain-on-nd');
        var alpha = 1;
        if(terr_on_hd) alpha = 0.5;
        nd_display.main.setColorBackground(0,0,0,alpha);
    });
 
    setlistener('instrumentation/nav/frequencies/selected-mhz', func{
        var mhz = getprop('instrumentation/nav/frequencies/selected-mhz');
        if(mhz == nil) mhz = 0;
        setprop('/instrumentation/efis/nd/nav1_frq', mhz);
    });
 
    setlistener('instrumentation/nav[1]/frequencies/selected-mhz', func{
        var mhz = getprop('instrumentation/nav[1]/frequencies/selected-mhz');
        if(mhz == nil) mhz = 0;
        setprop('/instrumentation/efis/nd/nav2_frq', mhz);
    });
 
    setlistener('instrumentation/adf/frequencies/selected-khz', func{
        var khz = getprop('instrumentation/adf/frequencies/selected-khz');
        if(khz == nil) khz = 0;
        setprop('/instrumentation/efis/nd/adf1_frq', khz);
    });
 
    setlistener('instrumentation/adf[1]/frequencies/selected-khz', func{
        var khz = getprop('instrumentation/adf[1]/frequencies/selected-khz');
        if(khz == nil) khz = 0;
        setprop('/instrumentation/efis/nd/adf2_frq', khz);
    });
 
    setlistener('flight-management/hold/init', func{
        var init = getprop('flight-management/hold/init');
        if(init == nil) init = 0;
        setprop('/instrumentation/efis/nd/hold_init', init);
    });
 
    setlistener("/flight-management/hold/wp", func{
        var wpid = getprop("/flight-management/hold/wp");
        if(wpid == nil) wpid = '';
            setprop('/instrumentation/efis/nd/hold_wp', wpid);
    });
 
    setlistener('autopilot/route-manager/route/num', func{
        var num = getprop('autopilot/route-manager/route/num');
        setprop('/instrumentation/efis/nd/route_num', num);
    });
 
    setlistener(property_map.cur_wp, func(){
        var curwp = getprop('autopilot/route-manager/current-wp');
        setprop('/instrumentation/efis/nd/cur_wp',curwp);
    });
 
    setlistener("/flight-management/control/ap1-master", func(){
        var ap1 = getprop("/flight-management/control/ap1-master");
        setprop('/instrumentation/efis/nd/ap1',ap1);
    });
 
    setlistener("/flight-management/control/ap2-master", func(){
        var ap2 = getprop("/flight-management/control/ap2-master");
        setprop('/instrumentation/efis/nd/ap2',ap2);
    });
 
    setlistener("/autopilot/route-manager/departure/runway", func(){
        var rwy = getprop("/autopilot/route-manager/departure/runway");
        setprop('/instrumentation/efis/nd/dep_rwy',rwy);
    });
 
    setlistener("/autopilot/route-manager/destination/runway", func(){
        var rwy = getprop("/autopilot/route-manager/destination/runway");
        setprop('/instrumentation/efis/nd/dest_rwy',rwy);
    });
 
    var showNd = func() {
        # The optional second arguments enables creating a window decoration
        var dlg = canvas.Window.new([400, 400], "dialog");
        dlg.setCanvas( nd_display["main"] );
    }