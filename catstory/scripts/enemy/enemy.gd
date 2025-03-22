extends CharacterBody2D

var hp = 100
var speed = 200
var enemy_pos = self.position
var dir:Vector2
@onready var alarm_anim = $AnimationPlayer

enum {
	IDLE,
	CHASE,
}

var state = IDLE
var is_chased = false


func _physics_process(delta):
	match state:
		IDLE:
			idle_state()
		CHASE:
			chase_state()
			

	

	
func idle_state():
	velocity = dir * speed
	move_and_slide()



func chase_state():
	#print("chase")
	if is_chased == false:
		alarm_anim.play("alarm")
		is_chased = true
		print("is chased = true")
	pass

func _on_area_2d_body_entered_body_entered(body):
	if body.name == "player":
		print(body.global_position)
		print(self.global_position)
		state = CHASE

func _on_area_2d_body_exited_body_exited(body):
	if body.name == "player":
		print("is_chased=false")
		is_chased = false
		state = IDLE


func _on_timer_timeout():
	$"../Timer".wait_time = randi_range(1, 3)
	if is_chased == false:
		dir = Vector2(randi_range(-1, 1), randi_range(-1, 1))
		print(dir)
