extends Area2D
class_name BoostItem


func _on_body_entered(body):
	if body is Player:
		body.apply_boost_jumps()
		queue_free()
