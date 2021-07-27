include <parameters.scad>
include <utils.scad>

use <plate.scad>
use <switch.scad>
use <mcu.scad>
use <trrs.scad>
use <standoff.scad>

module case_shell(height, switch_layout, mcu_layout, trrs_layout, plate_layout) {
    if (use_plate_layout_only) {
        linear_extrude(height, convexity=10) 
            plate_footprint(switch_layout, mcu_layout, trrs_layout, plate_layout);
    } else {
        bottom_offset = tan(case_wall_draft_angle) * (height-case_base_height);
        chamfer_offset = tan(case_wall_draft_angle)*tan(case_chamfer_angle)*case_chamfer_width / (1-tan(case_wall_draft_angle)*tan(case_chamfer_angle));
        chamfer_height = chamfer_offset/tan(case_wall_draft_angle);
        
        eps = 0.001;
        intersection() {
            // Chamfer body
            hull() {
                translate([0,0,-eps]) 
                linear_extrude(eps) 
                offset(height / tan(case_chamfer_angle) - case_chamfer_width) 
                    plate_footprint(switch_layout, mcu_layout, trrs_layout, plate_layout);
                translate([0,0,height-eps]) 
                linear_extrude(eps) 
                offset(-case_chamfer_width) 
                    plate_footprint(switch_layout, mcu_layout, trrs_layout, plate_layout);
            }
            // Main body
            hull() {
                translate([0,0,-eps]) 
                linear_extrude(case_base_height+eps) 
                offset(bottom_offset) 
                    plate_footprint(switch_layout, mcu_layout, trrs_layout, plate_layout);
                translate([0,0,height-eps]) 
                linear_extrude(eps) 
                    plate_footprint(switch_layout, mcu_layout, trrs_layout, plate_layout);
            } 
        }
    }
}

module case(switch_layout, mcu_layout, trrs_layout, plate_layout, standoff_layout) {
    height = total_thickness - backplate_case_flange;
    intersection() {
        // Trim off any components that extend past the case (e.g. standoffs)
        translate([0,0,-height+plate_thickness/2]) 
            case_shell(height, switch_layout, mcu_layout, trrs_layout, plate_layout);
        difference() {
            union() {
                // Hollow out inside of case
                translate([0,0,-height+plate_thickness/2]) difference() {
                    case_shell(height, switch_layout, mcu_layout, trrs_layout, plate_layout);
                    translate([0,0,-1]) 
                    linear_extrude(height-plate_thickness+1, convexity=10) 
                        offset(-case_wall_thickness) 
                        plate_footprint(switch_layout, mcu_layout, trrs_layout, plate_layout);
                }
                // Add undrilled standoffs
                layout_pattern(standoff_layout) {
                    plate_standoff($extra_data, true);
                }
            }
            // Add component cutouts
            layout_pattern(switch_layout) {
                switch_plate_cutout();
            }
            layout_pattern(mcu_layout) {
                mcu_case_cutout();
            }
            layout_pattern(trrs_layout) {
                trrs_case_cutout();
            }
            // Drill all standoff holes
            layout_pattern(standoff_layout) {
                case_standoff_hole($extra_data);
                plate_standoff_hole($extra_data);
                translate([0,0,plate_thickness/2-pcb_plate_spacing-pcb_thickness-pcb_backplate_spacing-backplate_thickness/2-0.5])
                    backplate_standoff_hole($extra_data);
            }
        }
    }
}

case(switch_layout_final, mcu_layout_final, trrs_layout_final, plate_layout_final, standoff_layout_final);
