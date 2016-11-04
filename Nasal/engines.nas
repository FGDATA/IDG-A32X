## AIRBUS A320 ENGINE CONTROL SYSTEMS
#####################################

# NOTE: Update functions are called in systems.nas

var apu =
 {
 new: func(no)
  {
  var m =
   {
   parents: [apu]
   };
  m.number = no;

  m.fire_switch = props.globals.getNode("engines/apu[" ~ no ~ "]/fire-switch", 1);
  m.fire_switch.setBoolValue(0);
  m.master_switch = props.globals.getNode("controls/APU[" ~ no ~ "]/master-switch", 1);
  m.master_switch.setBoolValue(0);
  m.on_fire = props.globals.getNode("engines/apu[" ~ no ~ "]/on-fire", 1);
  m.on_fire.setBoolValue(0);
  m.rpm = props.globals.getNode("engines/apu[" ~ no ~ "]/rpm", 1);
  m.rpm.setValue(0);
  m.running = props.globals.getNode("engines/apu[" ~ no ~ "]/running", 1);
  m.running.setBoolValue(0);
  m.serviceable = props.globals.getNode("engines/apu[" ~ no ~ "]/serviceable", 1);
  m.serviceable.setBoolValue(1);
  m.starter = props.globals.getNode("controls/APU[" ~ no ~ "]/starter", 1);
  m.starter.setBoolValue(0);

  return m;
  },
 update: func
  {
  if (me.on_fire.getBoolValue())
   {
   me.serviceable.setBoolValue(0);
   }
  if (me.fire_switch.getBoolValue())
   {
   me.on_fire.setBoolValue(0);
   }

  if (me.serviceable.getBoolValue() and (me.master_switch.getBoolValue() or me.starter.getBoolValue()))
   {
   if (me.starter.getBoolValue())
    {
    var rpm = me.rpm.getValue();
    rpm += getprop("sim/time/delta-realtime-sec") * 25;
    if (rpm >= 100)
     {
     rpm = 100;
     }
    me.rpm.setValue(rpm);
    }
   if (me.master_switch.getBoolValue() and me.rpm.getValue() == 100)
    {
    me.running.setBoolValue(1);
    }
   }
  else
   {
   me.running.setBoolValue(0);

   var rpm = me.rpm.getValue();
   rpm -= getprop("sim/time/delta-realtime-sec") * 30;
   if (rpm <= 0)
    {
    rpm = 0;
    }
   me.rpm.setValue(rpm);
   }
  }
 };
