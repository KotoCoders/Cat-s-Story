extends CharacterBody2D

@export var hp = 100
const speed_idle = 80
const speed_chase = 150
var player
var dir:Vector2
@onready var alarm_anim = $AnimationPlayer
@onready var navig_agent = $NavigationAgent2D

var state = States.IDLE
var is_chased = false

enum States {
	IDLE,
	CHASE,
}

func _ready():
	pass
	
func _physics_process(_delta):
	match state:
		States.IDLE:
			idle_state()
		States.CHASE:
			chase_state()
			

	
func idle_state():
	velocity = dir * speed_idle
	move_and_slide()

func chase_state():
	if is_chased == false:
		alarm_anim.play("alarm")
		is_chased = true
		print("is chased = true")
		
	_choose_new_direction()
	
	velocity = dir * speed_chase
	move_and_slide()
	
	
	
func _on_area_2d_body_entered_body_entered(body):
	print("_on_area_2d_body_entered_body_entered", body)
	if body.name == "player":
		player = body
		$NavigationAgent2D/Timer.start()
		state = States.CHASE

func _on_area_2d_body_exited_body_exited(body):
	print("_on_area_2d_body_exited_body_exited", body)
	if body.name == "player":
		print("is_chased=false")
		is_chased = false
		state = States.IDLE


func idle_timer_timeout():
	$"../Timer".wait_time = randi_range(3, 6)
	if is_chased == false:
		_choose_new_direction()
		await get_tree().create_timer(2).timeout
		dir = Vector2(0,0)
		 
func _choose_new_direction():
	if is_chased == false:
		# Выбираем случайный угол в радианах (0 - 2*PI)
		var random_angle = randf_range(0, 2 * PI)
		# Преобразуем угол в вектор направления
		dir = Vector2(cos(random_angle), sin(random_angle))
	else:
		dir = to_local(navig_agent.get_next_path_position()).normalized()

func navigation_timer_timeout():
	navig_agent.target_position = player.global_position
