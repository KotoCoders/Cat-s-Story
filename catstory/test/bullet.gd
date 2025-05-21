extends Area2D

@export var speed = 600
@export var direction = Vector2.DOWN

func _process(delta):
	position += direction.normalized() * speed * delta

func _on_Lifetime_timeout():
	queue_free()

func _on_Bullet_body_entered(body):
	if body.name == "player":
		if body.has_method("get_damage"):
			body.get_damage(1)
		queue_free()
