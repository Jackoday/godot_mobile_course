extends Area2D
class_name Platform

var viewport_size: Vector2
var moving = false
var array: Array[int] = [1, -1]
var velocity = Vector2()
var speed = 100

var vanish = false

func _ready():
	viewport_size = get_viewport_rect().size
	velocity.x = array.pick_random()

func _on_body_entered(body):
	if body is Player:
		if body.velocity.y > 0:
			body.jump()
			if vanish:
				queue_free()

func getWidth():
	return $CollisionShape2D.shape.extents.x * 2

func getHeight():
	return $Sprite2D.texture.get_height()

func _physics_process(delta):
	if moving:
		if global_position.x > viewport_size.x - getWidth():
			velocity.x = -1
		elif global_position.x < 0:
			velocity.x = +1
		position += velocity.normalized() * speed * delta
