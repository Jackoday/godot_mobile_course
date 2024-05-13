extends CanvasLayer

signal start_game
signal delete_level
signal purchase_skin

@onready var console = $Debug/ConsoleLog
@onready var title_screen = $TitleScreen
@onready var pause_screen = $PauseScreen
@onready var game_over_screen = $GameOverScreen
@onready var character_screen = $CharacterScreen
@onready var game_over_score_label = $GameOverScreen/Box/ScoreLabel
@onready var game_over_highscore_label = $GameOverScreen/Box/HighScoreLabel

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
	SoundFX.play("Click")
	match button.name:
		"TitlePlayButton":
			change_screen(null)
			await(get_tree().create_timer(0.3).timeout)
			GameUtility.add_log_msg("1")
			start_game.emit()
		"TitleCharacterSelect":
			change_screen(character_screen)
		"PauseRetryButton":
			change_screen(null)
			await(get_tree().create_timer(0.5).timeout)
			get_tree().paused = false
			start_game.emit()
		"PauseTitleButton":
			change_screen(title_screen)
			get_tree().paused = false
			delete_level.emit()
		"PauseCloseButton":
			change_screen(null)
			await(get_tree().create_timer(0.5).timeout)
			get_tree().paused = false
		"GameOverRetryButton":
			change_screen(null)
			await(get_tree().create_timer(0.3).timeout)
			start_game.emit()
		"GameOverMenuButton":
			change_screen(title_screen)
			delete_level.emit()
		"CharacterBack":
			change_screen(title_screen)
		"SelectNathan":
			purchase_skin.emit()


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


func game_over(score, highscore):
	game_over_score_label.text = "Score: " + str(score)
	game_over_highscore_label.text = "Highscore: " + str(highscore)
	await(get_tree().create_timer(0.5).timeout)
	change_screen(game_over_screen)

func pause_game():
	change_screen(pause_screen)
