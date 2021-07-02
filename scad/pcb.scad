include <parameters.scad>
include <utils.scad>

use <switch.scad>
use <mcu.scad>
use <trrs.scad>
use <standoff.scad>

module pcb(layout, mcu_layout, trrs_layout, standoff_layout) {
    difference() {
        union() {
            layout_pattern(layout) {
                key_socket_base($borders);
            }
            layout_pattern(mcu_layout) {
                mcu($borders);
            }
            layout_pattern(trrs_layout) {
                trrs($borders);
            }
            if (standoff_type == "pcb") {
                standoff_height = 
                    pcb_plate_spacing + pcb_thickness - plate_thickness -  fit_tolerance;
                layout_pattern(standoff_layout) {
                    translate([0,0,(standoff_height-pcb_thickness)/2]) standoff(standoff_height);
                }
            }
       }
        layout_pattern(layout) {
            key_socket_cutouts($borders, $rotate_column);
        }
        if (standoff_type == "plate" || standoff_type == "separate") {
            layout_pattern(standoff_layout) {
                standoff_hole(pcb_thickness+1);
            }
        }
    }
} 

pcb(layout_final, mcu_layout_final, trrs_layout_final, standoff_layout_final);
