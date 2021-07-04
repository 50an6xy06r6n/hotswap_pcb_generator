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

module plate_base(key_layout, mcu_layout, trrs_layout, thickness=plate_thickness) {
    hull() {
        layout_pattern(key_layout) {
            key_plate_base(
                plate_borders($borders, h_border_width, v_border_width), thickness); 
        }
        layout_pattern(mcu_layout) {
            mcu_plate_base(plate_borders($borders), thickness);
        }
        layout_pattern(trrs_layout) {
            trrs_plate_base(plate_borders($borders), thickness);
        }
    }
}

module plate(key_layout, mcu_layout, trrs_layout, standoff_layout) {
    difference() {
        union() {
            plate_base(key_layout, mcu_layout, trrs_layout, plate_thickness);
            layout_pattern(standoff_layout) {
                echo($extra_data);
                plate_standoff($extra_data);
            }
        }
        layout_pattern(key_layout) {
            key_plate_cutout();
        }
        layout_pattern(mcu_layout) {
            mcu_plate_cutout();
        }
        layout_pattern(trrs_layout) {
            trrs_plate_cutout();
        }
        layout_pattern(standoff_layout) {
            plate_standoff_hole($extra_data);
        }
    }    
}

plate(key_layout_final, mcu_layout_final, trrs_layout_final, standoff_layout_final);