/* Creates a flat 2D teardrop on the XY plane,
 * where no angle in the positive y direction is greater than 45º.
 * */
module teardrop2d(radius){
	// Find tangents on the circle at 45 degrees
	// Radius is triangle hypotenuse
	function tangent_point(circle_r, angle) = [
		circle_r * cos(angle),
		circle_r * sin(angle),
	];
	teardrop_point = [0,
				   tangent_point(radius, 45).y + tangent_point(radius, 45).x];
	circle(radius);
	polygon([
			tangent_point(radius, 45),
			tangent_point(radius, 135),
			teardrop_point
	]);
}

/*
 * Intended as a drop-in replacement for a basic cylinder().
 * */
module teardrop(length, radius, center=false){
	linear_extrude(height=length, center=center)
		teardrop2d(radius);
}
