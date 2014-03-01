###############################################################################
##
## German type UB I submarine for FlightGear.
##
##  Copyright (C) 2013  Anders Gidenstam  (anders(at)gidenstam.org)
##  This file is licensed under the GPL license v2 or later.
##
###############################################################################

###############################################################################
# Walk views.

# Deck

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

# Create the view managers.
var crew_walker =
        walkview.Walker.new("Walk View",
                            interiorConstraint);
#                           [walkview.JSBSimPointmass.new(29)]);

crew_walker.set_eye_height(1.70);

###############################################################################
