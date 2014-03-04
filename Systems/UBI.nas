###############################################################################
##
## German type UB I submarine for FlightGear.
##
##  Copyright (C) 2013 - 2014  Anders Gidenstam  (anders(at)gidenstam.org)
##  This file is licensed under the GPL license v2 or later.
##
###############################################################################


###############################################################################
var ground = func {
    # Send the current ground level to the JSBSim hydrodynamics model.
    setprop("/fdm/jsbsim/hydro/environment/water-level-ft",
            getprop("/position/ground-elev-ft") +
            getprop("/fdm/jsbsim/hydro/environment/wave-amplitude-ft"));

    # Connect the FlightGear wave model to the JSBSim hydrodynamics wave model.
    #setprop("/fdm/jsbsim/hydro/environment/waves-from-deg",
    #        getprop("/environment/wave/angle") - 90.0);
    #setprop("/fdm/jsbsim/hydro/environment/wave-amplitude-ft",
    #        getprop("/environment/wave/amp"));
    # Additional properties:
    #   /environment/wave/dangle
    #   /environment/wave/factor
    #   /environment/wave/freq
    #   /environment/wave/sharp

    # Connect the JSBSim hydrodynamics wave model with the custom water shader.
    setprop("environment/waves/time-sec",
            getprop("/fdm/jsbsim/simulation/sim-time-sec"));
    setprop("environment/waves/from-deg",
            getprop("/fdm/jsbsim/hydro/environment/waves-from-deg"));
    setprop("environment/waves/length-ft",
            getprop("/fdm/jsbsim/hydro/environment/wave-length-ft"));
    setprop("environment/waves/amplitude-ft",
            getprop("/fdm/jsbsim/hydro/environment/wave-amplitude-ft"));
    setprop("environment/waves/angular-frequency-rad_sec",
            getprop("/fdm/jsbsim/hydro/environment/wave/angular-frequency-rad_sec"));
    setprop("environment/waves/wave-number-rad_ft",
            getprop("/fdm/jsbsim/hydro/environment/wave/wave-number-rad_ft"));


    settimer(ground, 0.0);
}

var _UBI_initialized = 0;
setlistener("/sim/signals/fdm-initialized", func {
    if (_UBI_initialized) return;
    #aircraft.livery.init("Aircraft/UB_I/Models/Liveries");

    setprop("surface-positions/hatch-pos-norm", 1.0);
    setprop("surface-positions/periscope-extension-norm", 0.0);

    settimer(ground, 0.0);
    print("Hydrodynamics initialized.");
    _UBI_initialized = 1;
});

###############################################################################

var clutches =
    [props.globals.getNode("controls/engines/transmission[0]/clutch"),
     props.globals.getNode("controls/engines/transmission[1]/clutch")];
#var reversers =
#    [props.globals.getNode("controls/engines/transmission[0]/reverse"),
#     props.globals.getNode("controls/engines/transmission[1]/reverse")];

###############################################################################
# Periscope handling.
var periscope_view_handler = {
    view_name : "Periscope View",
    init : func {
        me.view_name = "Periscope View";
        me.view  = view.views[view.indexof(me.view_name)];
        me.shown = 0;
    },
    start  : func {
        if (!me.shown) {
        }
        me.shown = 1;
    },
    stop   : func {
        if (me.shown) {
        }
        me.shown = 0;
    },
    update : func {
        var cur = props.globals.getNode("/sim/current-view");
        var heading = cur.getNode("heading-offset-deg").getValue();
        var extension = getprop("surface-positions/periscope-extension-norm");

        setprop("surface-positions/periscope-rotation-deg", heading);
        cur.getNode("x-offset-m").setValue(0.00);
        cur.getNode("y-offset-m").setValue(5.68 + 3.1*extension);
        cur.getNode("z-offset-m").setValue(13.50);
        cur.getNode("pitch-offset-deg").setValue(0.0);

        return 0.0;
    }
};

view.manager.register(view.indexof(periscope_view_handler.view_name),
                      periscope_view_handler);

# Temporary persicope control.
var cmdId = 0;
var movePeriscope = func(id, d) {
    if (id != cmdId) return;
    var p = "surface-positions/periscope-extension-norm";
    var n = controls.slewProp(p, d);
    n = math.max(n, 0.0);
    n = math.min(n, 1.0);
    setprop(p, n);
    settimer(func { movePeriscope(id, d); }, 0.0);
}

