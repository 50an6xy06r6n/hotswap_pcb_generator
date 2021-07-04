include <parameters.scad>
include <utils.scad>

use <backplate.scad>
use <pcb.scad>
use <plate.scad>

translate([
    0,
    0,
    -plate_thickness/2 + pcb_plate_spacing + pcb_thickness 
        + pcb_backplate_spacing + backplate_thickness
])
    plate(key_layout_final, mcu_layout_final, trrs_layout_final, standoff_layout_final);

translate([
    0,
    0,
    pcb_thickness/2 + pcb_backplate_spacing + backplate_thickness
])
    pcb(key_layout_final, mcu_layout_final, trrs_layout_final, standoff_layout_final);
    
translate([
    0,
    0,
    backplate_thickness/2
])
    backplate(key_layout_final, mcu_layout_final, trrs_layout_final, standoff_layout_final);