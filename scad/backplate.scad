include <parameters.scad>
include <utils.scad>

use <switch.scad>
use <mcu.scad>
use <trrs.scad>
use <standoff.scad>
use <plate.scad>

module backplate(switch_layout, mcu_layout, trrs_layout, standoff_layout) {
    difference() {
        union() {
            plate_base(switch_layout, mcu_layout, trrs_layout, backplate_thickness);
            layout_pattern(standoff_layout) {
                backplate_standoff($extra_data);
            }
        }
        layout_pattern(standoff_layout) {
            backplate_standoff_hole($extra_data);
        }
    }
}

backplate(switch_layout_final, mcu_layout_final, trrs_layout_final, standoff_layout_final);