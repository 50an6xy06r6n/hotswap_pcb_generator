include <parameters.scad>
include <param_processing.scad>

use <plate.scad>
use <switch.scad>
use <mcu.scad>
use <trrs.scad>
use <stabilizer.scad>
use <standoff.scad>

// Chamfer that preserves hard corners (doesn't work with external fillets)
module straight_chamfer(
    height,
    angle, // measured from horizontal
) {
    if (angle == 90) {
        // For straight sides, just do a linear extrude
        linear_extrude(height)
            children(0);
    } else {
        // roof() uses a 45 degree angle, so we can scale vertically to adjust the angle
        scale_factor = tan(angle) / tan(45);

        difference() {
            scale([1,1,scale_factor])
            roof("straight")
                children(0);
            translate([0,0,height])
                scale([1,1,scale_factor])
                roof("straight")
                    children(0);
        };
    }
}

// External profile of the case
module case_shell(height, switch_layout, mcu_layout, trrs_layout, plate_layout, stab_layout) {
    // Helper module for shared plate profile
    module local_plate_profile() {
        plate_footprint(switch_layout, mcu_layout, trrs_layout, plate_layout, stab_layout);
    }

    // Additional wall thickness introduced by draft angle
    bottom_offset = (
        tan(case_wall_draft_angle) *
        (height-case_base_height) // Height of the drafted part of the wall
    );

    // Height of the chamfer with no draft angle
    base_chamfer_height = tan(case_chamfer_angle)*case_chamfer_width;

    // Offset of chamfer-draft intersection from base footprint (accounting for draft angle)
    chamfer_offset = min(
        case_wall_draft_angle > 0 ? ( // Special-case the no draft angle case, since that divides by zero
            base_chamfer_height *
            tan(case_wall_draft_angle) / // Converts to the added width of the drafted body at the undrafted chamfer edge
            (1-tan(case_wall_draft_angle)*tan(case_chamfer_angle)) // Solve for X to find the intersection of the draft and chamfer
        ) : 0, // No offset if the walls are vertical
        (height - case_base_height) / tan(case_chamfer_angle) // In cases where the chamfer doesn't intersect the draft, the chamfer stops at the base
    );

    // Total height to the chamfer-draft intersection
    chamfer_height = min(
        case_wall_draft_angle > 0 ? // More special casing to avoid dividing by zero
            chamfer_offset/tan(case_wall_draft_angle) :
            base_chamfer_height,
        height - case_base_height // Chamfer height can't exceed total case height
    );

    // Height of the drafted part of the wall
    draft_height = height - chamfer_height - case_base_height;

