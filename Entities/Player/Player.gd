extends KinematicBody2D

const end_scene = preload("res://Scenes/EndSreen.tscn")

export var move_speed := 50
export var gravity := 1000
export var jump_speed := 250

export var max_health := 20
var health = max_health
var alive = true
var finished = false

var attack_cooldown_time = 500
var next_attack_time = 0
var attack_damage = 5
var attack_playing = false

var velocity := Vector2.ZERO

signal player_stats_changed

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("player_stats_changed", self)
	print("p")


func _physics_process(delta):
	velocity.x = 0
	
	if alive:
		if position.y >= 300:
			 hit(1)
		
		if Input.is_action_pressed("move_right"):
			velocity.x += move_speed
		if Input.is_action_pressed("move_left"):
			velocity.x -= move_speed
		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				velocity.y = -jump_speed
	
	velocity.y += gravity*delta
	
	if velocity.x > 0:
		$RayCast2D.cast_to = Vector2.RIGHT
	elif velocity.x < 0:
		$RayCast2D.cast_to = Vector2.LEFT
	
	velocity = move_and_slide(velocity, Vector2.UP)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if alive:
		change_animation()

func change_animation():
	
	# Pour qu'il arrête d'attacker
	if $AnimatedSprite.animation == "attack" && $AnimatedSprite.frame == $AnimatedSprite.frames.get_frame_count("attack") - 1:
		attack_playing = false
	
	# face left or right
	if velocity.x > 0:
		$AnimatedSprite.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite.flip_h = true
	if velocity.y < 0 and not attack_playing: # negative Y is up
		$AnimatedSprite.play("jump")
	else:
		if velocity.x != 0 and not attack_playing:
			$AnimatedSprite.play("run")
		elif not attack_playing:
			$AnimatedSprite.play("idle")

func _input(event):
	if event.is_action_pressed("attack") && alive:
		# Check if player can attack
		var now = OS.get_ticks_msec()
		if now >= next_attack_time:
			# What's the target ?
			$AnimatedSprite.play("attack")
			var target = $RayCast2D.get_collider()
			if target != null:
				# if target.name.find("monster") >= 0:
				target.hit(attack_damage)
			attack_playing = true
			# Add cooldown time to current time
			next_attack_time = now + attack_cooldown_time


func hit(dmg):
	if alive:
		health -= dmg
		emit_signal("player_stats_changed", self)
		if health <= 0:
			death()

func death():
	$AnimatedSprite.animation = "hurt"
	health = 0
	emit_signal("player_stats_changed", self)
	alive = false


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "death":
		finished = true
	if $AnimatedSprite.animation == "hurt":
		$AnimatedSprite.play("death")
	
