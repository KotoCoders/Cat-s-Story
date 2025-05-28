extends "res://scripts/enemy/basic_enemy.gd"
var attack_dir : Vector2
func attack_state():
	attack_dir = player.global_position - $Bullet_Patern.global_position
	attack_dir = attack_dir.normalized()
	$Bullet_Patern.direction = attack_dir
	$Bullet_Patern.shoot_straight_delayed(5)
	super.attack_state()

func death_state():
	can_attack = false
	can_move = false
	super.death_state()