var engine =
 {
 new: func(no)
  {
  var m =
   {
   parents: [engine]
   };
  m.number = no;

  m.contrail = props.globals.getNode("engines/engine[" ~ no ~ "]/contrail", 1);
  m.contrail.setBoolValue(0);
  m.cutoff = props.globals.getNode("controls/engines/engine[" ~ no ~ "]/cutoff", 1);
  m.cutoff.setBoolValue(1);
  m.cutoff_switch = props.globals.getNode("controls/engines/engine[" ~ no ~ "]/cutoff-switch", 1);
  m.cutoff_switch.setBoolValue(1);
  m.fire_bottle_discharge = props.globals.getNode("controls/engines/engine[" ~ no ~ "]/fire-bottle-discharge", 1);
  m.fire_bottle_discharge.setBoolValue(0);
  m.n2 = props.globals.getNode("engines/engine[" ~ no ~ "]/n2", 1);
  m.n2.setValue(0);
  m.on_fire = props.globals.getNode("engines/engine[" ~ no ~ "]/on-fire", 1);
  m.on_fire.setBoolValue(0);
  m.out_of_fuel = props.globals.getNode("engines/engine[" ~ no ~ "]/out-of-fuel", 1);
  m.out_of_fuel.setBoolValue(0);
  m.reverser = props.globals.getNode("controls/engines/engine[" ~ no ~ "]/reverser", 1);
  m.reverser.setBoolValue(0);
  m.reverser_angle_rad = props.globals.getNode("fdm/jsbsim/propulsion/engine[" ~ no ~ "]/reverser-angle-rad", 1);
  m.reverser_angle_rad.setValue(0);
  m.reverser_pos_norm = props.globals.getNode("engines/engine[" ~ no ~ "]/reverser-pos-norm", 1);
  m.reverser_pos_norm.setValue(0);
  m.starter = props.globals.getNode("controls/engines/engine[" ~ no ~ "]/starter", 1);
  m.starter.setBoolValue(0);
  m.starter_switch = props.globals.getNode("controls/engines/engine[" ~ no ~ "]/starter-switch", 1);
  m.starter_switch.setBoolValue(0);
  m.serviceable = props.globals.getNode("sim/failure-manager/engines/engine[" ~ no ~ "]/serviceable", 1);
  m.serviceable.setBoolValue(1);
  m.throttle = props.globals.getNode("controls/engines/engine[" ~ no ~ "]/throttle", 1);
  m.throttle.setValue(0);

  return m;
  },
 update: func
  {
  if (me.on_fire.getBoolValue())
   {
   me.serviceable.setBoolValue(0);
   }
  if (me.fire_bottle_discharge.getBoolValue())
   {
   me.on_fire.setBoolValue(0);
   }
  if (me.serviceable.getBoolValue())
   {
   me.cutoff.setBoolValue(me.cutoff_switch.getBoolValue());
   }

  me.starter.setBoolValue(me.starter_switch.getBoolValue());
  if (getprop("controls/engines/engine-start-switch") == 0 or getprop("controls/engines/engine-start-switch") == 2)
   {
   me.starter.setBoolValue(1);
   }
  if (!props.globals.getNode("engines/apu/running").getBoolValue())
   {
   me.starter.setBoolValue(0);
   }

  if (me.n2.getValue() > 50 and props.globals.getNode("environment/contrail").getBoolValue())
   {
   me.contrail.setBoolValue(1);
   }
  else
   {
   me.contrail.setBoolValue(0);
   }
  },
 reverse_thrust: func
  {
  if (me.throttle.getValue() == 0 and props.globals.getNode("gear/gear[1]/wow").getBoolValue())
   {
   if (me.reverser_pos_norm.getValue() == 0)
    {
    interpolate(me.reverser_pos_norm.getPath(),
     1, 1.4
    );
    me.reverser_angle_rad.setValue(math.pi);
    me.reverser.setBoolValue(1);
    }
   elsif (me.reverser_pos_norm.getValue() == 1)
    {
    interpolate(me.reverser_pos_norm.getPath(),
     0, 1.4
    );
    me.reverser_angle_rad.setValue(0);
    me.reverser.setBoolValue(0);
    }
   }
  }
 };
var apu1 = apu.new(0);
var engine1 = engine.new(0);
var engine2 = engine.new(1);

# startup/shutdown functions
var startup = func
 {
 setprop("controls/electric/battery-switch", 1);
 setprop("controls/electric/engine[0]/generator", 1);
 setprop("controls/electric/engine[1]/generator", 1);
 setprop("controls/engines/engine[0]/cutoff-switch", 1);
 setprop("controls/engines/engine[1]/cutoff-switch", 1);
 setprop("controls/APU/master-switch", 1);
 setprop("controls/APU/starter", 1);

 var listener1 = setlistener("engines/apu/running", func
  {
  if (props.globals.getNode("engines/apu/running").getBoolValue())
   {
   setprop("controls/engines/engine-start-switch", 2);
   settimer(func
    {
    setprop("controls/engines/engine[0]/cutoff-switch", 0);
    setprop("controls/engines/engine[1]/cutoff-switch", 0);
    }, 2);
   removelistener(listener1);
   }
  }, 0, 0);
 var listener2 = setlistener("engines/engine[0]/running", func
  {
  if (props.globals.getNode("engines/engine[0]/running").getBoolValue())
   {
   settimer(func
    {
    setprop("controls/APU/master-switch", 0);
    setprop("controls/APU/starter", 0);
    setprop("controls/electric/battery-switch", 0);
    }, 2);
   removelistener(listener2);
   }
  }, 0, 0);
 };
var shutdown = func
 {
 setprop("controls/electric/engine[0]/generator", 0);
 setprop("controls/electric/engine[1]/generator", 0);
 setprop("controls/engines/engine[0]/cutoff-switch", 1);
 setprop("controls/engines/engine[1]/cutoff-switch", 1);
 };

# listener to activate these functions accordingly
setlistener("sim/model/start-idling", func(idle)
 {
 var run = idle.getBoolValue();
 if (run)
  {
  startup();
  }
 else
  {
  shutdown();
  }
 }, 0, 0);
