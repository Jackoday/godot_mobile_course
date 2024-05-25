extends "res://scripts/base_screen.gd"

@onready var highlight = $Box/ScrollContainer/HBoxContainer/HighlightNode
@onready var carson = $Box/ScrollContainer/HBoxContainer/SelectCarson
@onready var nathan = $Box/ScrollContainer/HBoxContainer/SelectNathan

func _process(_delta):
	if highlight:
		match selected_character:
			0:
				highlight.global_position = carson.global_position
			1:
				highlight.global_position = nathan.global_position
