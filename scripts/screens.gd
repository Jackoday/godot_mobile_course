extends CanvasLayer

@onready var console = $Debug/ConsoleLog
@onready var title_screen = $TitleScreen
@onready var pause_screen = $PauseScreen
@onready var game_over_screen = $GameOverScreen

var current_screen = null


func _ready():
	console.visible = false
	
	register_buttons()
	change_screen(title_screen)


func register_buttons():
	var buttons = get_tree().get_nodes_in_group("buttons")
	if buttons.size() > 0:
		for button in buttons:
			if button is ScreenButton:
				button.clicked.connect(_on_button_pressed)


func _on_button_pressed(button):
	match button.name:
		"TitlePlayButton":
			print("input1")
			change_screen(pause_screen)
		"PauseRetryButton":
			print("input2")
			change_screen(title_screen)
		"PauseTitleButton":
			pass
		"PauseCloseButton":
			pass
		"GameOverRetryButton":
			pass
		"GameOverMenuButton":
			pass


func _process(_delta):
	pass


func _on_toggle_console_pressed():
	console.visible = !console.visible


func change_screen(new_screen):
	if current_screen:
		await current_screen.disappear()
	if new_screen:
		current_screen = new_screen
		current_screen.appear()
