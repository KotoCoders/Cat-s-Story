extends Node2D
var hp = 100
var speed = 100

enum {
	IDLE
}

var state = IDLE

func _physics_process(delta):
	
	match state:
		IDLE:
			idle_state()
	
	
func idle_state():
	pass
