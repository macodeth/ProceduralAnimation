class_name Snake

extends Node2D

var tension: float = 0.5
var distance_constraint: float = 30
var angle_constraint: float = PI / 4
var acceleration := Vector2(0, 0)
var velocity := Vector2(1, 0)
# center points
var points: PackedVector2Array = []
# size from head to tail
var sizes: PackedFloat32Array = [30, 35, 31, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9]

func _ready() -> void:
	points.resize(len(sizes))
	for i in range(len(sizes)):
		points[i] = Vector2(900 - i * distance_constraint, 400)

func _draw() -> void:
	var border_points := get_border_points()
	var polygon_points := CatmullRom.get_polygon_points(border_points, tension)
	draw_colored_polygon(polygon_points, Color.BLUE)
	draw_polyline(polygon_points, Color.WHITE, 3)

func get_border_points() -> PackedVector2Array:
	var result: PackedVector2Array = []
	var direction := velocity.normalized() * sizes[0]
	result.append(points[0] + direction)
	result.append(points[0] + direction.rotated(PI / 6))
	result.append(points[0] + direction.rotated(PI / 2))
	var lst: PackedVector2Array = []
	for i in range(1, len(points)):
		var dir := (points[i - 1] - points[i]).normalized() * sizes[i]
		result.append(points[i] + dir.rotated(PI / 2))
		if i == len(points) - 1:
			result.append(points[i] + dir.rotated(PI))
		lst.append(points[i] + dir.rotated(-PI / 2))
	
	
	for i in range(len(lst)):
		result.append(lst[len(lst) - 1 - i])
	
	result.append(points[0] + direction.rotated(-PI / 2))
	result.append(points[0] + direction.rotated(-PI / 6))
	
	return result
