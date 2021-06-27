include <parameters.scad>

difference() {
    cube([socket_size, socket_size, thickness], center=true);
        
    translate([-3*grid,2*grid,0])
        translate([0,socket_size/2-0.001,0])
            cube([1,socket_size,thickness+1],center=true);
    translate([3*grid,-4*grid,0])
        translate([socket_size/2-0.001,0,0])
            cube([socket_size,1,thickness+1],center=true);

    // Diode Channel
    translate([-3*grid,-1*grid-.25,thickness/2])
        cube([1,6*grid+.5,2],center=true);
    translate([0,-4*grid,thickness/2])
        cube([6*grid,1,2],center=true);
    translate([-1*grid-.5,-4*grid,thickness/2])
        cube([4*grid,2,3],center=true);
}

