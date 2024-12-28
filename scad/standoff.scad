include <parameters.scad>
include <param_processing.scad>

module standoff_footprint() {
    translate([h_unit/2,-v_unit/2,0]) 
    circle(d=standoff_diameter);
}

module standoff_fillet(standoff_diameter, fillet_radius) {
    difference() {
        // Start with a basic conical chamfer
        cylinder(
            h=fillet_radius,
            d1=standoff_diameter,
            d2=standoff_diameter+2*fillet_radius,
            center=true
        );

        // Subtract a donut to create the fillet profile
        translate([0,0,-fillet_radius/2])
        minkowski() {
            // Ring through the center of the donut
            difference() {
                cylinder(h=eps,d=standoff_diameter+2*fillet_radius+2*eps);
                cylinder(h=eps,d=standoff_diameter+2*fillet_radius);
            }
            sphere(r=fillet_radius);
        }
    }
}

module standoff(height, attachment_thickness, solid=false, fillet=default_standoff_fillet) {
    // Default values work kinda weird
    fillet = fillet == undef ? default_standoff_fillet : fillet;

    difference() {
        translate([h_unit/2,-v_unit/2,0])
            union() {
                cylinder(h=height,d=standoff_diameter,center=true);

                // Fillet at the base of the standoff to improve strength
                translate([0,0,(height-fillet)/2-attachment_thickness])
                standoff_fillet(standoff_diameter, fillet);
            }
        if (!solid) 
            standoff_pilot_hole(height+1);
    }
}

module standoff_pilot_hole(height) {
    translate([h_unit/2,-v_unit/2,0]) 
        cylinder(h=height,d=standoff_pilot_hole_diameter,center=true);
}

module standoff_clearance_hole_footprint() {
    translate([h_unit/2,-v_unit/2,0]) 
    circle(d=standoff_clearance_hole_diameter);
}

module standoff_clearance_hole(depth) {
    translate([h_unit/2,-v_unit/2,0]) 
        cylinder(h=depth,d=standoff_clearance_hole_diameter,center=true);
}

module standoff_through_hole(depth) {
    translate([h_unit/2,-v_unit/2,0]) 
        cylinder(h=depth,d=standoff_diameter+1,center=true);
}

module standoff_counterbore(z_offset) {
    mirror_vec = z_offset > 0
        ? [0,0,0]
        : [0,0,1];
    mirror(mirror_vec)
    translate([h_unit/2,-v_unit/2,abs(z_offset)]) 
        cylinder(h=1000,d=standoff_counterbore_diameter);
}

module pcb_standoff(standoff_config, solid=false) {
    standoff_integration = standoff_config[0];
    standoff_attachment = standoff_config[1];
    standoff_fillet = standoff_config[2];
    
    if (standoff_integration == "pcb") {
        assert(
            standoff_attachment == "plate" || standoff_attachment == "backplate",
            str("standoff_config ", standoff_config," is invalid")
        );

        height = 
            standoff_attachment == "plate"
                ? pcb_plate_spacing + pcb_thickness/2 - plate_thickness - fit_tolerance
            : standoff_attachment == "backplate"
                ? pcb_backplate_spacing + pcb_thickness/2 - fit_tolerance
            : undef;
        standoff_offset =
            standoff_attachment == "plate" ? height/2
            : standoff_attachment == "backplate" ? -height/2
            : undef;
        
        translate([0,0,standoff_offset])
        mirror([0,0,standoff_attachment == "plate" ? 1 : 0]) 
            standoff(
                height,
                standoff_attachment == "plate" ? pcb_thickness/2 - 2 : pcb_thickness/2,
                solid,
                standoff_fillet
            );
    }
}

module standoff_config_footprint(target, standoff_config) {
    assert(
        target == "plate" || target == "backplate",
        str("Invalid standoff footprint target ", target, ".")
    );

    standoff_integration = standoff_config[0];
    standoff_attachment = standoff_config[1];
    if (
        standoff_integration == "separate"
        || standoff_integration == target
        || standoff_attachment == target
    ) {
        standoff_footprint();
    }
}

module plate_standoff_footprint(standoff_config) {
    standoff_config_footprint("plate", standoff_config); 
}

module plate_standoff(standoff_config, solid=false) {
    standoff_integration = standoff_config[0];
    standoff_attachment = standoff_config[1];
    standoff_fillet = standoff_config[2];
    
