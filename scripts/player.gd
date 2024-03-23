extends CharacterBody2D
class_name Player

signal died

@onready var ap = $AnimationPlayer
@onready var cshape = $CollisionShape2D
@onready var sprite = $Sprite2D
@onready var projectile_start = $ProjectileStart


var projectile = preload("res://scenes/projectile.tscn")
var parent: Node2D

var speed = 300.0
var accelerometer_speed = 130

var gravity = 15.0
var terminal_velocity = 1000
var jump_velocity = -800
var viewport_size: Vector2

var use_accelerometer = false

var dead = false

var fall_animation = "fall"
var jump_animation = "jump"


func _ready():
	viewport_size = get_viewport_rect().size
	parent = get_parent()
	
	var os = OS.get_name()
	if os == "Android" || os == "iOS":
		use_accelerometer = true


func _process(_delta):
	if velocity.y > 0 and ap.current_animation != fall_animation:
		ap.play(fall_animation)
	elif velocity.y < 0 and ap.current_animation != jump_animation:
		ap.play(jump_animation)


func _physics_process(_delta):
	velocity.y += gravity
	if velocity.y > terminal_velocity:
		velocity.y = terminal_velocity
	
	if !dead:
		if use_accelerometer:
			var mobile_input = Input.get_accelerometer()
			velocity.x = mobile_input.x * accelerometer_speed
			
		else:
			var direction = Input.get_axis("move_left", "move_right")
			if direction:
				velocity.x = direction * speed
			else:
				velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide()
	
	var margin = 20
	if global_position.x > viewport_size.x + margin:
		global_position.x = -margin
	elif global_position.x < -margin:
		global_position.x = viewport_size.x + margin


func jump():
	SoundFX.play("Jump")
	velocity.y = jump_velocity
	shoot()#remove me


func shoot():
	var ball = projectile.instantiate()
	parent.add_child(ball)
	ball.transform = projectile_start.global_transform


func _on_visible_on_screen_notifier_2d_screen_exited():
	die()


func die():
	if !dead:
		SoundFX.play("Fall")
		dead = true
		cshape.set_deferred("disabled", true)
		died.emit()

func use_skin(skin: int):
	match skin:
		1: #Nathan
			fall_animation = "fall_nathan"
			jump_animation = "jump_nathan"
			if sprite:
				sprite.texture = preload("res://assets/textures/character/nathan/nathan_idle.png")