    // Use the outline as defined by the plate layout
    if (use_plate_layout_only) {
        if (case_wall_draft_angle == 0 && case_chamfer_width == 0) {
            // If there are no angles then we can just do a simple linear extrude
            // (also the minkowski geometry becomes degenerate)
            linear_extrude(height, convexity=10)
                local_plate_profile();
        } else if (chamfer_corner_type == "rounded") {
            // Generate case chamfers that round out at the corners
            minkowski() {
                // Just extrude the straight-sided base (shrunken to account for the minkowski)
                linear_extrude(case_base_height, convexity=10)
                    offset(-case_chamfer_width)
                    local_plate_profile();

                // Stacked-cone side profile for both the chamfer and the draft angle
                // This gets "rolled" around the base profile to create slanted sides
                union() {
                    translate([0,0,draft_height])
                        // Chamfer cone
                        cylinder(
                            chamfer_height,
                            case_chamfer_width + chamfer_offset,
                            0
                        );
                        // Draft cone/cylinder
                        cylinder(
                            draft_height,
                            case_chamfer_width + bottom_offset,
                            case_chamfer_width + chamfer_offset
                        );
                }
            }
        } else {
            // Experimental setting to generate chamfers that intersect at straight lines or bevels
            // May break if combined with external fillets

            // Extra-experimental feature. The top of the drafted section seems to always line up with
            // the bottom of the chamfer section, but I'm not sure that will always work out.
            // I think it has to do with similarities between the straight skeleton algorithm used by
            // roof() and the algorithm used to create beveled (chamfered) offset profiles.
            beveled_corners = chamfer_corner_type == "beveled";

            // Top chamfer section
            translate([0,0,case_base_height+draft_height])
            straight_chamfer(chamfer_height, case_chamfer_angle) {
                offset(delta=chamfer_offset, chamfer=beveled_corners)
                local_plate_profile();
            };

            // Drafted section
            translate([0,0,case_base_height])
            straight_chamfer(draft_height, 90-case_wall_draft_angle) {
                offset(delta=bottom_offset, chamfer=beveled_corners)
                local_plate_profile();
            };

            // Extrude the straight-sided base
            linear_extrude(case_base_height, convexity=10)
                offset(delta=bottom_offset, chamfer=beveled_corners)
                local_plate_profile();
        }
    } else {
        // Just hull everything to get a basic shape (eliminates any concavity in the profile)
        // This could probably also be done via the minkowski method, but this is more computationally efficient
        eps = 0.001;
        rounded_corners = chamfer_corner_type == "rounded";
        beveled_corners = chamfer_corner_type == "beveled";

        hull() {
            // top plate surface
            translate([0,0,height-eps])
            linear_extrude(eps)
            offset(-case_chamfer_width)
                local_plate_profile();

            // Chamfer-draft intersection
            translate([0,0,height-chamfer_height-eps])
            linear_extrude(eps)
            offset(
                r=rounded_corners ? chamfer_offset : undef,
                delta=rounded_corners ? undef : chamfer_offset,
                chamfer=beveled_corners
            )
                local_plate_profile();

            // Bottom section
            translate([0,0,-eps])
            linear_extrude(case_base_height+eps)
            offset(
                r=rounded_corners ? bottom_offset : undef,
                delta=rounded_corners ? undef : bottom_offset,
                chamfer=beveled_corners
            )
                local_plate_profile();

        }
    }
}

module case(switch_layout, mcu_layout, trrs_layout, plate_layout, stab_layout, standoff_layout) {
    // Helper module for shared plate profile
    module local_plate_profile() {
        plate_footprint(switch_layout, mcu_layout, trrs_layout, plate_layout, stab_layout);
    }

    height = total_thickness - backplate_case_flange;
    intersection() {
        // Trim off any components that extend past the case (e.g. standoffs)
        translate([0,0,-height+plate_thickness/2])
            case_shell(height, switch_layout, mcu_layout, trrs_layout, plate_layout, stab_layout);
        difference() {
            union() {
                // Hollow out inside of case
                translate([0,0,-height+plate_thickness/2]) 
                difference() {
                    case_shell(height, switch_layout, mcu_layout, trrs_layout, plate_layout, stab_layout);
                    translate([0,0,-1])
                    linear_extrude(height-plate_thickness+1, convexity=10)
                        offset(-case_wall_thickness)
                        local_plate_profile();
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
            layout_pattern(stab_layout) {
                stabilizer_plate_cutout($extra_data);
            }

            // Drill all standoff holes
            layout_pattern(standoff_layout) {
                case_standoff_hole($extra_data);
                plate_standoff_hole($extra_data);
                translate([0,0,plate_thickness/2-pcb_plate_spacing-pcb_thickness-pcb_backplate_spacing-backplate_thickness/2-0.5])
                    backplate_standoff_hole($extra_data);
            }

            // Additional user-defined cutouts
            linear_extrude(plate_thickness+1, center=true)
            intersection() {
                // Make sure it doesn't cut into the case walls by intersecting with the inner plate profile
                offset(-case_wall_thickness)
                    local_plate_profile();
                additional_plate_cutouts(); 
            }
        }
    }
}

case(
    switch_layout_final,
    mcu_layout_final,
    trrs_layout_final,
    plate_layout_final,
    stab_layout_final,
    standoff_layout_final
);

// module plate_profile () {
//     plate_footprint(
//         switch_layout_final,
//         mcu_layout_final,
//         trrs_layout_final,
//         plate_layout_final,
//         stab_layout_final
//     );
// }

// difference() {
//     roof("straight")
//         plate_profile();
//     translate([0,0,4])
//         linear_extrude(100)
//         offset(4)
//         plate_profile();
// };

