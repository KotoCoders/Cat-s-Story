extends CharacterBody2D

@onready var anim = $AnimatedSprite2D


var speed = 300
var bullet_speed = 1200
var bullet_scene = preload("res://scence/player/attack/bullet.tscn")


enum{
	MOVE,
	DEATH,
	PIU
}

var state = MOVE

func _physics_process(_delta):

	match state:
		MOVE:
			MOVE_STATE()
	
func MOVE_STATE():
	
	
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if direction.x == 0 and direction.y == 0:
		anim.play("idle")
	if direction.x < 0:
		anim.play("walk_aside")
		anim.flip_h = true
	if direction.x > 0:
		anim.play("walk_aside")
		anim.flip_h = false
	if direction.y < 0 and direction.x == 0:
		anim.play("walk_up")
	if direction.y > 0 and direction.x == 0:
		anim.play("walk_down")
		
	$Claws.look_at(get_global_mouse_position())
	#$Gun.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("action"):
		attack()
		
	move_and_slide()
	
func attack():
	speed = speed*0.25
	$Claws.visible = true
	$Claws/AnimatedSprite2D.play("attactk")
	await $Claws/AnimatedSprite2D.animation_finished
	$Claws.visible = false
	speed = speed*4
	
func fire():
	var bullet = bullet_scene.instantiate()
	bullet.position = $Gun/Sprite2D/Node2D/Sprite2D.global_position
	bullet.rotation = $Gun.rotation
	bullet.linear_velocity = Vector2(bullet_speed,0).rotated($Gun.rotation)
	get_tree().get_root().add_child(bullet) 
	
