extends Control


func _ready():
	visible = false
	modulate.a = 0.0
	get_tree().call_group("buttons", "set_disabled", true)


func appear():
	visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.3)
	#await(tween.finished) feels more responsive without waiting for animation
	get_tree().call_group("buttons", "set_disabled", false)


func disappear():
	get_tree().call_group("buttons", "set_disabled", true)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	await(tween.finished)
	visible = false
