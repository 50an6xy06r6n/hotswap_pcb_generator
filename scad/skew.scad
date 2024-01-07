// Skews the child geometry.
// xy: Angle towards X along Y axis.
// xz: Angle towards X along Z axis.
// yx: Angle towards Y along X axis.
// yz: Angle towards Y along Z axis.
// zx: Angle towards Z along X axis.
// zy: Angle towards Z along Y axis.
module skew(xy = 0, xz = 0, yx = 0, yz = 0, zx = 0, zy = 0) {
	matrix = [
		[ 1, tan(xy), tan(xz), 0 ],
		[ tan(yx), 1, tan(yz), 0 ],
		[ tan(zx), tan(zy), 1, 0 ],
		[ 0, 0, 0, 1 ]
	];
	multmatrix(matrix)
	children();
}
