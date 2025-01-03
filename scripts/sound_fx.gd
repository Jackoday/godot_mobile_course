extends Node

@onready var sound_players = get_children()

var sounds = {
	"Click": load("res://assets/sound/Click.wav"),
	"Fall": load("res://assets/sound/Fall.wav"),
	"Jump": load("res://assets/sound/Jump.wav"),
	"Fart": load("res://assets/sound/Fart.wav"),
	"Boost": load("res://assets/sound/Boost.wav"),
	"Horn": load("res://assets/sound/Horn.wav"),
	"Munch": load("res://assets/sound/Munch.wav"),
	"Oof": load("res://assets/sound/Oof.wav"),
	"Whistle": load("res://assets/sound/whistle.wav"),
	"Kick": load("res://assets/sound/Kick.wav")
}


func play(sound_name):
	var sound_to_play = sounds[sound_name]
	for sound_player in sound_players:
		if !sound_player.playing:
			sound_player.stream = sound_to_play
			sound_player.play()
			return
	GameUtility.add_log_msg("Out of available sound players, unable to play sound")
