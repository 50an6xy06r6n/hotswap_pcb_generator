include <parameters.scad>
include <utils.scad>

use <switch.scad>
use <mcu.scad>
use <trrs.scad>
use <standoff.scad>
use <plate.scad>
use <case.scad>

module backplate_footprint(switch_layout, mcu_layout, trrs_layout, plate_layout) {
    case_height = total_thickness - backplate_case_flange;
    projection()
        case_shell(case_height, switch_layout, mcu_layout, trrs_layout, plate_layout);
}

module backplate_base(switch_layout, mcu_layout, trrs_layout, plate_layout, thickness=plate_thickness) {
    linear_extrude(thickness, center=true, convexity=10)
        backplate_footprint(switch_layout, mcu_layout, trrs_layout, plate_layout);
}

module backplate(switch_layout, mcu_layout, trrs_layout, plate_layout, standoff_layout) {
    difference() {
        union() {
            if (case_type == "sandwich") {
                backplate_base(switch_layout, mcu_layout, trrs_layout, plate_layout, backplate_thickness);
            } else if (case_type == "plate_case") {
                plate_base(switch_layout, mcu_layout, trrs_layout, plate_layout, backplate_thickness, -case_wall_thickness-case_fit_tolerance);
                translate([0,0,(backplate_case_flange-backplate_thickness)/2])
                    backplate_base(switch_layout, mcu_layout, trrs_layout, plate_layout, backplate_case_flange);
            }
            layout_pattern(standoff_layout) {
                backplate_standoff($extra_data);
            }
        }
        layout_pattern(standoff_layout) {
            backplate_standoff_hole($extra_data);
        }
    }
}

backplate(switch_layout_final, mcu_layout_final, trrs_layout_final, plate_layout_final, standoff_layout_final);
