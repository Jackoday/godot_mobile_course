extends Node

signal swiped(direction)
signal swipe_canceled(start_position)

@onready var timer = $Timer

var swipe_start_poition = Vector2()

func _input(event):
	if not event is InputEventScreenTouch:
		return
	if event.pressed:
		_start_detection(event.position)
	elif not timer.is_stopped():
		_end_detection(event.position)


func _start_detection(position):
	swipe_start_poition = position
	timer.start()


func _end_detection(position):
	timer.stop()
	var direction = (position - swipe_start_poition).normalized()
	emit_signal("swiped", direction)


func _on_timer_timeout():
	emit_signal('swipe_canceled', swipe_start_poition)
