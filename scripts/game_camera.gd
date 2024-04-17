extends Camera2D

@onready var destroyer = $Destroyer
@onready var destoyer_shape = $Destroyer/CollisionShape2D

var player: Player = null
var viewport_size: Vector2
var overlapping_areas


func _ready():
	#Move camera when created to prevent jitter at game start
	if player:
		global_position.y = player.global_position.y
	
	viewport_size = get_viewport_rect().size
	global_position.x = viewport_size.x / 2
	
	limit_bottom = int(viewport_size.y)
	limit_left = 0
	limit_right = int(viewport_size.x)
	
	destroyer.position.y = limit_bottom
	
	# Setup destroyer shape
	var rect_shape = RectangleShape2D.new()
	rect_shape.set_size(Vector2(limit_right, 200))
	destoyer_shape.shape = rect_shape


func _process(_delta):
	if player:
		var limit_distance = 420
		if limit_bottom > player.global_position.y + limit_distance:
			limit_bottom = int(player.global_position.y + limit_distance)
		
		# Delete platform below camera
		overlapping_areas = destroyer.get_overlapping_areas()
		if overlapping_areas.size() > 0:
			for area in overlapping_areas:
				if area is Platform || Enemy || Goal || Boost:
					area.queue_free()


func _physics_process(_delta):
	if player:
		global_position.y = player.global_position.y


func setup_camera(_player: Player):
	if _player:
		player = _player
