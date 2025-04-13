class_name CatmullRom

static func get_polygon_points(points: PackedVector2Array, tension: float) -> PackedVector2Array:
	var curve_points := points.duplicate()
	curve_points.insert(0, curve_points[-1])
	curve_points.append(curve_points[1])
	curve_points.append(curve_points[2])
	var draw_points: PackedVector2Array = []
	for i in range(len(curve_points) - 3):
		var tmp := CatmullRom.get_spline_points(curve_points[i], curve_points[i + 1], curve_points[i + 2], curve_points[i + 3], tension)
		draw_points.append_array(tmp)
	return draw_points

## Generate all points needed to draw a spline from p1 to p2 (exclude p2)
static func get_spline_points(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, tension: float) -> PackedVector2Array:
	var knots := knot_sequence(p0, p1, p2, p3, tension)
	var t0 := knots[0]
	var t1 := knots[1]
	var t2 := knots[2]
	var t3 := knots[3]
	var m1 := (t2 - t1) * ((p1 - p0) / (t1 - t0) - (p2 - p0) / (t2 - t0) + (p2 - p1) / (t2 - t1))
	var m2 := (t2 - t1) * ((p2 - p1) / (t2 - t1) - (p3 - p1) / (t3 - t1) + (p3 - p2) / (t3 - t2))
	var a := 2 * p1 - 2 * p2 + m1 + m2
	var b := -3 * p1 + 3 * p2 - 2 * m1 - m2
	var c := m1
	var d := p1
	var t := 0.0
	var draw_points: PackedVector2Array = []
	while t < 1.0:
		draw_points.append(a * t * t * t + b * t * t + c * t + d)
		t += 0.1
	return draw_points

## generate 4 knot values based on tension, 
## tension = 0.5 -> centripetal catmull-rom
static func knot_sequence(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, tension: float) -> PackedFloat32Array:
	var result: PackedFloat32Array = []
	result.append(0)
	result.append(result[0] + pow(p0.distance_to(p1), tension))
	result.append(result[1] + pow(p1.distance_to(p2), tension))
	result.append(result[2] + pow(p2.distance_to(p3), tension))
	return result
