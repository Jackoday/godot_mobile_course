extends Node2D

signal player_died(score, highscore)
signal pause_game

@onready var level_generator = $LevelGenerator
@onready var ground_sprite = $GroundSprite

@onready var parallax1 = $ParallaxBackground/ParallaxLayer
@onready var parallax2 = $ParallaxBackground/ParallaxLayer2
@onready var parallax3 = $ParallaxBackground/ParallaxLayer3
@onready var day_background = $ParallaxBackground/ParallaxLayer/Sprite2D
@onready var night_background = $ParallaxBackground/ParallaxLayer/Sprite2D2
@onready var stars_background = $ParallaxBackground/ParallaxLayer/Sprite2D3
@onready var game_soundtrack = $GameSoundtrackPlayer
@onready var game_soundtrack_whistle = $GameSoundtrackPlayerWhistle
@onready var game_soundtrack_jc = $GameSoundtrackPlayerJustCrowd

@onready var hud = $UILayer/HUD


var player_scene = preload("res://scenes/player.tscn")
var player: Player = null
var player_spawn_position: Vector2

var camera_scene = preload("res://scenes/game_camera.tscn")
var camera = null

var viewport_size: Vector2

var score: int = 0
var highscore: int = 0
var save_file_path = "user://highscore.save"

var selected_skin = 0

var max_night: float = 1.0/75000.0
var max_stars: float = 1.0/90000.0

var whistle_track = false


func _ready():
	load_score()
	
	viewport_size = get_viewport_rect().size
	
	player_spawn_position.x = viewport_size.x / 2
	player_spawn_position.y = viewport_size.y - 135
	
	ground_sprite.global_position.x = viewport_size.x / 2
	ground_sprite.global_position.y = viewport_size.y
	ground_sprite.visible = false
	
	setup_parallax_layer(parallax1)
	setup_parallax_layer(parallax2)
	setup_parallax_layer(parallax3)
	
	hud.visible = false
	hud.set_score(0)
	hud.pause_game.connect(_on_hud_pause_game)
	
	night_background.self_modulate = Color(1, 1, 1, 0)
	stars_background.self_modulate = Color(1, 1, 1, 0)
	game_soundtrack_jc.play()


func get_parallax_sprite_scale(parallax_sprite: Sprite2D):
	var parallax_sprite_scale = viewport_size.x / parallax_sprite.get_texture().get_width()
	return Vector2(parallax_sprite_scale, parallax_sprite_scale)


func setup_parallax_layer(parallax_layer: ParallaxLayer):
	var parallax_sprite = parallax_layer.find_child("Sprite2D")
	if parallax_sprite != null:
		parallax_sprite.scale = get_parallax_sprite_scale(parallax_sprite)
		parallax_layer.motion_mirroring.y = parallax_sprite.scale.y * parallax_sprite.get_texture().get_height()

func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
		
	if (player):
		if score < viewport_size.y - player.global_position.y:
			score = int(viewport_size.y - player.global_position.y)
		hud.set_score(score)
		
		if (float(score) > 75000):
			night_background.self_modulate = Color(1, 1, 1, 1)
		else:
			night_background.self_modulate = Color(1, 1, 1, float(score)*max_night)
		
		if (float(score) > 90000):
			stars_background.self_modulate = Color(1, 1, 1, 1)
		else:
			stars_background.self_modulate = Color(1, 1, 1, pow(float(score)*max_stars, 4))
		
		if !whistle_track and score > 65000:
			whistle_track = true
			start_whistle_track()



func new_game():
	reset_game()
	score = 0
	SoundFX.play("Whistle")
	
	player = player_scene.instantiate()
	player.global_position = player_spawn_position
	player.died.connect(_on_player_died)
	add_child(player)
	
	if selected_skin > 0:
		player.use_skin(selected_skin)
	
	camera = camera_scene.instantiate()
	camera.setup_camera(player)
	add_child(camera)
	
	if (player):
		level_generator.setup(player)
		level_generator.generate_ground()
		ground_sprite.visible = true
		level_generator.start_generation()
		
	hud.visible = true
	game_soundtrack.play()
	game_soundtrack_jc.stop()


func reset_game():
	game_soundtrack_whistle.stop()
	whistle_track = false
	
	ground_sprite.visible = false
	hud.visible = false
	hud.set_score(0)
	level_generator.reset_level()
	if (player):
		player.queue_free()
		player = null
		level_generator.player = null
	if (camera):
		camera.queue_free()
		camera = null


func _on_player_died():
	hud.visible = false
	
	if score > highscore:
		highscore = score
		save_score()
	
	player_died.emit(score, highscore)
	game_soundtrack.stop()
	game_soundtrack_whistle.stop()
	game_soundtrack_jc.play()

func reset_scene():
	game_soundtrack.stop()
	game_soundtrack_whistle.stop()
	game_soundtrack_jc.play()
	night_background.self_modulate = Color(1, 1, 1, 0)
	stars_background.self_modulate = Color(1, 1, 1, 0)


func save_score():
	var file = FileAccess.open(save_file_path, FileAccess.WRITE)
	file.store_var(highscore)
	GameUtility.add_log_msg("Saving highscore to disk...")
	file.close()


func load_score():
	if FileAccess.file_exists(save_file_path):
		var file = FileAccess.open(save_file_path, FileAccess.READ)
		highscore = file.get_var()
		GameUtility.add_log_msg("Loading highscore from disk: " + str(highscore))
		file.close()


func _on_hud_pause_game():
	pause_game.emit()

func start_whistle_track():
	var main_track_pos = game_soundtrack.get_playback_position()
	game_soundtrack_whistle.play(main_track_pos)
