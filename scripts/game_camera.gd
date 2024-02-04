extends Camera2D

@onready var destroyer = $Destroyer
@onready var destoyer_shape = $Destroyer/CollisionShape2D

var player: Player = null
var viewport_size
var overlapping_areas


func _ready():
	viewport_size = get_viewport_rect().size
	global_position.x = viewport_size.x / 2
	
	limit_bottom = viewport_size.y
	limit_left = 0
	limit_right = viewport_size.x
	
	destroyer.position.y = limit_bottom
	
	# Setup destroyer shape
	var rect_shape = RectangleShape2D.new()
	rect_shape.set_size(Vector2(limit_right, 200))
	destoyer_shape.shape = rect_shape


func _process(delta):
	if player:
		var limit_distance = 420
		if limit_bottom > player.global_position.y + limit_distance:
			limit_bottom = player.global_position.y + limit_distance
		
		# Delete platform below camera
		overlapping_areas = destroyer.get_overlapping_areas()
		if overlapping_areas.size() > 0:
			for area in overlapping_areas:
				if area is Platform:
					area.queue_free()


func _physics_process(delta):
	if player:
		global_position.y = player.global_position.y


func setup_camera(_player: Player):
	if _player:
		player = _player
