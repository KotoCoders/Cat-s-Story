extends "res://scripts/enemy/basic_enemy.gd"
func attack_state():
	$AnimatedSprite2D.play("attack")
	await $AnimatedSprite2D.animation_finished
	$Bullet_Patern.shoot_in_4_directions()
	super.attack_state()

func idle_state():
	$AnimatedSprite2D.play("idle")
	super.idle_state()

func chase_state():
	$AnimatedSprite2D.play("idle")
	super.chase_state()

func death_state():
	can_attack = false
	can_move = false
	super.death_state()
