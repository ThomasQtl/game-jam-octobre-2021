extends CanvasLayer

var start_scene = load("res://Scenes/StartScreen.tscn")

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"): #Quit
		get_tree().quit()
	elif Input.is_action_just_pressed("ui_accept"): #Restart
		get_parent().add_child(start_scene.instance())
