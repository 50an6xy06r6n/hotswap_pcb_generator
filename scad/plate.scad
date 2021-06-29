include <parameters.scad>
include <utils.scad>

use <standoff.scad>

function plate_borders(borders) = [
    for (border = borders) border + plate_margin*mm
];

module plate_base(borders=[1,1,1,1]) {
    translate([h_unit/2,-v_unit/2,0]) union() {
        translate([
            h_border_width/2 * (borders[3] - borders[2]),
            v_border_width/2 * (borders[0] - borders[1]),
            0
        ]) {
            cube([
                socket_size+h_border_width*(borders[2]+borders[3])+0.001,
                socket_size+v_border_width*(borders[0]+borders[1])+0.001,
                plate_thickness
            ], center=true);
        }
    }
}

module plate_cutout() {
    translate([h_unit/2,-v_unit/2,0]) {
        cube([plate_cutout_size, plate_cutout_size, plate_thickness+1],center=true);
    }
}

module plate(layout, standoff_layout) {
    difference() {
        union() {
            hull() layout_pattern(layout) {
                plate_base(plate_borders($borders)); 
            }
            if (standoff_type == "plate") {
                standoff_height = pcb_plate_spacing - min(border_z_offset * 2, 0) - fit_tolerance;
                layout_pattern(standoff_layout) {
                    translate([0,0,-(standoff_height-plate_thickness)/2]) standoff(standoff_height);
                }
            }
        }
        layout_pattern(layout) {
            plate_cutout();
        }
        if (standoff_type == "pcb" || standoff_type == "separate") {
            layout_pattern(standoff_layout) {
                standoff_hole(plate_thickness+1);
            }
        }
    }    
}

plate(layout_final, standoff_layout_final);