include <parameters.scad>
include <param_processing.scad>
use <utils.scad>

module switch_socket(borders=[1,1,1,1], rotate_column=false) {
    difference() {
        switch_socket_base(borders);
        switch_socket_cutout(borders, rotate_column);
    }
}

module switch_socket_base(borders=[1,1,1,1]) {
    translate([h_unit/2,-v_unit/2,0]) union() {
        cube([socket_size, socket_size, pcb_thickness], center=true);
        translate([0,0,border_z_offset * 1])
            border(
                [socket_size,socket_size], 
                borders, 
                pcb_thickness-2, 
                h_border_width, 
                v_border_width
            );
    }
}

module switch_socket_cutout(borders=[1,1,1,1], rotate_column=false, trim=undef) {
    if (switch_type == "mx"){
        mx_socket_cutout(borders, rotate_column);
    } else if (switch_type == "choc"){
        choc_socket_cutout(borders, rotate_column);
    } else {
        assert(false, "switch_type is invalid");
    }
    translate([0,0,-pcb_thickness-eps])
    linear_extrude(pcb_thickness+2*eps) 
        switch_footprint_trim(borders, trim);
}

module mx_socket_cutout(borders=[1,1,1,1], rotate_column=false){
    switch_socket_cutout_logic(
            top_pin_xy = [2*mx_schematic_unit,4*mx_schematic_unit],
            bottom_pin_xy = [-3*mx_schematic_unit,2*mx_schematic_unit],
            side_pin_x = 4*mx_schematic_unit,
            diode_cutout_xy = [3*mx_schematic_unit,-4*mx_schematic_unit],
            col_channel_xy = [3*mx_schematic_unit,-4*mx_schematic_unit],
            row_channel_y = 4*mx_schematic_unit,
            central_pin_r = 2.1,
            borders=borders,
            rotate_column=rotate_column
            );
}

module choc_socket_cutout(borders=[1,1,1,1], rotate_column=false) {
    switch_socket_cutout_logic(
            top_pin_xy = [0,5.9],
            bottom_pin_xy = [5,3.8],
            side_pin_x = 5.5,
            diode_cutout_xy = [-3.125, -3.8],
            col_channel_xy = [-3.125,-3.8],
            row_channel_y = 5.9,
            central_pin_r = 1.75,
            borders=borders,
            rotate_column=rotate_column
            );
}

