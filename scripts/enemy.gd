extends Area2D
class_name Enemy

@onready var ap = $AnimationPlayer

var viewport_size: Vector2
var velocity = Vector2()
var speed = 100
var array: Array[int] = [1, -1]
var dead = false

var fall_animation = "fall"


func _ready():
	viewport_size = get_viewport_rect().size
	velocity.x = array.pick_random()


func _process(delta):
	if !dead:
		if global_position.x > viewport_size.x - getWidth():
			velocity.x = -1
		elif global_position.x < 0:
			velocity.x = 1
		position += velocity.normalized() * speed * delta
	else:
		ap.play(fall_animation)
		velocity.y = 5
		position += velocity * speed * delta

func _on_body_entered(body):
	if !dead:
		if body is Player:
			if body.invincible == false:
				body.velocity.y = 0
				body.die()


func getWidth():
	return $CollisionShape2D.shape.extents.x * 2


func die():
	SoundFX.play("Oof")
	velocity.x = 0
	dead = true