    if (standoff_integration == "plate") {
        assert(
            standoff_attachment == "pcb" || standoff_attachment == "backplate",
            str("standoff_config ", standoff_config," is invalid")
        );

        height =
            standoff_attachment == "pcb"
                ? pcb_plate_spacing - min(border_z_offset * 2, 0) - fit_tolerance
            : standoff_attachment == "backplate"
                ? pcb_plate_spacing + pcb_thickness + pcb_backplate_spacing - fit_tolerance
            : undef;
        standoff_offset = -(height-plate_thickness)/2;
        
        translate([0,0,standoff_offset]) 
            standoff(height, plate_thickness, solid, standoff_fillet);
    }
}

module backplate_standoff_footprint(standoff_config) {
    standoff_config_footprint("backplate", standoff_config); 
}

module backplate_standoff(standoff_config, solid=false) {
    standoff_integration = standoff_config[0];
    standoff_attachment = standoff_config[1];
    standoff_fillet = standoff_config[2];
    
    if (standoff_integration == "backplate") {
        assert(
            standoff_attachment == "pcb" || standoff_attachment == "plate",
            str("standoff_config ", standoff_config," is invalid")
        );

        height =
            standoff_attachment == "pcb"
                ? pcb_backplate_spacing + max(border_z_offset * 2, 0) - fit_tolerance
            : standoff_attachment == "plate"
                ? pcb_backplate_spacing + pcb_thickness + pcb_plate_spacing - plate_thickness - fit_tolerance
            : undef;
        standoff_offset = height/2 + backplate_thickness/2;
        
        translate([0,0,standoff_offset])
        mirror([0,0,1])
            standoff(height, 0, solid, standoff_fillet);
    }
}

module pcb_standoff_hole(standoff_config) {
    standoff_integration = standoff_config[0];
    standoff_attachment = standoff_config[1];

    if (
        (standoff_integration == "plate" && standoff_attachment == "pcb") || 
        (standoff_integration == "backplate" && standoff_attachment == "pcb") || 
        (standoff_integration == "separate" && standoff_attachment == "plate") ||
        (standoff_integration == "separate" && standoff_attachment == "backplate")
    ) {
        // Standoff screwed into PCB
        standoff_clearance_hole(pcb_thickness+1);
    } else if (
        (standoff_integration == "plate" && standoff_attachment == "backplate") || 
        (standoff_integration == "backplate" && standoff_attachment == "plate") || 
        (standoff_integration == "separate" && standoff_attachment == "plate_backplate")
    ) {
        // Standoff goes through PCB
        standoff_through_hole(pcb_thickness+1);
    }
}

module standoff_hole_footprint(target, standoff_config) {
    assert(
        target == "plate" || target == "backplate",
        str("Invalid standoff hole footprint target ", target, ".")
    );

    standoff_integration = standoff_config[0];
    standoff_attachment = standoff_config[1];
    if (
        standoff_integration == "separate"
        || standoff_attachment == target
    ) {
        standoff_clearance_hole_footprint();
    }
}

module plate_standoff_hole_footprint(standoff_config) {
    standoff_hole_footprint("plate", standoff_config);
}

module plate_standoff_hole(standoff_config) {
    standoff_integration = standoff_config[0];
    standoff_attachment = standoff_config[1];
       
    if (
        (standoff_integration == "pcb" && standoff_attachment == "plate") || 
        (standoff_integration == "backplate" && standoff_attachment == "plate") || 
        (standoff_integration == "separate" && standoff_attachment == "plate") ||
        (standoff_integration == "separate" && standoff_attachment == "plate_backplate")
    ) {
        // Standoff screwed into plate
        standoff_clearance_hole(pcb_thickness+1);
    } 
}

module backplate_standoff_hole_footprint(standoff_config) {
    standoff_hole_footprint("backplate", standoff_config);
}

module backplate_standoff_hole(standoff_config) {
    standoff_integration = standoff_config[0];
    standoff_attachment = standoff_config[1];
       
    if (
        (standoff_integration == "pcb" && standoff_attachment == "backplate") || 
        (standoff_integration == "plate" && standoff_attachment == "backplate") || 
        (standoff_integration == "separate" && standoff_attachment == "backplate") ||
        (standoff_integration == "separate" && standoff_attachment == "plate_backplate")
    ) {
        // Standoff screwed into backplate
        standoff_clearance_hole(backplate_thickness+1);
        standoff_counterbore(-backplate_thickness/2);
    } 
} 

module case_standoff_hole(standoff_config) {
    standoff_integration = standoff_config[0];
    standoff_attachment = standoff_config[1];
       
    if (
        (standoff_integration == "plate" && standoff_attachment == "pcb") || 
        (standoff_integration == "plate" && standoff_attachment == "backplate") 
    ) {
        height = pcb_plate_spacing + pcb_thickness + pcb_backplate_spacing + backplate_thickness;
        translate([0,0,-(height+plate_thickness)/2])
            standoff_pilot_hole(height);
    } 
}

standoff(10);
