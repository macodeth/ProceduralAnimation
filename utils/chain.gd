class_name Chain

var points: PackedVector2Array = []
var sizes: PackedFloat32Array = []
var distance_constraint: float = 0
var angle_constraint: float = 0
var tension: float = 0.5

func _init(p: PackedVector2Array, 
	s: PackedFloat32Array, 
	d: float,
	a: float,
	t: float) -> void:
	points = p
	sizes = s
	distance_constraint = d
	angle_constraint = a
	tension = t

func get_border_points(velocity: Vector2) -> PackedVector2Array:
	var result: PackedVector2Array = []
	var direction := velocity.normalized() * sizes[0]
	result.append(points[0] + direction)
	result.append(points[0] + direction.rotated(PI / 6))
	result.append(points[0] + direction.rotated(PI / 3))
	var lst: PackedVector2Array = []
	for i in range(1, len(points)):
		var dir := points[i].direction_to(points[i - 1]) * sizes[i]
		result.append(points[i] + dir.rotated(PI / 2))
		if i == len(points) - 1:
			result.append(points[i] + dir.rotated(PI))
		lst.append(points[i] + dir.rotated(-PI / 2))
	
	
	for i in range(len(lst)):
		result.append(lst[len(lst) - 1 - i])
	
	result.append(points[0] + direction.rotated(-PI / 3))
	result.append(points[0] + direction.rotated(-PI / 6))
	
	return result

func test_polygon() -> bool:
	return true

func resolve(head: Vector2) -> void:
	points[0] = head
	for i in range(1, len(points)):
		var direction := points[i].direction_to(points[i - 1]) * distance_constraint
		points[i] = points[i - 1] - direction
