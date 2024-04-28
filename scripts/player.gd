extends CharacterBody2D
class_name Player

signal died

@onready var ap = $AnimationPlayer
@onready var eap = $EffectAnimation/EffectAnimationPlayer
@onready var jump_cshape = $JumpCollisionShape2D
@onready var standard_cshape = $StandardCollisionShape2D
@onready var sprite = $Sprite2D
@onready var projectile_start = $ProjectileStart
@onready var swipe = $SwipeDetector
@onready var shoot_timer = $ShootTimer


var projectile = preload("res://scenes/projectile.tscn")
var parent: Node2D

var speed = 300.0
var accelerometer_speed = 130

var gravity = 15.0
var terminal_velocity = 1000
var jump_velocity = -800
var boost_jump_velocity = -1200
var goal_boost_velocity = -2200
var viewport_size: Vector2

var boost_jumps: int = 0

var use_accelerometer = false

var invincible = false
var dead = false

var fall_animation = "fall"
var jump_animation = "jump"

var fart_animation = "fart"
var boost_animation = "boost"
var clear_effect = "clear"


func _ready():
	viewport_size = get_viewport_rect().size
	parent = get_parent()
	
	var os = OS.get_name()
	if os == "Android" || os == "iOS":
		use_accelerometer = true
	
	swipe.connect("swiped", _shoot)
	
	eap.play(clear_effect)


func _process(_delta):
	if velocity.y > 0 and ap.current_animation != fall_animation:
		ap.play(fall_animation)
		eap.play(clear_effect)
		invincible = false
	elif velocity.y < 0 and ap.current_animation != jump_animation:
		ap.play(jump_animation)
	
	if velocity.y > -500 and eap.current_animation == boost_animation:
			eap.play(clear_effect)


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
	if !dead:
		if boost_jumps > 0:
			SoundFX.play("Fart")
			eap.play(fart_animation)
			velocity.y = boost_jump_velocity
			boost_jumps -= 1
		else:
			SoundFX.play("Jump")
			velocity.y = jump_velocity


func apply_boost_jumps():
	boost_jumps = 4


func _shoot(direction: Vector2):
	if !dead and shoot_timer.time_left == 0:
		shoot_timer.start()
		projectile_start.rotation = direction.angle()
		var ball = projectile.instantiate()
		ball.transform = projectile_start.global_transform
		parent.add_child(ball)
		ball.goal.connect(_on_ball_goal)
		


func _on_ball_goal():
	if !dead:
		SoundFX.play("Boost")
		invincible = true
		eap.play(boost_animation)
		velocity.y = goal_boost_velocity


func _on_visible_on_screen_notifier_2d_screen_exited():
	die()


func die():
	if !dead:
		SoundFX.play("Fall")
		dead = true
		jump_cshape.set_deferred("disabled", true)
		standard_cshape.set_deferred("disabled", true)
		died.emit()


func use_skin(skin: int):
	match skin:
		1: #Nathan
			fall_animation = "fall_nathan"
			jump_animation = "jump_nathan"
			if sprite:
				sprite.texture = preload("res://assets/textures/character/nathan/nathan_idle.png")
