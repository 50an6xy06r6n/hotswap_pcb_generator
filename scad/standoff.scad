include <parameters.scad>

module standoff(height) {
    translate([h_unit/2,-v_unit/2,0]) difference() {
        cylinder(h=height,d=standoff_diameter,center=true);
        cylinder(h=height+1,d=standoff_pilot_hole_diameter,center=true);
    }
}
    
module standoff_hole(depth) {
    translate([h_unit/2,-v_unit/2,0]) cylinder(h=depth,d=standoff_clearance_hole_diameter,center=true);
}

