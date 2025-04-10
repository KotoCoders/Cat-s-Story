extends CharacterBody2D

@export var hp = 100
@export var speed_idle = 80
@export var speed_chase = 150
@onready var navig_agent = $NavigationAgent2D
var player
var dir:Vector2


var state = States.IDLE
var is_chased = false

enum States {
	IDLE,
	CHASE,
	TAKE_DAMAGE,
	DEATH
	
}

func _physics_process(_delta):
	match state:
		States.IDLE:
			idle_state()
		States.CHASE:
			chase_state()
		States.TAKE_DAMAGE:
			take_damage_state()
		States.DEATH:
			death_state()


func idle_state():
	velocity = dir * speed_idle
	move_and_slide()

func chase_state():
	if is_chased == false:
		is_chased = true
		print("is chased = true")
	_choose_new_direction()
	velocity = dir * speed_chase
	move_and_slide()

func take_damage_state():
	#anim & cnockback
	$AnimatedSprite2D.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	$AnimatedSprite2D.modulate = Color.WHITE
	state = States.CHASE

func death_state():
	$AnimatedSprite2D.modulate = Color.DIM_GRAY
	await get_tree().create_timer(3).timeout
	queue_free()

func signal_take_damage(damage: int, _type):
	#после можно будет сделать с типами урона
	print("нанесён урон")
	hp -= damage
	if hp <= 0:
		state = States.DEATH
	else:
		state = States.TAKE_DAMAGE

func _choose_new_direction():
	if is_chased == false:
		var random_angle = randf_range(0, 2 * PI)
		# Преобразуем угол в вектор направления
		dir = Vector2(cos(random_angle), sin(random_angle))
	else:
		dir = to_local(navig_agent.get_next_path_position()).normalized()






func body_entered_in_area(body):
	print("body_entered_in_area")
	if body.name == "player":
		
		player = body
		$Timers/navigation_timer.start()
		state = States.CHASE

func body_exited_from_area(body):
	print("body_exited_from_area")
	if body.name == "player":
		
		print("is_chased=false")
		is_chased = false
		state = States.IDLE
		
func idle_timer_timeout():
	$Timers/idle_timer.wait_time = randi_range(3, 6)
	if is_chased == false:
		_choose_new_direction()
		await get_tree().create_timer(2).timeout
		dir = Vector2(0,0)

func navigation_timer_timeout():
	select_navigation_to_player()

func select_navigation_to_player():
	navig_agent.target_position = player.global_position
