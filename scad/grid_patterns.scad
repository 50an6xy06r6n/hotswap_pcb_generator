module grid_pattern(size, spacing, width=100, height=100) {
    hex_grid_pattern(size, spacing, width, height);
}

module hex_grid_pattern(hex_width, spacing, width, height) {
    radius = hex_width / sqrt(3);
    x_instances = ceil(width / (hex_width + spacing));
    y_instances = 2*ceil(height / ((hex_width+spacing)*sqrt(3))) - 1;
    module even_row() {
        x_even = floor(x_instances / 2) + 0.5;
        for (x=[-x_even:1:x_even]) {
            translate([x*(hex_width+spacing),0,0]) 
            rotate([0,0,90]) 
                circle(radius, $fn=6);
        }
    }
    module odd_row() {
        x_odd = floor((x_instances-1) / 2) + 1;
        for (x=[-x_odd:1:x_odd]) {
            translate([x*(hex_width+spacing),0,0]) 
            rotate([0,0,90]) 
                circle(radius, $fn=6);
        }
    }
    y_even = floor((y_instances+1) / 4) + 0.5;
    y_odd = floor((y_instances-1) / 4) + 1;
    intersection() {
        square([x_instances*(hex_width+spacing),(y_instances+1)/2*(hex_width+spacing)*sqrt(3)], center=true);
        union() {
            for (y=[-y_even:1:y_even]) {
                translate([0,y*(hex_width+spacing)*sqrt(3),0])
                even_row();
            }
            for (y=[-y_odd:1:y_odd]) {
                translate([0,y*(hex_width+spacing)*sqrt(3),0])
                odd_row();
            }
        }
    }
}

grid_pattern(10, 2);