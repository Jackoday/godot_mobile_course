extends Node2D

@onready var level_generator = $LevelGenerator
@onready var ground_sprite = $GroundSprite

@onready var parallax1 = $ParallaxBackground/ParallaxLayer
@onready var parallax2 = $ParallaxBackground/ParallaxLayer2
@onready var parallax3 = $ParallaxBackground/ParallaxLayer3

var player_scene = preload("res://scenes/player.tscn")
var player: Player = null
var player_spawn_position: Vector2

var camera_scene = preload("res://scenes/game_camera.tscn")
var camera = null

var viewport_size: Vector2


func _ready():
	viewport_size = get_viewport_rect().size
	
	player_spawn_position.x = viewport_size.x / 2
	player_spawn_position.y = viewport_size.y - 135
	
	ground_sprite.global_position.x = viewport_size.x / 2
	ground_sprite.global_position.y = viewport_size.y
	
	setup_parallax_layer(parallax1)
	setup_parallax_layer(parallax2)
	setup_parallax_layer(parallax3)
	
	new_game()


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


func new_game():
	player = player_scene.instantiate()
	player.global_position = player_spawn_position
	add_child(player)
	
	camera = camera_scene.instantiate()
	camera.setup_camera(player)
	add_child(camera)
	
	if (player):
		level_generator.setup(player)