controls.flapsDown = func(step) {
    cmdId += 1;
    if (step != 0) {
        movePeriscope(cmdId, -0.1*step);
    }
}


###############################################################################
# On-screen displays
var left  = screen.display.new(20, 10);
var right = screen.display.new(-300, 10);

left.add("/fdm/jsbsim/sim-time-sec");
left.add("/orientation/heading-magnetic-deg");
left.add("/fdm/jsbsim/hydro/true-course-deg");
left.add("/fdm/jsbsim/hydro/hull/pitch-deg");
left.add("/fdm/jsbsim/hydro/hull/height-agl-ft");
left.add("/fdm/jsbsim/hydro/hull/roll-deg");
left.add("/fdm/jsbsim/hydro/hull/wave-influence-norm");
left.add("/fdm/jsbsim/hydro/alpha-deg");
left.add("/fdm/jsbsim/hydro/beta-deg");
left.add("/fdm/jsbsim/inertia/cg-x-in");
left.add("/fdm/jsbsim/inertia/cg-z-in");
#left.add("/fdm/jsbsim/fcs/rudder-pos-norm");
#left.add("/fdm/jsbsim/fcs/elevator-pos-norm");
left.add("/fdm/jsbsim/hydro/fdrag-lbs");
#left.add("/fdm/jsbsim/hydro/hull-drag-lbs");
left.add("/fdm/jsbsim/hydro/fside-lbs");
left.add("/fdm/jsbsim/hydro/fbz-lbs");
left.add("/fdm/jsbsim/hydro/buoyancy-lbs");
left.add("/fdm/jsbsim/hydro/hull-lift-lbs");
#left.add("/fdm/jsbsim/hydro/X/force-lbs");
#left.add("/fdm/jsbsim/hydro/Y/force-lbs");
left.add("/fdm/jsbsim/hydro/yaw-moment-lbsft");
left.add("/fdm/jsbsim/hydro/pitch-moment-lbsft");
left.add("/fdm/jsbsim/hydro/roll-moment-lbsft");
left.add("/fdm/jsbsim/hydro/transverse-wave/wave-length-ft");
left.add("/fdm/jsbsim/hydro/transverse-wave/wave-amplitude-ft");
left.add("/fdm/jsbsim/hydro/transverse-wave/squat-ft");
left.add("/fdm/jsbsim/hydro/transverse-wave/pitch-trim-change-deg");
left.add("/fdm/jsbsim/hydro/environment/wave/relative-heading-rad");
left.add("/fdm/jsbsim/hydro/orientation/wave-pitch-trim-change-deg");
left.add("/fdm/jsbsim/hydro/orientation/wave-roll-trim-change-deg");
left.add("/fdm/jsbsim/hydro/environment/wave/angular-frequency-rad_sec");
left.add("/fdm/jsbsim/hydro/environment/wave/wave-number-rad_ft");
left.add("/fdm/jsbsim/hydro/environment/wave/level-fwd-ft");
left.add("/fdm/jsbsim/hydro/environment/wave/level-at-hrp-ft");
left.add("/fdm/jsbsim/hydro/environment/wave/level-aft-ft");


right.add("/fdm/jsbsim/hydro/v-kt");
right.add("/fdm/jsbsim/hydro/vbx-fps");
right.add("/fdm/jsbsim/hydro/vby-fps");
right.add("/fdm/jsbsim/hydro/qbar-u-psf");
right.add("/fdm/jsbsim/hydro/Frode-number");
right.add("/fdm/jsbsim/hydro/speed-length-ratio");
right.add("/fdm/jsbsim/propulsion/engine[0]/engine-rpm");
right.add("/fdm/jsbsim/propulsion/engine[0]/power-hp");
right.add("/fdm/jsbsim/propulsion/propeller[0]/power-required-hp");
right.add("/fdm/jsbsim/propulsion/propeller[0]/thrust-lbs");
right.add("/fdm/jsbsim/propulsion/propeller[0]/advance-ratio");
right.add("/fdm/jsbsim/ballast/main[0]/content-lbs");
right.add("/fdm/jsbsim/ballast/main[1]/content-lbs");
right.add("/fdm/jsbsim/inertia/pointmass-weight-lbs[6]");
right.add("/fdm/jsbsim/inertia/pointmass-weight-lbs[7]");
#right.add("/fdm/jsbsim/");

###############################################################################

###############################################################################
