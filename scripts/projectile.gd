extends RigidBody2D

@onready var timer: Timer = $Timer

signal goal

var gravity = 15.0
var terminal_velocity = 600
var initial_velocity = 900


func _ready():
	apply_central_impulse(Vector2(initial_velocity, 0).rotated(rotation))
	timer.start()


func _process(_delta):
	pass


func _physics_process(_delta):
	pass


func _integrate_forces(_state):
	if linear_velocity.y > terminal_velocity:
		linear_velocity.y = terminal_velocity


func _on_timer_timeout():
	queue_free()


func _on_area_2d_area_entered(area):
	if area is Goal:
		goal.emit()
		area.queue_free()
		GameUtility.add_log_msg("Goal")
