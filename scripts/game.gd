extends Node2D

@onready var platform_parent = $PlatformParent

var camera_scene = preload("res://scenes/game_camera.tscn")
var platform_scene = preload("res://scenes/platform.tscn")

var camera = null

# Level gen variables
var start_platform_y
var y_distance_between_platforms = 100
var level_size = 50

func _ready():
	camera = camera_scene.instantiate()
	camera.setup_camera($Player)
	add_child(camera)
	
	#Generate the ground
	var viewport_size = get_viewport_rect().size
	var y_position = viewport_size.y - 60
	var platform_width = platform_scene.instantiate().getWidth() + 2 #gap between
	var ground_layer_platform_count = (viewport_size.x / platform_width) + 1
	
	for i in range(ground_layer_platform_count):
		create_platform(Vector2(i * platform_width, y_position))
		
	# Generate the rest of the level
	start_platform_y = viewport_size.y - (y_distance_between_platforms * 2)
	
	for i in range(level_size):
		var location: Vector2
		location.x = randf_range(0, viewport_size.x - platform_width)
		location.y = start_platform_y - (y_distance_between_platforms * i)
		
		create_platform(location)

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func create_platform(location: Vector2):
	var platform = platform_scene.instantiate()
	platform.global_position = location
	platform_parent.add_child(platform)
	return platform
