include <parameters.scad>
include <param_processing.scad>

use <grid_patterns.scad>
use <backplate.scad>
use <plate.scad>
use <switch.scad>
use <mcu.scad>
use <trrs.scad>
use <stabilizer.scad>
use <standoff.scad>

// Use an offset cycle to remove small/thin features
module usable_area(
    min_feature_size=1
) {
    offset(min_feature_size)
    offset(-min_feature_size)
    difference() {
        #children(0);
        intersection() {
            children([1:$children-1]);
        }
    }
}

module plate_usable_area(
    switch_layout,
    mcu_layout,
    trrs_layout,
    plate_layout,
    stab_layout,
    standoff_layout,
    grid_margin=border_width
) {
    usable_area() {
        offset(delta=-case_wall_thickness) plate_footprint(switch_layout, mcu_layout, trrs_layout, plate_layout, stab_layout);
        layout_pattern(switch_layout) {
            offset(delta=grid_margin*2) switch_plate_cutout_footprint();
        }
        layout_pattern(mcu_layout) {
            offset(delta=grid_margin*2) mcu_plate_cutout_footprint();
        }
        layout_pattern(trrs_layout) {
            offset(delta=grid_margin*2) trrs_plate_cutout_footprint();
        }
        layout_pattern(stab_layout) {
            offset(delta=grid_margin*2) stabilizer_plate_cutout_footprint($extra_data);
        }
        layout_pattern(standoff_layout) {
            offset(delta=grid_margin*2) plate_standoff_footprint($extra_data);
        }
    }
}

module backplate_usable_area(
    switch_layout,
    mcu_layout,
    trrs_layout,
    plate_layout,
    stab_layout,
    standoff_layout,
    grid_margin=border_width
) {
    usable_area() {
        offset(delta=-case_wall_thickness) plate_footprint(switch_layout, mcu_layout, trrs_layout, plate_layout, stab_layout);
        layout_pattern(standoff_layout) {
            offset(delta=grid_margin*2) backplate_standoff_footprint($extra_data);
        }
    }
}

module grid_plate_cutout(
    switch_layout,
    mcu_layout,
    trrs_layout,
    plate_layout,
    stab_layout,
    standoff_layout,
    grid_margin=border_width
         ) {
    intersection() {
        plate_usable_area(switch_layout, mcu_layout, trrs_layout, plate_layout, stab_layout, standoff_layout, grid_margin);
        grid_pattern(cutout_grid_size, cutout_grid_spacing, 1000, 1000);
    }
}

module grid_backplate_cutout(
    switch_layout,
    mcu_layout,
    trrs_layout,
    plate_layout,
    stab_layout,
    standoff_layout,
    grid_margin=border_width
         ) {
    intersection() {
        backplate_usable_area(switch_layout, mcu_layout, trrs_layout, plate_layout, stab_layout, standoff_layout, grid_margin);
        grid_pattern(cutout_grid_size, cutout_grid_spacing, 1000, 1000);
    }
}

// plate_usable_area(switch_layout_final, mcu_layout_final, trrs_layout_final, plate_layout_final, stab_layout_final, standoff_layout_final);

difference() {
    plate_footprint(switch_layout_final, mcu_layout_final, trrs_layout_final, plate_layout_final);
    grid_plate_cutout(switch_layout_final, mcu_layout_final, trrs_layout_final, plate_layout_final, stab_layout_final, standoff_layout_final);
    layout_pattern(switch_layout_final) {
        switch_plate_cutout_footprint();
    }
    layout_pattern(mcu_layout_final) {
        mcu_plate_cutout_footprint();
    }
    layout_pattern(trrs_layout_final) {
        trrs_plate_cutout_footprint();
    }
    layout_pattern(stab_layout_final) {
        stabilizer_plate_cutout_footprint($extra_data);
    }
    layout_pattern(standoff_layout_final) {
        plate_standoff_hole_footprint($extra_data);
    }
}

// difference() {
//     backplate_footprint(switch_layout_final, mcu_layout_final, trrs_layout_final, plate_layout_final);
//     grid_backplate_cutout(switch_layout_final, mcu_layout_final, trrs_layout_final, plate_layout_final, stab_layout_final, standoff_layout_final);
//     layout_pattern(standoff_layout_final) {
//         backplate_standoff_hole_footprint($extra_data);
//     }
// }
