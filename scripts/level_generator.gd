extends Node2D

@onready var platform_parent = $PlatformParent

var platform_scene = preload("res://scenes/platform.tscn")

var viewport_size
var platform_width
var platform_height
var start_platform_y
var y_distance_between_platforms = 100
var level_size = 50
var generated_platform_count = 0

var player: Player = null


func setup(_player:Player):
	if _player:
		player = _player


func _ready():
	# Initialize variables
	viewport_size = get_viewport_rect().size
	platform_width = platform_scene.instantiate().getWidth() + 2 #gap between
	platform_height = platform_scene.instantiate().getHeight()
	
	generate_ground()
	
	# Generate the rest of the level
	start_platform_y = viewport_size.y - (y_distance_between_platforms * 2)
	gernerate_level(start_platform_y)


func _process(delta):
	if player:
		var py = player.global_position.y
		var level_end_pos = start_platform_y - (generated_platform_count * y_distance_between_platforms)
		var threshold = level_end_pos + viewport_size.y
	
		if py <= threshold:
			gernerate_level(level_end_pos)


func create_platform(location: Vector2):
	var platform = platform_scene.instantiate()
	platform.global_position = location
	platform_parent.add_child(platform)
	return platform


func generate_ground():
	var y_position = viewport_size.y - platform_height + 10
	var ground_layer_platform_count = (viewport_size.x / platform_width) + 1
	
	for i in range(ground_layer_platform_count):
		create_platform(Vector2(i * platform_width, y_position))


func gernerate_level(start_y: float):
	for i in range(level_size):
		var location: Vector2
		location.x = randf_range(0, viewport_size.x - platform_width)
		location.y = start_y - (y_distance_between_platforms * i)
		generated_platform_count += 1
		create_platform(location)
