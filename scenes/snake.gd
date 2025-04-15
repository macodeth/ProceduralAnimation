class_name Snake

extends Node2D

var velocity := Vector2(20, 0)
var speed: float = 5
# center points
# size from head to tail
var chain: Chain = null
var polygon_points: PackedVector2Array = []

func _ready() -> void:
	var points: PackedVector2Array = []
	var sizes: PackedFloat32Array = [30, 33, 31, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9]
	var distance_constraint := 40
	var angle_constraint := PI / 4
	points.resize(len(sizes))
	for i in range(len(sizes)):
		points[i] = Vector2(900 - i * distance_constraint, 400)
	chain = Chain.new(points, sizes, distance_constraint, angle_constraint, 0.5)

func _draw() -> void:
	var border_points := chain.get_border_points(velocity)
	polygon_points = CatmullRom.get_polygon_points(border_points, chain.tension)
	draw_colored_polygon(polygon_points, Color.DARK_OLIVE_GREEN)
	draw_polyline(polygon_points, Color.WHITE, 3)
	#for point in border_points:
		#draw_circle(point, 2, Color.RED)
	#for i in range(len(chain.points)):
		#draw_circle(chain.points[i], chain.sizes[i], Color.BLUE, false)

func _process(_delta: float) -> void:
	queue_redraw()

func _physics_process(_delta: float) -> void:
	var mouse_pos := get_local_mouse_position()
	if mouse_pos.distance_to(chain.points[0]) < 50:
		return
	var direction := chain.points[0].direction_to(mouse_pos)
	var angle := clampf(velocity.angle_to(direction), -PI / 8, PI / 8)
	velocity = velocity.rotated(angle).normalized() * speed
	chain.resolve(chain.points[0] + velocity)
