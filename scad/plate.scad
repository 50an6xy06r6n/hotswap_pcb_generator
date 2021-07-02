include <parameters.scad>
include <utils.scad>

use <switch.scad>
use <mcu.scad>
use <trrs.scad>
use <standoff.scad>

function plate_borders(borders, h_unit=1, v_unit=1) = [
    borders[0] + plate_margin/v_unit,
    borders[1] + plate_margin/v_unit,
    borders[2] + plate_margin/h_unit,
    borders[3] + plate_margin/h_unit,
];

module plate(layout, mcu_layout, trrs_layout, standoff_layout) {
    difference() {
        union() {
            hull() {
                layout_pattern(layout) {
                    key_plate_base(plate_borders($borders, h_border_width, v_border_width)); 
                }
                layout_pattern(mcu_layout) {
                    mcu_plate_base(plate_borders($borders));
                }
                layout_pattern(trrs_layout) {
                    trrs_plate_base(plate_borders($borders));
                }
            }
            if (standoff_type == "plate") {
                standoff_height = pcb_plate_spacing - min(border_z_offset * 2, 0) - fit_tolerance;
                layout_pattern(standoff_layout) {
                    translate([0,0,-(standoff_height-plate_thickness)/2]) 
                        standoff(standoff_height);
                }
            }
        }
        layout_pattern(layout) {
            key_plate_cutout();
        }
        layout_pattern(mcu_layout) {
            mcu_plate_cutout();
        }
        layout_pattern(trrs_layout) {
            trrs_plate_cutout();
        }
        if (standoff_type == "pcb" || standoff_type == "separate") {
            layout_pattern(standoff_layout) {
                standoff_hole(plate_thickness+1);
            }
        }
    }    
}

plate(layout_final, mcu_layout_final, trrs_layout_final, standoff_layout_final);