extends CharacterBody2D

@onready var anim = $AnimatedSprite2D


@export var speed = 500
@export var damage_claws = 10

var bullet_speed = 1200
var bullet_scene = preload("res://scence/player/attack/bullet.tscn")


enum{
	MOVE,
	DEATH,
	POOF,
	PIU
}

var state = MOVE

func _physics_process(_delta):

	match state:
		MOVE:
			MOVE_STATE()
		POOF:
			POOF_STATE()
	
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
	
	
	#$Gun.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("action"):
		attack()
		
	move_and_slide()


func POOF_STATE():
	#play anim poof
	#cnockback and damage for every enemy in area
	pass


func attack():
	$Claws.look_at(get_global_mouse_position())
	speed = speed*0.25
	$AnimationPlayer.play("attactk")
	await $AnimationPlayer.animation_finished
	speed = speed*4
	
func damage_aplication(body):
	if body.name != "player":
		#damage_aplication_claws.emit(body, damage_claws)
		#body.hp -= 10
		if body.has_method("signal_take_damage"):
			body.signal_take_damage(damage_claws, null)
			
		#body.take_damage(damage_claws, null)
		print(body.name)
	
	
func fire():
	var bullet = bullet_scene.instantiate()
	bullet.position = $Gun/Sprite2D/Node2D/Sprite2D.global_position
	bullet.rotation = $Gun.rotation
	bullet.linear_velocity = Vector2(bullet_speed,0).rotated($Gun.rotation)
	get_tree().get_root().add_child(bullet) 
	
