include <parameters.scad>

// Stabilizer spacing for common key sizes, measured center-to-center
// Format is [key_size, left_offset, right_offset, switch_offset=0]
// Key size is measured in units, offsets are measured in mm from center

2u = [2, 5/8*unit, 5/8*unit];  // [11.938, 11.938], 1.25u total spacing
2_25u = [2.25, 5/8*unit, 5/8*unit];
2_5u = [2.5, 5/8*unit, 5/8*unit];
2_75u = [2.75, 5/8*unit, 5/8*unit];
3u = [3, 1*unit, 1*unit];  // [19.05, 19.05], 2u total spacing
6u = [6, 2.5*unit, 2.5*unit];  // [47.625, 47.625], 5u total spacing
6u_offset = [6, 3*unit, 2*unit, 0.5*unit];  // [57.15, 38.1], 5u total spacing
6_25u = [6.25, 2.625*unit, 2.625*unit];  // [49.8475, 49.8475], 5.25u total spacing
6_25u_offset = [6.25, 3.25*unit, 2*unit, 0.625*unit];  // [61.9125, 38.1], 5.25u total spacing
6_25u_narrow = [6.25, 40, 40];  // 80mm total spacing
7u = [7, 3*unit, 3*unit];  // [57.15, 57.15]

