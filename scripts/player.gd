extends CharacterBody2D
class_name Player

@onready var ap = $AnimationPlayer

var speed = 300.0
var gravity = 15.0
var terminal_velocity = 1000
var jump_velocity = -800
var viewport_size


func _ready():
	viewport_size = get_viewport_rect().size


func _process(delta):
	if velocity.y > 0 and ap.current_animation != "fall":
		ap.play("fall")
	elif velocity.y < 0 and ap.current_animation != "jump":
		ap.play("jump")


func _physics_process(delta):
	velocity.y += gravity
	if velocity.y > terminal_velocity:
		velocity.y = terminal_velocity
	
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
	velocity.y = jump_velocity
