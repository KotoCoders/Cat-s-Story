extends "res://basic_enemy.gd"

func attack_state():
	$AnimatedSprite2D.play("attack")
	await $AnimatedSprite2D.animation_finished
	
	$Bullet_Patern.circle_12()
	await get_tree().create_timer(1).timeout
	$Bullet_Patern.circle_12()
	await get_tree().create_timer(1).timeout
	$Bullet_Patern.circle_12()
	await get_tree().create_timer(1).timeout
	
	super.attack_state()
	
