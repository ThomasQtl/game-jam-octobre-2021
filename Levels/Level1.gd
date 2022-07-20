extends Node2D

onready var game_over = preload("res://Scenes/EndSreen.tscn")

func _ready():
	pass
	
func _process(delta):
	if $Player.finished:
		get_parent().add_child(game_over.instance())
		queue_free()
