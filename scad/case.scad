include <parameters.scad>
include <utils.scad>

use <plate.scad>
use <switch.scad>
use <mcu.scad>
use <trrs.scad>
use <standoff.scad>

module case(switch_layout, mcu_layout, trrs_layout, plate_layout, standoff_layout) {
    height = pcb_plate_spacing + pcb_thickness + pcb_backplate_spacing  + backplate_thickness - backplate_case_flange;
    difference() {
        union() {
            translate([0,0,-height+plate_thickness/2]) difference() {
                linear_extrude(height, convexity=10) 
                    plate_footprint(switch_layout, mcu_layout, trrs_layout, plate_layout);
                translate([0,0,-1]) 
                linear_extrude(height-plate_thickness+1, convexity=10) 
                    offset(-case_wall_thickness) 
                    plate_footprint(switch_layout, mcu_layout, trrs_layout, plate_layout);
            }
            layout_pattern(standoff_layout) {
                plate_standoff($extra_data, true);
            }
        }
        layout_pattern(switch_layout) {
            switch_plate_cutout();
        }
        layout_pattern(mcu_layout) {
            mcu_case_cutout();
        }
        layout_pattern(trrs_layout) {
            trrs_case_cutout();
        }
        layout_pattern(standoff_layout) {
            case_standoff_hole($extra_data);
            plate_standoff_hole($extra_data);
            translate([0,0,plate_thickness/2-pcb_plate_spacing-pcb_thickness-pcb_backplate_spacing-backplate_thickness/2-0.5])
                backplate_standoff_hole($extra_data);
        }
    }
}

case(switch_layout_final, mcu_layout_final, trrs_layout_final, plate_layout_final, standoff_layout_final);
