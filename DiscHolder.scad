
include <lib/Round-Anything/polyround.scad>


// Make a sector of a circle manually
module sector(radius, angles, fn = 50) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) 
            [r * cos(a), r * sin(a)] // no rounding on arc
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]);

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}

// build an arc from sector differencing
module arc(radius, angles, width = 5, fn = 200) {
  
    
    difference() {
        sector(radius + width, angles, fn);
        sector(radius, angles, fn);
    }
} 


// the main disc holder module 
module discholder(angle=75, label=false) { 

hook_thickness = 8.5; // how far the hook stands-off from the wall 
tab_thickness = 2.5; // thickness of tab with screw holes
hole_size = 2; // radius of holes 
counter_sink = 5; // raadius of counter sinks

// hook
    union() { 
    // slightly rotated to keep disc in place
    rotate([-5,0,0])translate([0,0,8])linear_extrude(hook_thickness)arc(85,[angle,180 - angle]);
    // regular orientation to keep flat bottom 
    translate([0,0.5,0])linear_extrude(tab_thickness)arc(85,width=4.5,[angle,180-angle]);
         }
difference() { 
    $fn = 50;
    
    union() { 
        // Bottom triangular tab for screws 
        bracket_points=[[0,30,-8],[-12,75,8],[-28,88,3],[28,88,3],[12,75,8]];
        radiusextrudefn = 50;
        extrudeWithRadius(tab_thickness, 0, 2, radiusextrudefn)polygon(polyRound(bracket_points,10));
    }
    
    // Screw holes and counter sinks 
    // Upper hole
    translate([0,80,-2])linear_extrude(10)circle(hole_size);  // hole
    translate([0,80,1])linear_extrude(2)circle(counter_sink); // counter sink

    translate([0,60,-2])linear_extrude(10)circle(hole_size);  // hole
    translate([0,60,1])linear_extrude(2)circle(counter_sink); // counter sink

    
}

}

discholder(label=false);


