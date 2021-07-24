include <parameters.scad>
include <utils.scad>

use <backplate.scad>
use <pcb.scad>
use <plate.scad>
use <case.scad>

echo(str("Total thickness is ", total_thickness, "mm."));

translate([
    0,
    0,
    -plate_thickness/2 + pcb_plate_spacing + pcb_thickness 
        + pcb_backplate_spacing + backplate_thickness
])
    if (case_type == "sandwich" || case_type == "backplate_case") {
        plate(switch_layout_final, mcu_layout_final, trrs_layout_final, plate_layout_final, standoff_layout_final);
    } else if (case_type == "plate_case") {
        case(switch_layout_final, mcu_layout_final, trrs_layout_final, plate_layout_final, standoff_layout_final);
    } else {
        assert(false, "case_type parameter is invalid");
    }

translate([
    0,
    0,
    pcb_thickness/2 + pcb_backplate_spacing + backplate_thickness
])
    pcb(switch_layout_final, mcu_layout_final, trrs_layout_final, standoff_layout_final, via_layout_final);
    
translate([
    0,
    0, 
    backplate_thickness/2
])
    if (case_type == "sandwich" || case_type == "plate_case") {
        backplate(switch_layout_final, mcu_layout_final, trrs_layout_final, plate_layout_final, standoff_layout_final);
    } else if (case_type == "backplate_case") {
        // Not implemented
    } else {
        assert(false, "case_type parameter is invalid");
    }
