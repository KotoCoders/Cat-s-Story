extends Area2D

func _ready() -> void:
	var sprite_num = randi_range(1,6)
	#$AnimatedSprite2D.animation(str(sprite_num))
	$AnimatedSprite2D.play(str(sprite_num))

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("get_health_potion"):
		body.get_health_potion()
		queue_free()
