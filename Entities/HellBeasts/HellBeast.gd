extends KinematicBody2D


var hp := 10;
var ATTACK_POWER := 5;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func hit():
	hp -= 5
	if is_dead():
		queue_free()
	
func _process(delta):
	change_animation()
	
	
func change_animation():
	if position.direction_to(get_parent().get_node("Player").position).x < 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
		
	
func is_dead():
	return hp == 0
