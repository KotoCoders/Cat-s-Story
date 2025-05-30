extends AnimatedSprite2D

@export var mob_scene :PackedScene

func _ready() -> void:
	spawn()

func spawn():
	play("default")
	var mob = mob_scene.instantiate()
	mob.position = position
	get_parent().call_deferred("add_child", mob)