module switch_socket_cutout_logic(
        // Pin positions within socket cutout
        top_pin_xy,
        bottom_pin_xy,
        // Side pin is +-
        side_pin_x,
        diode_cutout_xy,
        col_channel_xy,
        row_channel_y,
        central_pin_r,
        borders=[1,1,1,1],
        rotate_column=false
        ) {
    top_pin_cutout_r = 1;

    render() translate([h_unit/2,-v_unit/2,0]) rotate([0,0,switch_rotation])
        intersection() {
            union() {
                // Top switch pin
                translate([top_pin_xy.x, top_pin_xy.y, pcb_thickness/2-socket_depth])
                    cylinder(h=pcb_thickness+1,r=top_pin_cutout_r);

                // Central pin
                translate([0,0,pcb_thickness/2-socket_depth])
                    cylinder(h=pcb_thickness+1,r=central_pin_r);

                // Side pins
                if (five_pin_switch){
                    for (x = [-side_pin_x, side_pin_x]) {
                        translate([x,0,pcb_thickness/2-socket_depth])
                            cylinder(h=pcb_thickness+1,r=1.05);
                    }
                }

                // Bottom switch pin
                if (use_folded_contact){
                    // Bottom switch pin
                    translate([-3*mx_schematic_unit,2*mx_schematic_unit,-(pcb_thickness+1)/2]) {
                        translate([-.625,-0.75,0]) cube([1.25,1.5,pcb_thickness+1]);
                    }
                    // Extra bit of diode channel for folded diode
                    translate([-0.5*mx_schematic_unit,2*mx_schematic_unit+0.25,pcb_thickness/2])
                        cube([5*mx_schematic_unit,1,2],center=true);
                } else {
                    translate([bottom_pin_xy.x, bottom_pin_xy.y,(pcb_thickness+1)/2])
                        rotate([180+diode_pin_angle,0,0])
                        cylinder(h=pcb_thickness+1,r=.7);
                }

                // Diode Channel
                if (switch_type == "choc"){
                    translate([-3.125,0,pcb_thickness/2])
                        cube([1,7.6,2],center=true);
                    translate([.75,3.8,pcb_thickness/2])
                        cube([8.5,1,2],center=true);
                    translate([-3.125,1.8,pcb_thickness/2])
                        cube([2,5,3.5],center=true);
                } else if (switch_type == "mx") {
                    translate([-3*mx_schematic_unit,-1*mx_schematic_unit-.25,pcb_thickness/2])
                        cube([1,6*mx_schematic_unit+.5,2],center=true);
                    translate([0,-4*mx_schematic_unit,pcb_thickness/2])
                        cube([6*mx_schematic_unit,1,2],center=true);
                    translate([-1*mx_schematic_unit-.5,-4*mx_schematic_unit,pcb_thickness/2])
                        cube([4*mx_schematic_unit,2,3],center=true);
                } else {
                    assert(false, "switch_type is invalid");
                }

                // Diode cathode cutout
                translate(diode_cutout_xy)
                    cylinder(h=pcb_thickness+1,r=.7,center=true);

                // Row wire
                kink_angle = row_wire_contact_angle;
                kink_smoothing_width = 2.8;
                kink_width = top_pin_cutout_r*3;
                kink_deviation = tan(kink_angle)*kink_width/2;
                difference(){
                    translate([0,
                            row_channel_y-kink_deviation,
                            pcb_thickness/2-wire_diameter/3
                    ])
                        rotate([upsidedown_switch?-90:90,0,90])
                        linear_extrude(row_cutout_length, center=true) teardrop2d(wire_diameter/2);
                    if (kink_angle != 0) {
                        // Block out some of the channel
                        translate([
                                top_pin_xy.x -
                                kink_smoothing_width/2 - kink_width/2,
                                top_pin_xy.y])
                            cube([
                                    kink_width*2 + kink_smoothing_width,
                                    10,10], center=true);
                    }
                }

                // Kink the channel across the switch pin for better contact.
                if (kink_angle != 0) {
                    // Left is diagonal channel back to main channel, so the rest of
                    // the channel to the left lines up with other keys.
                    // Other one is the diagonal channel crossing switch pin.
                    for (is_left = [1,0]){
                        x_correction = is_left * (-kink_width - kink_smoothing_width);
                        // 1 if left, -1 otherwise; reversed for row layout.
                        skew_dir = 2*is_left - 1;
                        translate([top_pin_xy.x + x_correction,
                                top_pin_xy.y,
                                pcb_thickness/2-wire_diameter/3
                        ])
                            skew(yx=skew_dir * kink_angle)
                            rotate([upsidedown_switch?-90:90,0,90])
                            linear_extrude(kink_width/1, center=true) teardrop2d(wire_diameter/2);
                    }

                    // flat bit of channel to smooth kink return.
                    translate([top_pin_xy.x - kink_smoothing_width/2 -
                            kink_width/2,
                            top_pin_xy.y + kink_deviation,
                            pcb_thickness/2-wire_diameter/3
                    ])
                        rotate([upsidedown_switch?-90:90,0,90])
                        linear_extrude(kink_smoothing_width, center=true) teardrop2d(wire_diameter/2);
                }

                // Column wire
                translate([
                        col_channel_xy.x,
                        col_channel_xy.y,
                        -(pcb_thickness/2-wire_diameter/3)
                ]) 
                    rotate([upsidedown_switch?-90:90,0,rotate_column?90:0])
                    translate([0,0,-4*mx_schematic_unit])
                    linear_extrude(col_cutout_length, center=true) teardrop2d(wire_diameter/2);

            }
            socket_cleanup_cube(borders);
        }
}


module socket_cleanup_cube(borders){
    translate([
            h_border_width/2 * (borders[3] - borders[2]),
            v_border_width/2 * (borders[0] - borders[1]),
            -1
    ]) {
        cube([
                socket_size+h_border_width*(borders[2]+borders[3])+0.02,
                socket_size+v_border_width*(borders[0]+borders[1])+0.02,
                2*pcb_thickness
        ], center=true);
    }
}

module switch_footprint(borders=[1,1,1,1]) {
    translate([h_unit/2,-v_unit/2,0])
        border_footprint(
            [socket_size,socket_size], 
            borders, 
            h_border_width, 
            v_border_width
        );
}

module switch_footprint_trim(borders=[1,1,1,1], trim=undef) {
    if (trim)
    translate([h_unit/2,-v_unit/2,0])
        border_trim(
            [socket_size,socket_size], 
            borders,
            trim,
            h_border_width, 
            v_border_width
        );
}

module switch_plate_cutout_footprint() {
    translate([h_unit/2,-v_unit/2,0]) {
        square([plate_cutout_size, plate_cutout_size],center=true);
    }
}

module switch_plate_base(borders=[1,1,1,1], thickness=plate_thickness) {
    linear_extrude(thickness, center=true)
        switch_footprint(borders);
}

module switch_plate_cutout(thickness=plate_thickness) {
    linear_extrude(thickness+2*total_thickness, center=true)
        switch_plate_cutout_footprint();
}

switch_socket();
