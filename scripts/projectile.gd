extends Node2D

var speed = 300
var accelerometer_speed = 130

var gravity = 15.0
var terminal_velocity = 1000
var jump_velocity = -800


func _ready():
	pass


func _process(_delta):
	pass


func _physics_process(delta):
	position += transform.x * speed * delta
