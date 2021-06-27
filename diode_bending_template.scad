include <parameters.scad>

module mx_diode_template() {
    difference() {
        cube([socket_size, socket_size, pcb_thickness], center=true);
            
        // Bottom switch pin
        translate([-3*grid,2*grid,0])
            translate([0,socket_size/2-0.001,0])
                cube([1,socket_size,pcb_thickness+1],center=true);
        // Diode cathode cutout
        translate([3*grid,-4*grid,0])
            translate([socket_size/2-0.001,0,0])
                cube([socket_size,1,pcb_thickness+1],center=true);

        // Diode Channel
        translate([-3*grid,-1*grid-.25,pcb_thickness/2])
            cube([1,6*grid+.5,2],center=true);
        translate([0,-4*grid,pcb_thickness/2])
            cube([6*grid,1,2],center=true);
        translate([-1*grid-.5,-4*grid,pcb_thickness/2])
            cube([4*grid,2,3],center=true);
    }
}

module choc_diode_template() {
    difference() {
        cube([socket_size, socket_size, pcb_thickness], center=true);
            
        // Bottom switch pin
        translate([5,3.8,0])
            translate([socket_size/2-0.001,0,0])
                cube([socket_size,1,pcb_thickness+1],center=true);
        // Diode cathode cutout
        translate([-3.125,-3.8,0])
            translate([0,-socket_size/2+0.001,0])
                cube([1,socket_size,pcb_thickness+1],center=true);

        // Diode Channel
        translate([-3.125,0,pcb_thickness/2])
            cube([1,7.6,2],center=true);
        translate([.75,3.8,pcb_thickness/2])
            cube([8.5,1,2],center=true);
        translate([-3.125,1.8,pcb_thickness/2])
            cube([2,5,3.5],center=true);
    }
}

if (switch_type == "mx") {
    mx_diode_template();
} else if (switch_type == "choc") {
    choc_diode_template();
} else {
    assert(false, "switch_type is invalid");
}