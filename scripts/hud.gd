extends Control

@onready var topbar = $TopBar
@onready var topbar_background = $TopBarBackground


func _ready():
	var os = OS.get_name()
	if os == "Android" || os == "iOS":
		var safe_area_top = 0
		if os == "Android":
			safe_area_top = DisplayServer.get_display_cutouts()[0].position.y #needs further testing, use iOS method if it doesn't work
		elif os == "iOS":
			safe_area_top = DisplayServer.get_display_safe_area().position.y / DisplayServer.screen_get_scale()
		topbar.position.y += safe_area_top
		topbar_background.size.y += safe_area_top
		
		#logging
		GameUtility.add_log_msg("Window size: " + str(DisplayServer.window_get_size()))
		GameUtility.add_log_msg("Safe area top: " + str(safe_area_top))
		GameUtility.add_log_msg("Top bar position: " + str(topbar.position))


func _on_pause_button_pressed():
	pass # Replace with function body.
