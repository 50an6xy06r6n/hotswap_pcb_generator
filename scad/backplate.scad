include <parameters.scad>
include <param_processing.scad>

use <switch.scad>
use <mcu.scad>
use <trrs.scad>
use <stabilizer.scad>
use <standoff.scad>
use <plate.scad>
use <case.scad>

// 2-D outline of the backplate
module backplate_footprint(switch_layout, mcu_layout, trrs_layout, plate_layout, stab_layout) {
    // TODO: move these calculations somewhere shared
    case_height = total_thickness - backplate_case_flange;

    // Additional wall thickness introduced by draft angle
    bottom_offset = (
        tan(case_wall_draft_angle) *
        (case_height-case_base_height) // Height of the drafted part of the wall
    );

    offset(bottom_offset)
        plate_footprint(
            switch_layout,
            mcu_layout,
            trrs_layout,
            plate_layout,
            stab_layout
        );
}

// Creates the external geometry of the backplate. (i.e. handles tenting logic)
module backplate_base(switch_layout, mcu_layout, trrs_layout, plate_layout, stab_layout, thickness=plate_thickness) {
    difference() {
        // Create an extra-chonky version of the backplate that we can chop down to size
        translate([0,0,-500])
        linear_extrude(thickness+1000, center=true, convexity=10)
            backplate_footprint(
                switch_layout,
                mcu_layout,
                trrs_layout,
                plate_layout,
                stab_layout
            );

        // Create a large subtractive block that cuts the tent angle into the backplate base
        translate([tent_point[0]-plate_margin,plate_margin-tent_point[1],-thickness/2])
        rotate([-tent_angle_x, tent_angle_y,0])
        translate([-1000,-1000,-1000])
            cube([2000,2000,1000]);
    }
}

// Generates the final backplate by adding features to the base
module backplate(switch_layout, mcu_layout, trrs_layout, plate_layout, stab_layout, standoff_layout) {
    module local_plate_profile() {
        plate_footprint(
            switch_layout,
            mcu_layout,
            trrs_layout,
            plate_layout,
            stab_layout
        );
    }

    difference() {
        union() {
            if (case_type == "sandwich") {
                // Just a basic base
                backplate_base(
                    switch_layout,
                    mcu_layout,
                    trrs_layout,
                    plate_layout,
                    stab_layout,
                    backplate_thickness
                );
            } else if (case_type == "plate_case") {
                // Adds an indexing feature that seats the backplate into the back of the case
                linear_extrude(backplate_thickness, center=true, convexity=10)
                union() {
                    // Basic perimeter around inside of case
                    difference() {
                        offset(-case_wall_thickness-case_fit_tolerance)
                            local_plate_profile();
                        
                        if (!is_undef(backplate_lip_width)) {
                            offset(-case_wall_thickness-case_fit_tolerance - backplate_lip_width)
                                local_plate_profile();
                        }
                    }

                    // Platforms to seat against standoffs
                    if (!is_undef(backplate_lip_width)) {
                        intersection() {
                            layout_pattern(standoff_layout) {
                                standoff_attachment = $extra_data[1];

                                if (standoff_attachment == "backplate") {
                                    translate([h_unit/2,-v_unit/2,0])
                                        circle(d=standoff_diameter+backplate_lip_width);
                                }
                            }

                            // Don't let it stick out past the lip
                            offset(-case_wall_thickness-case_fit_tolerance)
                                local_plate_profile();
                        }
                    }
                }

                // Add the plate base (including any tenting)
                translate([0,0,(backplate_case_flange-backplate_thickness)/2])
                    backplate_base(
                        switch_layout,
                        mcu_layout,
                        trrs_layout,
                        plate_layout,
                        stab_layout,
                        backplate_thickness
                    );
            }

            // Add undrilled backplate standoffs
            layout_pattern(standoff_layout) {
                backplate_standoff($extra_data);
            }
        }

        // Cut holes for standoffs
        layout_pattern(standoff_layout) {
            backplate_standoff_hole($extra_data);
        }
    }
}

backplate(switch_layout_final, mcu_layout_final, trrs_layout_final, plate_layout_final, stab_layout_final, standoff_layout_final);
