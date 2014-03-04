###############################################################################
##
## German type UB I submarine for FlightGear.
##
##  Copyright (C) 2013 - 2014  Anders Gidenstam  (anders(at)gidenstam.org)
##  This file is licensed under the GPL license v2 or later.
##
###############################################################################

###############################################################################
# Walk views.

# Deck
var conningTowerRoofConstraint = walkview.makeUnionConstraint
   (
    [
     walkview.SlopingYAlignedPlane.new([12.23, -0.40, 3.77],
                                       [14.90, -0.20, 3.77]),
     walkview.SlopingYAlignedPlane.new([12.85, -0.25, 3.77],
                                       [13.05,  0.25, 3.77]),
     walkview.SlopingYAlignedPlane.new([13.70, -0.25, 3.77],
                                       [14.40,  0.25, 3.77]),
     walkview.SlopingYAlignedPlane.new([12.23,  0.20, 3.77],
                                       [14.90,  0.40, 3.77])
    ]);

# Conning tower
var conningTowerConstraint = walkview.makeUnionConstraint
   (
    [
     walkview.CircularXYSurface.new([ 13.62, 0.00, 1.60 ], 0.50)
    ]);

# Interior room
var interiorConstraint = walkview.makeUnionConstraint
   (
    [
     # Torpedo compartment
     #walkview.SlopingYAlignedPlane.new([ 5.30, -0.20, -0.25],
     #                                  [ 8.75,  0.20, -0.25]),
     walkview.SlopingYAlignedPlane.new([ 8.55, -0.20, -0.25],
                                       [ 8.75,  0.20, -0.25]),
     # Fwd battery compartment
     walkview.SlopingYAlignedPlane.new([ 8.75, -0.40, -0.45],
                                       [11.00,  0.40, -0.45]),
     # Control room
     walkview.SlopingYAlignedPlane.new([11.00,  0.10, -0.45],
                                       [11.30,  0.65, -0.45]),
     walkview.SlopingYAlignedPlane.new([11.30, -0.50, -0.45],
                                       [11.90,  0.65, -0.45]),
     walkview.SlopingYAlignedPlane.new([11.90, -0.50, -0.45],
                                       [13.30,  0.50, -0.45]),
     walkview.SlopingYAlignedPlane.new([13.30, -0.50, -0.45],
                                       [13.70, -0.15, -0.45]),
     walkview.SlopingYAlignedPlane.new([13.30,  0.15, -0.45],
                                       [13.70,  0.50, -0.45]),
     walkview.SlopingYAlignedPlane.new([13.70, -0.50, -0.45],
                                       [15.40,  0.50, -0.45]),
     # Aft battery compartment
     walkview.SlopingYAlignedPlane.new([15.40, -0.40, -0.45],
                                       [17.50,  0.40, -0.45]),
     # Engine compartment
     walkview.SlopingYAlignedPlane.new([17.50, -0.80, -0.72],
                                       [18.50,  0.80, -0.72]),
     walkview.SlopingYAlignedPlane.new([18.50, -0.80, -0.72],
                                       [20.19, -0.40, -0.72]),
     walkview.SlopingYAlignedPlane.new([18.50,  0.40, -0.72],
                                       [20.19,  0.80, -0.72]),
     walkview.SlopingYAlignedPlane.new([20.19, -0.80, -0.72],
                                       [20.56, -0.40, -0.92]),
     walkview.SlopingYAlignedPlane.new([20.19,  0.40, -0.72],
                                       [20.56,  0.80, -0.92]),
     walkview.SlopingYAlignedPlane.new([20.56, -0.60, -0.92],
                                       [22.00, -0.40, -0.92]),
     walkview.SlopingYAlignedPlane.new([20.56,  0.40, -0.92],
                                       [22.00,  0.60, -0.92]),
    ]); 

var ladders = [{position: [13.62, 0.54, 0.74],
                constraint: [interiorConstraint, conningTowerConstraint],
                active: func { return 1; }},
               {position: [14.14, 0.00, 2.67],
                constraint: [conningTowerConstraint,
                             conningTowerRoofConstraint],
                active: func {
                            return getprop("surface-positions/hatch-pos-norm");
                        }
               }
              ];

var climbLadder = func (ladder) {
    var walker = walkview.active_walker();
    if (walker != nil and ladders[ladder].active()) {
        var p = walker.get_pos();
        if (math.abs(p[0] - ladders[ladder].position[0]) < 0.5 and
            math.abs(p[1] - ladders[ladder].position[1]) < 0.5 and
            math.abs(p[2] - ladders[ladder].position[2]) < 3.0) {

            if (walker.get_constraints() == ladders[ladder].constraint[0]) {
                walker.set_constraints(ladders[ladder].constraint[1]);
            } else {
                walker.set_constraints(ladders[ladder].constraint[0]);
            }
        }
    }
}


# Create the view managers.
var crew_walker =
        walkview.Walker.new("Walk View",
                            interiorConstraint);
#                           [walkview.JSBSimPointmass.new(29)]);

crew_walker.set_eye_height(1.70);

###############################################################################
