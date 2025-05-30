extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

@export var max_hp = 5
@export var hp = max_hp


@export var speed = 500


var can_talk_to_npc = false  # Может ли игрок говорить с NPC
var current_npc = null       # NPC, с которым можно говорить
var dialog_ui = null         # Ссылка на диалоговое окно

@export var damage_claws = 20
@export var damage_poof = 30
@export var cooldawn_poof = 3
var can_poof = true

var direction
var can_dash = true

var can_get_damage = true

var inventory = {}

#var bullet_speed = 1200
#var bullet_scene = preload("res://scence/player/attack/bullet.tscn")



enum{
	MOVE,
	DEATH,
	POOF,
	TAKE_DAMAGE,
	DASH,
	PIU
}
func _ready():
	$"../inventory".visible = false
	#dialog_ui = preload("res://scence/chat_box.tscn").instantiate()
	#get_tree().root.add_child(dialog_ui)
	#dialog_ui.hide()
	
var state = MOVE

func _physics_process(_delta):
	if can_poof :
		$cd_poof.play("cd_1")
	else :
		$cd_poof.play("cd")
	if can_dash :
		$cd_dash.play("cd_1")
	else :
		$cd_dash.play("cd")

	match state:
		MOVE:
			MOVE_STATE()
		TAKE_DAMAGE:	#не надо
			TAKE_DAMAGE_STATE()
		POOF:
			POOF_STATE()
		DASH:
			DASH_STATE()
		DEATH:
			DEATH_STATE()
		
	
func MOVE_STATE():
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if direction.x == 0 and direction.y == 0:
		anim.play("idle")
		if $Sounds/movement.playing:
			$Sounds/movement.stop()
	if direction.x < 0:
		anim.play("walk_aside")
		anim.flip_h = true
		if !$Sounds/movement.playing:
			$Sounds/movement.play()
	if direction.x > 0:
		anim.play("walk_aside")
		anim.flip_h = false
		if !$Sounds/movement.playing:
			$Sounds/movement.play()
	if direction.y < 0 and direction.x == 0:
		anim.play("walk_up")
		if !$Sounds/movement.playing:
			$Sounds/movement.play()
	if direction.y > 0 and direction.x == 0:
		anim.play("walk_down")
		if !$Sounds/movement.playing:
			$Sounds/movement.play()
	

	if Input.is_action_just_pressed("action"):
		attack()
	if Input.is_action_just_pressed("rcm") and can_poof and not($AnimationPlayer.is_playing()):
		state = POOF
	if Input.is_action_just_pressed("dash") and can_dash and direction != Vector2.ZERO:
		state = DASH
		
	move_and_slide()



func TAKE_DAMAGE_STATE():
	#play anim
	pass


#!cnockback and damage for every enemy in area 
func POOF_STATE():
	if can_poof == true:
		if $Poof/PoofTimerDuration.is_stopped():
			$Poof/PoofTimerDuration.start()
		$AnimationPlayer.play("poof")
		can_get_damage = false
		if Input.is_action_just_released("rcm"):
			can_get_damage = true
			$Poof/PoofTimerDuration.stop()
			$AnimationPlayer.stop()
			$AnimatedSprite2D.scale.x = 1
			$AnimatedSprite2D.scale.y = 1
			$Poof/PoofTimer.wait_time = cooldawn_poof
			$Poof/PoofTimer.start()
			can_poof = false
			state = MOVE

func DASH_STATE():
	can_dash = false
	velocity = direction * 16000
	$Timers/dash_cooldawn.start()
	
	move_and_slide()
	state = MOVE

func DEATH_STATE():
	if !$Sounds/death.playing:
		$Sounds/death.play()
	await get_tree().create_timer(1).timeout
	


func pick_up_item(item_name, amount):
	if inventory.has(item_name):
		inventory[item_name] += amount
	else:
		inventory[item_name] = amount
	$Sounds/pick_up.play()
	print("Подобран предмет: ", item_name, " (теперь: ", inventory[item_name], ")")

func attack():
	$Claws.look_at(get_global_mouse_position())
	speed = speed*0.25
	$AnimationPlayer.play("attactk")
	if !$Sounds/hit_air.playing:
		$Sounds/hit_air.play()
	await $AnimationPlayer.animation_finished
	speed = speed*4

func damage_aplication(body):
	if body.name != "player":
		if body.has_method("signal_get_damage"):
			body.signal_get_damage(damage_claws, "claws", self.global_position)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("chat") and can_talk_to_npc and current_npc and not $"../chat_box".started_chat:
		$"../chat_box".visible = not $"../chat_box".visible
		$"../chat_box".start_dialog(current_npc.dialog_lines)
	if event.is_action_pressed("Open_Inventory"):  
		$"../inventory".visible = not $"../inventory".visible  
		if ($"../inventory".visible):
			$Camera2D.set_target_offset([-70, 0])
			$Camera2D.zoom_to(Vector2(1.5, 1.5), 0.5)
		else:
			$Camera2D.set_target_offset([0, 0])
			$Camera2D.zoom_to($Camera2D.standart_zoom, 0.5)



func get_damage(damage):
	if can_get_damage:
		hp -= damage
		if hp <=0:
			state = DEATH
		can_get_damage = false
		$Sounds/get_damage.play()
		$AnimatedSprite2D.modulate = Color.ORANGE_RED
		await get_tree().create_timer(0.7).timeout
		$AnimatedSprite2D.modulate = Color.WHITE
		$"../CanvasLayer".hp_changed(hp)
		can_get_damage = true

func get_health_potion():
	hp += 1
	if hp > max_hp:
		hp = max_hp
	$"../CanvasLayer".hp_changed(hp)



func _on_poof_area_body_entered(body):
	if body.name != "player" and body.has_method("signal_get_damage"):
		body.signal_get_damage(damage_poof, "poof", self.global_position)

func _on_poof_timer_timeout():
	can_poof = true
	#$Sounds/cd.play()

func _on_dash_cooldawn_timeout() -> void:
	can_dash = true
	#$Sounds/cd.play()

func _on_poof_timer_duration_timeout() -> void:
	
	can_get_damage = true
	$Poof/PoofTimerDuration.stop()
	$AnimationPlayer.stop()
	$AnimatedSprite2D.scale.x = 1
	$AnimatedSprite2D.scale.y = 1
	$Poof/PoofTimer.wait_time = cooldawn_poof
	$Poof/PoofTimer.start()
	can_poof = false
	state = MOVE

#func fire():
	#var bullet = bullet_scene.instantiate()
	#bullet.position = $Gun/Sprite2D/Node2D/Sprite2D.global_position
	#bullet.rotation = $Gun.rotation
	#bullet.linear_velocity = Vector2(bullet_speed,0).rotated($Gun.rotation)
	#get_tree().get_root().add_child(bullet) 
