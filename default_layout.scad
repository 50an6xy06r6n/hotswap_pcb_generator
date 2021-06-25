/* [Layout Values] */
// Layout (Format is [[[x_location, y_location], [rotation, rotation_x, rotation_y]], [key_size, [top_border, bottom_border, left_border, right_border], rotate_column]])
layout = [
    [[[0,0.125]],[1,[0,1,0,2],false]],
    [[[0,1.125]],[1,[1,1,0,1],false]],
    [[[0,2.125]],[1,[1,1,0,1],false]],
    [[[0,3.125]],[1,[1,0,0,0],false]],
    [[[1,0]],[1,[0,1,0,0],false]],
    [[[1,1]]],
    [[[1,2]]],
    [[[1,3]],[1,[1,0,2,2],false]],
    [[[2,0.125]],[1,[0,1,2,2],false]],
    [[[2,1.125]]],
    [[[2,2.125]]],
    [[[2,3.125]],[1,[1,0,0,0],false]],
    [[[3,0]],[1,[0,1,0,0],false]],
    [[[3,1]]],
    [[[3,2]]],
    [[[3,3]],[1,[1,0,2,2],false]],
    [[[4,0.125]],[1,[0,1,2,0],false]],
    [[[4,1.125]]],
    [[[4,2.125]]],
    [[[4,3.125]],[1,[1,0,0,0],false]],
    [[[5,0.25]],[1,[0,1,2,0],false]],
    [[[5,1.25]]],
    [[[5,2.25]],[1,[1,6,2,0],false]],
    [[[6,1]],[1,[0,1,2,0],false]],
    [[[6,2]],[1,[1,0,2,0],false]],
    [[[4.875,4.625],[60,4.875,4.625]],[1.5,[6,1,0,0],true]],
    [[[4.875,5.625],[60,4.875,4.625]],[1.5,[1,0,0,0],true]],
];

// Standoff hole layout
hole_layout = [
    [[[0,1.625]]],
    [[[2.5,0]]],
    [[[2.5,3.125]]],
    [[[3,1.5]]],
    [[[6,1.5]]],
    [[[4.875,5.125],[60,4.875,4.625]],[1.5,[0,0,0,0],true]],
];

// Whether to flip the layout
invert_layout_flag = false;

// Whether the layout is staggered-row or staggered-column
layout_type = "column";  // [column, row]