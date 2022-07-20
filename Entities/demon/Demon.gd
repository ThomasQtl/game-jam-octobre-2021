extends KinematicBody2D

export var ShowHitZone = false

const S_ATTACK = 1
const S_IDLE = 0


var velocity = Vector2()
var floatTimer = 0.0
const floatRad = 20
var state = 0
var s

# STAT ==============
var Stat_HP = 15
var Stat_DMG = 500
#====================

func _ready():
	$Attack.visible = false
	$Idle.visible = true
	$AttackZone/CollisionShape2D.disabled = true
	$Body.disabled = false
	$Body/Area.visible = ShowHitZone
	$AttackZone/Area.visible = false
	s = get_parent().scale.x
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	floatTimer += delta * 2
	var floating = Vector2(cos(floatTimer) * floatRad, sin(floatTimer) * floatRad)
	if (floatTimer >= 6.2830):
		floatTimer = 0
	get_parent().position += (velocity + floating) / 100


	if state == S_ATTACK and $Attack.frame == 7:
		SetAttackHitBox()
	
	if velocity.x < -0.1:
		get_owner().scale = Vector2(1*s, 1*s)
		
	if velocity.x > 0.1:
		get_owner().scale = Vector2(-1*s, 1*s)
		
	if Stat_HP <= 0:
		queue_free()
	
func Attack():
	state = S_ATTACK
	SetAnimAttack()
	
func SetAttackHitBox():
	$AttackZone/CollisionShape2D.disabled = false
	$AttackZone/Area.visible = ShowHitZone

func SetAnimAttack():
	$Attack.visible = true
	$Idle.visible = false
	$Attack.frame = 0
	
func SetAnimIdle():
	$Attack.visible = false
	$Idle.visible = true
	$Idle.frame = 0
	
func MoveLeft(delta):
	velocity.x -= delta * 10
	
func MoveRight(delta):
	velocity.x += delta * 10
	
	
func hit(dmg):
	Stat_HP -= dmg

func _on_TimeAttack_timeout():
	Attack()
	$TimeAttack.wait_time = rand_range(3, 8)
	

func _on_Attack_animation_finished():
	SetAnimIdle()
	state = S_IDLE
	$AttackZone/CollisionShape2D.disabled = true
	$AttackZone/Area.visible = false


func _on_AttackZone_body_entered(body):
	if state == S_ATTACK:
		if body.name.find("Player") >= 0:
			body.hit(Stat_DMG)
