include <parameters.scad>
include <param_processing.scad>

// TODO angle portion of top wire guide that goes past switch, so that the
// switch pin makes contact on an angle with the wire strands, rather than
// passing fully through. Make the angle customisable.
// TODO convert bottom channel into teardrop shape, to reduce issues with
// overhang printing. (parameterisable?)
// TODO Make 5 pin optional

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

module switch_socket_cutout(borders=[1,1,1,1], rotate_column=false) {
    if (switch_type == "mx") {
        if (use_folded_contact) {
            mx_improved_socket_cutout(borders, rotate_column);
        } else {
            mx_socket_cutout(borders, rotate_column);
        }
    } else if (switch_type == "choc") {
        choc_socket_cutout(borders, rotate_column);
    } else {
        assert(false, "switch_type is invalid");
    }
}

module mx_improved_socket_cutout(borders=[1,1,1,1], rotate_column=false) {
    render() translate([h_unit/2,-v_unit/2,0]) rotate([0,0,switch_rotation])
        intersection() {
            union() {
                // Central pin
                translate([0,0,pcb_thickness/2-socket_depth])
                    cylinder(h=pcb_thickness+1,r=2.1);
                // Side pins
                if (five_pin_switch){
                    for (x = [-4,4]) {
                        translate([x*grid,0,pcb_thickness/2-socket_depth])
                            cylinder(h=pcb_thickness+1,r=1.05);
                    }
                }
                // Top switch pin
                translate([2*grid,4*grid,pcb_thickness/2-socket_depth])
                    cylinder(h=pcb_thickness+1,r=1);
                // Bottom switch pin
                translate([-3*grid,2*grid,-(pcb_thickness+1)/2]) {
                    translate([-.625,-0.75,0]) cube([1.25,1.5,pcb_thickness+1]);
                }
                // Diode cathode cutout
                translate([3*grid,-4*grid,0])
                    cylinder(h=pcb_thickness+1,r=.7,center=true);

                // Wire Channels
                // Row wire
                translate([0,4*grid,pcb_thickness/2-wire_diameter/3]) rotate([0,90,0])
                    cylinder(h=row_cutout_length,d=wire_diameter,center=true);
                // Column wire
                translate([3*grid,-4*grid,-(pcb_thickness/2-wire_diameter/3)]) 
                    rotate([90,0,rotate_column?90:0])
                        translate([0,0,-4*grid])
                        cylinder(h=col_cutout_length,d=wire_diameter,center=true);

                // Diode Channel
                translate([-3*grid,-1*grid-.25,pcb_thickness/2])
                    cube([1,6*grid+.5,2],center=true);
                translate([0,-4*grid,pcb_thickness/2])
                    cube([6*grid,1,2],center=true);
                translate([-1*grid-.5,-4*grid,pcb_thickness/2])
                    cube([4*grid,2,3],center=true);
                translate([-0.5*grid,2*grid+0.25,pcb_thickness/2])
                    cube([5*grid,1,2],center=true);
            }

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
}


module mx_socket_cutout(borders=[1,1,1,1], rotate_column=false) {
    render() translate([h_unit/2,-v_unit/2,0]) rotate([0,0,switch_rotation])
        intersection() {
            union() {
                // Central pin
                translate([0,0,pcb_thickness/2-socket_depth])
                    cylinder(h=pcb_thickness+1,r=2.1);
                // Side pins
                if (five_pin_switch){
                    for (x = [-4,4]) {
                        translate([x*grid,0,pcb_thickness/2-socket_depth])
                            cylinder(h=pcb_thickness+1,r=1.05);
                    }
                }
                // Top switch pin
                translate([2*grid,4*grid,pcb_thickness/2-socket_depth])
                    cylinder(h=pcb_thickness+1,r=1);
                // Bottom switch pin
                translate([-3*grid,2*grid,(pcb_thickness+1)/2])
                    rotate([180+diode_pin_angle,0,0])
                        cylinder(h=pcb_thickness+1,r=.7);
                // Diode cathode cutout
                translate([3*grid,-4*grid,0])
                    cylinder(h=pcb_thickness+1,r=.7,center=true);

                // Wire Channels
                // Row wire
                translate([0,4*grid,pcb_thickness/2-wire_diameter/3]) rotate([0,90,0])
                    cylinder(h=row_cutout_length,d=wire_diameter,center=true);
                // Column wire
                translate([3*grid,-4*grid,-(pcb_thickness/2-wire_diameter/3)]) 
                    rotate([90,0,rotate_column?90:0])
                        translate([0,0,-4*grid])
                        cylinder(h=col_cutout_length,d=wire_diameter,center=true);

                // Diode Channel
                translate([-3*grid,-1*grid-.25,pcb_thickness/2])
                    cube([1,6*grid+.5,2],center=true);
                translate([0,-4*grid,pcb_thickness/2])
                    cube([6*grid,1,2],center=true);
                translate([-1*grid-.5,-4*grid,pcb_thickness/2])
                    cube([4*grid,2,3],center=true);
            }

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
}

module choc_socket_cutout(borders=[1,1,1,1], rotate_column=false) {
    render() translate([h_unit/2,-v_unit/2,0]) rotate([0,0,switch_rotation])
        intersection() {
            union() {
                // Central pin
                translate([0,0,pcb_thickness/2-socket_depth])
                    cylinder(h=pcb_thickness+1,d=3.5);
                // Side pins
                if (five_pin_switch){
                    for (x = [-5.5,5.5]) {
                        translate([x,0,pcb_thickness/2-socket_depth])
                            cylinder(h=pcb_thickness+1,r=1.05);
                    }
                }
                // Top switch pin
                translate([0,5.9,pcb_thickness/2-socket_depth])
                    cylinder(h=pcb_thickness+1,r=1);
                // Bottom switch pin
                translate([5,3.8,(pcb_thickness+1)/2])
                    rotate([180+diode_pin_angle,0,0])
                        cylinder(h=pcb_thickness+1,r=.7);
                // Diode cathode cutout
                translate([-3.125,-3.8,0])
                    cylinder(h=pcb_thickness+1,r=.7,center=true);

                // Wire Channels
                // Row wire
                translate([0,5.9,pcb_thickness/2-wire_diameter/3]) rotate([0,90,0])
                    cylinder(h=row_cutout_length,d=wire_diameter,center=true);
                // Column wire
                translate([-3.125,-3.8,-(pcb_thickness/2-wire_diameter/3)]) 
                    rotate([90,0,rotate_column?90:0])
                        cylinder(h=col_cutout_length,d=wire_diameter,center=true);

                // Diode Channel
                translate([-3.125,0,pcb_thickness/2])
                    cube([1,7.6,2],center=true);
                translate([.75,3.8,pcb_thickness/2])
                    cube([8.5,1,2],center=true);
                translate([-3.125,1.8,pcb_thickness/2])
                    cube([2,5,3.5],center=true);
            }

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
}

module switch_plate_footprint(borders=[1,1,1,1]) {
    translate([h_unit/2,-v_unit/2,0])
        border_footprint(
            [socket_size,socket_size], 
            borders, 
            h_border_width, 
            v_border_width
        );
}

module switch_plate_footprint_trim(borders=[1,1,1,1], trim=undef) {
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
        switch_plate_footprint(borders);
}

module switch_plate_cutout(thickness=plate_thickness) {
    linear_extrude(thickness+1, center=true)
        switch_plate_cutout_footprint();
}

switch_socket();
