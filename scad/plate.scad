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

module plate_footprint(switch_layout, mcu_layout, trrs_layout, plate_layout) {
    scale_factor = use_plate_layout_only 
        ? plate_precision * 100000
        : 1;
    
    offset(-plate_inner_fillet,$fn=360) 
    offset(delta=plate_inner_fillet) 
    offset(plate_outer_fillet,$fn=360) 
    scale(scale_factor) 
    offset(delta=(plate_margin-plate_outer_fillet)/scale_factor) 
    scale(1/scale_factor) 
    {
        if (use_plate_layout_only) {
            // Hull each group and then union separately
            union() for (group = plate_layout) {
                hull() {
                    layout_pattern(group) {
                        if ($extra_data == "switch") 
                            switch_plate_footprint($borders); 
                        else if ($extra_data == "mcu")
                            mcu_plate_footprint($borders);
                        else if ($extra_data == "trrs")
                            trrs_plate_footprint($borders);
                    }
                }
            }
        } else {
            hull() {
                layout_pattern(switch_layout) {
                    switch_plate_footprint($borders); 
                }
                layout_pattern([for(g=plate_layout) for(e=g) e]) {
                    if ($extra_data == "switch") 
                        switch_plate_footprint($borders); 
                    else if ($extra_data == "mcu")
                        mcu_plate_footprint($borders);
                    else if ($extra_data == "trrs")
                        trrs_plate_footprint($borders);
                }
                layout_pattern(mcu_layout) {
                    mcu_plate_footprint($borders);
                }
                layout_pattern(trrs_layout) {
                    trrs_plate_footprint($borders);
                }
            }
        }
    }
}

module plate_base(switch_layout, mcu_layout, trrs_layout, plate_layout, thickness=plate_thickness, offset=0) {
    linear_extrude(thickness, center=true, convexity=10)
        offset(offset) plate_footprint(switch_layout, mcu_layout, trrs_layout, plate_layout);
}

module plate(switch_layout, mcu_layout, trrs_layout, plate_layout, standoff_layout) {
    difference() {
        union() {
            plate_base(switch_layout, mcu_layout, trrs_layout, plate_layout, plate_thickness);
            layout_pattern(standoff_layout) {
                plate_standoff($extra_data);
            }
        }
        layout_pattern(switch_layout) {
            switch_plate_cutout();
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

plate(switch_layout_final, mcu_layout_final, trrs_layout_final, plate_layout_final, standoff_layout_final);
//plate_footprint(switch_layout_final, mcu_layout_final, trrs_layout_final, plate_layout_final);
