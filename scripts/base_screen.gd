extends Control

const fade_duration = 0.3


func _ready():
	visible = false
	modulate.a = 0.0
	get_tree().call_group("buttons", "set_disabled", true)


func appear():
	visible = true
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "modulate:a", 1.0, fade_duration)
	#await(tween.finished) feels more responsive without waiting for animation
	get_tree().call_group("buttons", "set_disabled", false)


func disappear():
	get_tree().call_group("buttons", "set_disabled", true)
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "modulate:a", 0.0, fade_duration)
	await(tween.finished)
	visible = false
