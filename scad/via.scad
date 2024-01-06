include <parameters.scad>
include <param_processing.scad>


module via(shape=via_shape) {
    diameter = shape[0];
    length = shape[1];
    offset = length - diameter;
    translate([h_unit/2,-v_unit/2,0]) hull() {
        for (x = [-1, 1]) {
            translate([x*offset/2,0,0]) 
                cylinder(h=pcb_thickness+1, d=diameter, center=true);
        }
    }
}

via();