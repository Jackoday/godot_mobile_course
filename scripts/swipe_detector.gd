extends Node

signal swiped(position: Vector2)

@onready var timer = $Timer

var swipe_start_poition = Vector2()
var min_distance = 30

func _input(event):
	if not event is InputEventScreenTouch:
		return
	if event.pressed:
		_start_detection(event.position)
	elif not timer.is_stopped():
		_end_detection(event.position)


func _start_detection(position: Vector2):
	swipe_start_poition = position
	timer.start()


func _end_detection(position: Vector2):
	timer.stop()
	var direction = (position - swipe_start_poition).normalized()
	if swipe_start_poition.distance_to(position) > min_distance && direction.y < 0:
		emit_signal("swiped", direction)
