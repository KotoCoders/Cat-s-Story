extends "res://scripts/enemy/basic_enemy.gd"
func attack_state():
	$AnimatedSprite2D.play("attack")
	await $AnimatedSprite2D.animation_finished
	$Bullet_Patern.circle_12()
	super.attack_state()
	
func death_state():
	can_attack = false
	can_move = false
	$AnimatedSprite2D.modulate = Color.DIM_GRAY
	await get_tree().create_timer(3).timeout
	var small_slime1_scene = preload("res://scence/mobs/small_slime.tscn")
	var small_slime2_scene = preload("res://scence/mobs/small_slime_2.tscn")
	var small_slime1 = small_slime1_scene.instantiate()
	var small_slime2 = small_slime2_scene.instantiate()
	small_slime1.global_position = global_position + Vector2(-20, 0)
	small_slime2.global_position = global_position + Vector2(20, 0)
	get_tree().get_root().add_child(small_slime1) 
	get_tree().get_root().add_child(small_slime2) 
	queue_free()
