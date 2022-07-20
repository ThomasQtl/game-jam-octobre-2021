extends MarginContainer

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_current_scene().get_node("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Player_player_stats_changed(player):
	$HBoxContainer/VBoxContainer/Health/HealthBar.value = player.health / player.max_health * 100
