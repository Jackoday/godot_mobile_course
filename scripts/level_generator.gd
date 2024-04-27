extends Node2D

@onready var platform_parent = $PlatformParent

var platform_scene = preload("res://scenes/platform.tscn")
var boost_item_scene = preload("res://scenes/boost_item.tscn")
var enemy_scene = preload("res://scenes/enemy.tscn")
var goal_scene = preload("res://scenes/goal.tscn")

var viewport_size: Vector2
var platform_width
var platform_height
var start_platform_y
var y_distance_between_platforms: int #set in reset_level()
var max_y_distance_between_platforms = 300
var level_size = 40
var generated_platform_count: int #set in reset_level()
var level_end_pos: int #set when platform is created()
var event_odds: int #set in reset_level()

var player: Player = null


func setup(_player:Player):
	if _player:
		player = _player


func _ready():
	# Initialize variables
	viewport_size = get_viewport_rect().size
	platform_width = platform_scene.instantiate().getWidth() + 2 #gap between
	platform_height = platform_scene.instantiate().getHeight()


func start_generation():
	gernerate_level(viewport_size.y - (y_distance_between_platforms * 2))


func _process(_delta):
	if player:
		var py = player.global_position.y
		var threshold = level_end_pos + viewport_size.y
	
		if py <= threshold:
			gernerate_level(level_end_pos - y_distance_between_platforms)
			y_distance_between_platforms += 15
			if y_distance_between_platforms > max_y_distance_between_platforms:
				y_distance_between_platforms = max_y_distance_between_platforms


func create_platform(location: Vector2, event: bool):
	var platform = platform_scene.instantiate()
	platform.global_position = location
	platform_parent.add_child(platform)
	level_end_pos = platform.global_position.y
	if event: #about first 5 platforms will not get events
		add_event(platform)
	return platform


func add_event(platform):
	var odds: int 
	
	odds = randi_range(20,200)
	if event_odds > odds:
		var new_platform_position = platform.global_position
		new_platform_position.x = randf_range(0, viewport_size.x - platform_width)
		new_platform_position.y += float(y_distance_between_platforms)/2
		create_platform(new_platform_position, false)
	
	odds = randi_range(1,100)
	if event_odds > odds:
		platform.moving = true
		platform.increase_speed(generated_platform_count)
	odds = randi_range(1,100)
	if event_odds > odds:
		platform.vanish = true
		platform.set_cloud()
	
	odds = randi_range(1,100)
	if (float(event_odds)/2) > odds:
		var pick = randi_range(1,3)
		match pick:
			1:
				create_enemy(platform.global_position)
				GameUtility.add_log_msg("create_enemy")
			2:
				create_goal(platform.global_position)
				platform.moving = false
				GameUtility.add_log_msg("create_goal")
			3:
				create_boost(platform.get_global_position())
				platform.moving = false
				GameUtility.add_log_msg("create_boost")


func create_enemy(location: Vector2):
	var enemy = enemy_scene.instantiate()
	enemy.global_position = location
	enemy.position.y -= 30
	platform_parent.add_child(enemy)


func create_goal(location: Vector2):
	var goal = goal_scene.instantiate()
	goal.global_position = location
	platform_parent.add_child(goal)


func create_boost(location: Vector2):
	var boost_item = boost_item_scene.instantiate()
	boost_item.global_position = location
	boost_item.position.y -= 30
	boost_item.position.x += 68
	platform_parent.add_child(boost_item)


func generate_ground():
	var y_position = viewport_size.y - platform_height + 10
	var ground_layer_platform_count = (viewport_size.x / platform_width) + 1
	
	for i in range(ground_layer_platform_count):
		create_platform(Vector2(i * platform_width, y_position), false)


func gernerate_level(start_y: float):
	GameUtility.add_log_msg("New section created")
	for i in range(level_size):
		var location: Vector2 = Vector2.ZERO
		location.x = randf_range(0, viewport_size.x - platform_width)
		location.y = start_y - (y_distance_between_platforms * i)
		generated_platform_count += 1
		create_platform(location, level_end_pos < 300)
	event_odds += 7
	if event_odds > 50:
		event_odds = 50


func reset_level():
	generated_platform_count = 0
	y_distance_between_platforms = 100
	event_odds = 5
	for platform in platform_parent.get_children():
		platform.queue_free()
